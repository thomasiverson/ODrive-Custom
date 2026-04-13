#include "acim_estimator.hpp"
#include <board.h>

/**
 * @brief Updates the AC Induction Motor rotor flux and phase estimates.
 *
 * Implements a simplified rotor flux observer for sensorless control of
 * AC induction motors. The estimator uses d-q axis currents and rotor
 * velocity to compute rotor flux magnitude, slip velocity, and stator
 * electrical phase angle.
 *
 * On the first active call (after inputs become available), the estimator
 * initializes its internal state and returns without producing an output.
 * Subsequent calls perform numerical integration of rotor flux and slip
 * phase using a first-order lag model.
 *
 * If any required input source is unavailable, the estimator transitions
 * to an inactive state and returns immediately.
 *
 * @param timestamp Current time in HCLK ticks (TIM_1_8_CLOCK_HZ resolution),
 *                  used to compute the integration time step (dt). Must be
 *                  monotonically increasing.
 *
 * @return void. Results are stored in member variables:
 *         - rotor_flux_: estimated rotor flux magnitude [A-equivalent]
 *         - slip_vel_: estimated slip velocity [rad/s]
 *         - stator_phase_: estimated stator electrical angle [rad, -π to π]
 *         - stator_phase_vel_: estimated stator electrical velocity [rad/s]
 *
 * @pre rotor_phase_src_, rotor_phase_vel_src_, and idq_src_ must be
 *      connected to valid signal sources.
 * @pre config_.slip_velocity must be configured to 1/Tr (inverse rotor
 *      time constant) before calling.
 *
 * @note This function must be called at a fixed rate from the control loop
 *       (typically once per PWM cycle). It is not thread-safe and must not
 *       be called concurrently or from an ISR while another invocation is
 *       in progress.
 * @note Slip velocity is clamped to zero when rotor flux is near zero to
 *       avoid division-by-zero or numerical instability.
 */
void AcimEstimator::update(uint32_t timestamp)  {
    // Fetch all required inputs from connected ports
    // Early return if any input is unavailable to prevent estimation with incomplete data
    std::optional<float> rotor_phase = rotor_phase_src_.present();
    std::optional<float> rotor_phase_vel = rotor_phase_vel_src_.present();
    std::optional<float2D> idq = idq_src_.present();

    if (!rotor_phase.has_value() || !rotor_phase_vel.has_value() || !idq.has_value()) {
        active_ = false;
        return;
    }

    // Extract d-q axis current components using structured binding
    auto [id, iq] = *idq;

    // Calculate time step for numerical integration
    // Uses high-resolution timer for accurate flux estimation
    const float dt = static_cast<float>(timestamp - last_timestamp_) / static_cast<float>(TIM_1_8_CLOCK_HZ);
    last_timestamp_ = timestamp;

    if (!active_) {
        // Initialize estimator state on first active iteration
        // Prevents integration of garbage values and ensures clean startup
        rotor_flux_ = 0.0f;
        phase_offset_ = 0.0f;
        active_ = true;
        return;
    }

    // Rotor flux estimation using first-order lag model
    // The effect of current commands on actual currents has ~1.5 PWM cycles delay
    // However, rotor time constant (typically 0.1-1s) is much slower than PWM period (~100us)
    // Therefore we treat the effect as immediate for cleaner code without loss of accuracy

    // Update rotor flux estimate using exponential model: dψ/dt = (1/Tr) * (Lm*id - ψr)
    // Normalized to [A] units where rotor inductance is absorbed into slip_velocity gain
    const float dflux_by_dt = config_.slip_velocity * (id - rotor_flux_);
    rotor_flux_ += dflux_by_dt * dt;
    
    // Calculate slip velocity from torque-producing current and rotor flux
    // slip_velocity = (1/Tr) * (iq / flux_r) where Tr is rotor time constant
    float slip_velocity = config_.slip_velocity * (iq / rotor_flux_);
    
    // Clamp slip velocity to prevent numerical instability from small flux denominators
    // Limit to physically reasonable values based on maximum acceleration per time step
    if (is_nan(slip_velocity) || (std::abs(slip_velocity) > 0.1f / dt)) {
        slip_velocity = 0.0f;
    }
    slip_vel_ = slip_velocity;

    // Compute stator electrical frequency and phase angle
    // Stator frequency = rotor mechanical frequency + slip frequency
    stator_phase_vel_ = *rotor_phase_vel + slip_velocity;
    
    // Integrate slip velocity to track phase offset between rotor and stator
    // Wrapped to [-π, π] to prevent unbounded accumulation
    phase_offset_ = wrap_pm_pi(phase_offset_ + slip_velocity * dt);
    
    // Final stator electrical angle combines rotor mechanical angle with accumulated slip
    stator_phase_ = wrap_pm_pi(*rotor_phase + phase_offset_);
}
