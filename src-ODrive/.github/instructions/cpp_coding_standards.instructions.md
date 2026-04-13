---
applyTo: "**/*.cpp,**/*.c,**/*.cc,**/*.h,**/*.hpp"
description: "C++ coding standards for ODrive embedded firmware — naming, style, modern C++, header structure, memory, ISR safety, real-time, and hardware patterns."
---

# C++ Coding Standards for Embedded Firmware

Unified coding standards for all C/C++ code in the ODrive project (STM32 ARM Cortex-M4F, FreeRTOS).

---

## Naming Conventions

| Element | Style | Example |
|---------|-------|---------|
| Classes/Structs | PascalCase | `MotorController`, `AxisConfig` |
| Functions/Methods | camelCase | `calculatePosition()`, `isEnabled()` |
| Variables | camelCase | `targetSpeed`, `encoderCount` |
| Private members | camelCase + trailing `_` | `speed_`, `isCalibrated_` |
| Constants | kPascalCase | `kMaxVoltage`, `kBufferSize` |
| Enums | `enum class` PascalCase | `MotorState::Running` |
| Namespaces | lowercase_with_underscores | `motor_control` |
| Files | lowercase_with_underscores | `motor_controller.cpp` |
| Macros (avoid) | UPPER_CASE | `#define MAX_VOLTAGE` — prefer `constexpr` |

- Boolean getters: prefix with `is`, `has`, `can`, `should`
- File extensions: `.hpp` for headers, `.cpp` for implementation

---

## Header File Rules

### Include Guards
Use `#pragma once` at the top of every header.

### Header Structure Order
1. `#pragma once`
2. File header comment (`@file`, `@brief`)
3. System includes (alphabetical)
4. Third-party includes (alphabetical)
5. Project includes (alphabetical)
6. Forward declarations
7. Namespace → constants → enums → class

### Include What You Use (IWYU)
- Forward-declare for pointers/references: `class Motor;`
- Full include required for: value members, inheritance, method calls, `sizeof()`
- **NEVER** `using namespace` at global scope in headers

### Include Order (in .cpp files)
1. Related header (first — tests self-containment)
2. C system headers (`<cstdint>`)
3. C++ standard library (`<vector>`)
4. Third-party (`<arm_math.h>`)
5. Project headers

### Inline in Headers
Only: templates, `constexpr`, trivial 1-2 line getters/setters.

---

## Code Formatting

- **4 spaces** indentation (no tabs)
- **120 char** max line length
- Opening brace on **same line**
- **Always use braces** for single-line conditionals
- Space after keywords (`if (`, `for (`), no space for calls (`func(arg)`)
- `++i` preferred over `i++`

---

## Modern C++ (C++17 minimum)

- Use `auto` when type is obvious from context; explicit for primitives
- Range-based `for` loops over index-based
- `constexpr` for compile-time constants and functions
- `enum class` over plain `enum`
- `std::unique_ptr` / `std::shared_ptr` over raw owning pointers
- `override` and `final` on virtual methods
- `[[nodiscard]]` on functions where ignoring return is a bug
- `explicit` on single-argument constructors
- `using` over `typedef`
- Structured bindings: `auto& [id, motor] = pair;`
- Every class: explicitly declare copy/move semantics

---

## Documentation

- **File headers**: `@file`, `@brief`, `@author`
- **Classes**: `@brief`, thread-safety notes, usage example
- **Methods**: `@brief`, `@param`, `@return`, `@note`/`@warning`
- **Inline comments**: explain WHY, not WHAT

---

## Error Handling

- **Embedded code**: use error codes (no exceptions — too much overhead)
- **Non-embedded utilities**: exceptions acceptable for truly exceptional conditions
- `std::optional` for values that may not exist
- Always check return codes; use `[[nodiscard]]` to enforce

```cpp
enum class MotorError : uint8_t { None, OverVoltage, EncoderFault, Timeout };

[[nodiscard]] MotorError Motor::initialize() {
    if (!encoder_.detect()) return MotorError::EncoderFault;
    return MotorError::None;
}
```

---

## Memory Management (Embedded)

- **No `new`/`delete` in real-time code** — stack or static allocation only
- `std::array` over `std::vector` (fixed-size, no heap fragmentation)
- Heap allocation acceptable only during initialization
- Use object pools for dynamic-like behavior without fragmentation
- Beware static initialization order — use Meyers Singleton pattern

```cpp
// ✅ Stack/static allocation
void processData() { uint8_t buffer[256]; }
static MotorController motors[2];

// ❌ NEVER in control loop or ISR
void controlLoop() { auto* d = new SensorData(); }
```

---

## Interrupt Safety (Embedded)

### Volatile & Atomics
- `volatile` for ISR-shared variables and hardware registers
- `std::atomic` for shared counters/flags
- Never do non-atomic read-modify-write on shared data

### Critical Sections
Use RAII pattern to disable/re-enable interrupts:

```cpp
class CriticalSection {
public:
    CriticalSection() { __disable_irq(); }
    ~CriticalSection() { __enable_irq(); }
    CriticalSection(const CriticalSection&) = delete;
    CriticalSection& operator=(const CriticalSection&) = delete;
};
```

### ISR Rules
- Keep ISRs **SHORT** — read hardware, set flag, return
- Defer heavy processing to main loop or FreeRTOS task
- No floating-point math, no dynamic allocation, no blocking in ISRs

---

## Real-Time Constraints (Embedded)

- **Bounded execution time** on all code paths — no unbounded loops
- **No blocking waits** without timeouts
- Watchdog timer for fault recovery
- Fixed-point math when FPU is unavailable or determinism is critical
- Cortex-M4F has hardware FPU — `float` operations are fast

```cpp
// ✅ Non-blocking with timeout
bool waitForReady(uint32_t timeoutMs) {
    uint32_t start = HAL_GetTick();
    while (!isReady()) {
        if (HAL_GetTick() - start > timeoutMs) return false;
    }
    return true;
}
```

---

## Hardware Abstraction (Embedded)

- Encapsulate hardware access in classes (e.g., `Stm32Gpio`)
- RAII for peripheral state (SPI chip-select, DMA lifecycle)
- Memory barriers (`__DMB()`, `__ISB()`) before DMA/peripheral starts
- Direct register access only in performance-critical paths (ISR, control loop)

```cpp
// RAII for SPI chip-select
class SpiTransaction {
public:
    SpiTransaction(Stm32Gpio& cs) : cs_(cs) { cs_.write(false); }
    ~SpiTransaction() { cs_.write(true); }
    SpiTransaction(const SpiTransaction&) = delete;
private:
    Stm32Gpio& cs_;
};
```

---

## Safety-Critical Patterns (Embedded)

- **Validate all inputs**: check for NaN, Inf, out-of-range
- **Assert invariants** in debug builds
- **State machine transitions**: validate explicitly, reject invalid transitions
- **Fault handling**: disable PWM first, log error, notify host, enter fault state
- **Watchdog**: initialize early, kick regularly in control loop

```cpp
bool Motor::setSpeed(float speed) {
    if (std::isnan(speed) || std::isinf(speed)) return false;
    if (speed < kMinSpeed || speed > kMaxSpeed) return false;
    speed_ = speed;
    return true;
}
```

---

## Performance

- `constexpr` for compile-time computation
- `__builtin_expect` for branch prediction hints
- `__attribute__((always_inline))` for critical-path functions
- Pass large objects by `const&`, small types by value
- `emplace_back` over `push_back`
- Profile before optimizing — optimize hot paths only

---

## General Design

- **Single responsibility**: each class/function does one thing
- **Composition over inheritance**: avoid deep hierarchies
- **No magic numbers**: use named `constexpr` constants
- **Functions under 50 lines**
- **const correctness**: mark methods and variables `const` where possible

---

## Summary Checklist

### Style
- [ ] Naming follows conventions (PascalCase classes, camelCase functions)
- [ ] Modern C++17 features used appropriately
- [ ] Doxygen documentation for public APIs
- [ ] All variables initialized, `const` applied
- [ ] No magic numbers, no raw owning pointers

### Headers
- [ ] `#pragma once`, self-contained, IWYU
- [ ] No `using namespace` at global scope
- [ ] Forward declarations where possible

### Embedded
- [ ] No dynamic allocation in real-time paths
- [ ] `volatile`/atomics for ISR-shared data
- [ ] ISRs are short — defer work to main loop
- [ ] All paths have bounded execution time
- [ ] Inputs validated (NaN, range checks)
- [ ] Error codes used (not exceptions)
- [ ] RAII for hardware state management
- [ ] Fault states defined and handled
---
applyTo: "**/*.cpp,**/*.c,**/*.cc,**/*.h,**/*.hpp"
description: "C++ coding standards for ODrive firmware. Covers naming, style, modern C++ idioms, header structure, and includes for all C/C++ files."
---

# C++ Coding Standards

This document defines coding standards for all C++ source and header files. For embedded-specific constraints (memory, ISR, real-time, hardware), see `embedded_cpp_best_practices.instructions.md`.

---

## Naming Conventions

### Classes and Structs
- **PascalCase** for class and struct names
- Use descriptive, noun-based names
- Avoid abbreviations unless universally understood

```cpp
// ✅ GOOD
class MotorController { };
class EncoderInterface { };
struct AxisConfiguration { };

// ❌ BAD
class motorcontroller { };  // Wrong case
class MC { };               // Too abbreviated
class motor_controller { }; // Wrong style
```

### Functions and Methods
- **camelCase** for function and method names
- Use verb-based names describing the action
- Boolean-returning functions should be prefixed with `is`, `has`, `can`, `should`

```cpp
// ✅ GOOD
void calculatePosition();
bool isMotorEnabled() const;
float getVelocity() const;
void setTargetSpeed(float speed);
bool hasError() const;

// ❌ BAD
void CalculatePosition();  // Wrong case
bool motorEnabled();       // Missing "is" prefix
float velocity();          // Unclear if getter or property
void speed(float s);       // Unclear setter
```

### Variables
- **camelCase** for local variables and parameters
- **camelCase with trailing underscore** for private member variables
- Use descriptive names, avoid single letters except for loops

```cpp
class Motor {
public:
    void setSpeed(float targetSpeed) {  // Parameter
        float acceleration = 10.0f;     // Local variable
        speed_ = targetSpeed;           // Member variable
    }

private:
    float speed_;              // Private member
    int encoderPosition_;      // Private member
    bool isCalibrated_;        // Private member
};

// Loop counters - single letters acceptable
for (size_t i = 0; i < count; ++i) {
    for (size_t j = 0; j < width; ++j) {
        // ...
    }
}
```

### Constants and Enumerations
- **UPPER_CASE_WITH_UNDERSCORES** for macros (avoid when possible)
- **kPascalCase** for compile-time constants
- **enum class** in PascalCase, values in PascalCase

```cpp
// ✅ GOOD - Compile-time constants
constexpr float kMaxVoltage = 56.0f;
constexpr size_t kBufferSize = 256;
const int kDefaultTimeout = 1000;

// ✅ GOOD - Enumerations
enum class MotorState : uint8_t {
    Idle,
    Calibrating,
    Running,
    Error
};

enum class ErrorCode {
    Success,
    InvalidParameter,
    HardwareFailure,
    Timeout
};

// ❌ BAD - Avoid macros
#define MAX_VOLTAGE 56.0  // No type safety
#define BUFFER_SIZE 256   // No scope
```

### Namespaces
- **lowercase_with_underscores** for namespaces
- Keep namespace names short and descriptive
- Avoid using `using namespace` in headers

```cpp
// ✅ GOOD
namespace motor_control {
namespace detail {
    // Implementation details
}
}

// Usage
motor_control::MotorController controller;

// ❌ BAD
namespace MotorControl { }      // Wrong case
namespace motor_control_system { } // Too verbose
```

### Type Aliases
- **PascalCase** for type aliases
- Use descriptive names that clarify intent

```cpp
// ✅ GOOD
using MotorId = uint32_t;
using CallbackFunction = std::function<void(ErrorCode)>;
using AxisArray = std::array<Axis, 2>;

// ❌ BAD
using motorid = uint32_t;     // Wrong case
using CB = std::function<void(ErrorCode)>;  // Too abbreviated
```

### File Names
- **lowercase_with_underscores** for file names
- Match class name in content (snake_case version)
- `.hpp` for headers, `.cpp` for implementation

```cpp
// ✅ GOOD
motor_controller.hpp
motor_controller.cpp
encoder_interface.hpp
axis_config.hpp

// ❌ BAD
MotorController.hpp  // Wrong case
motorcontroller.h    // No separator
motor-controller.hpp // Wrong separator
```

---

## Code Organization

### Header File Structure
```cpp
#pragma once  // Preferred over include guards

// 1. System includes
#include <cstdint>
#include <memory>
#include <vector>

// 2. Third-party includes
#include <external_lib/header.hpp>

// 3. Project includes
#include "encoder_interface.hpp"
#include "motor_config.hpp"

// 4. Forward declarations (if needed)
class GateDriver;

// 5. Namespace
namespace motor_control {

// 6. Constants and types
constexpr float kDefaultGain = 1.0f;

enum class ControlMode {
    Voltage,
    Current,
    Velocity,
    Position
};

// 7. Class declaration
class MotorController {
public:
    // Public types first
    using StatusCallback = std::function<void(ErrorCode)>;
    
    // Constructors and destructor
    MotorController();
    explicit MotorController(const MotorConfig& config);
    ~MotorController();
    
    // Delete copy, allow move
    MotorController(const MotorController&) = delete;
    MotorController& operator=(const MotorController&) = delete;
    MotorController(MotorController&&) noexcept = default;
    MotorController& operator=(MotorController&&) noexcept = default;
    
    // Public methods - getters first, then setters, then actions
    float getSpeed() const;
    ControlMode getMode() const;
    
    void setSpeed(float speed);
    void setMode(ControlMode mode);
    
    bool initialize();
    void update();
    
private:
    // Private methods
    void updateControl();
    bool validateSpeed(float speed) const;
    
    // Member variables (grouped logically)
    float speed_ = 0.0f;
    float targetSpeed_ = 0.0f;
    ControlMode mode_ = ControlMode::Voltage;
    bool isInitialized_ = false;
    
    // Subsystems
    std::unique_ptr<EncoderInterface> encoder_;
    std::unique_ptr<GateDriver> driver_;
};

}  // namespace motor_control
```

### Implementation File Structure
```cpp
#include "motor_controller.hpp"

// System includes
#include <cmath>
#include <algorithm>

// Project includes
#include "gate_driver.hpp"
#include "utils/math_utils.hpp"

namespace motor_control {

// Anonymous namespace for file-local helpers
namespace {
    constexpr float kSpeedLimit = 10000.0f;
    
    float clampSpeed(float speed) {
        return std::clamp(speed, -kSpeedLimit, kSpeedLimit);
    }
}

// Constructor implementation
MotorController::MotorController()
    : encoder_(std::make_unique<EncoderInterface>())
    , driver_(std::make_unique<GateDriver>()) {
}

// Method implementations
float MotorController::getSpeed() const {
    return speed_;
}

void MotorController::setSpeed(float speed) {
    targetSpeed_ = clampSpeed(speed);
}

bool MotorController::initialize() {
    if (isInitialized_) {
        return true;
    }
    
    if (!encoder_->initialize()) {
        return false;
    }
    
    if (!driver_->initialize()) {
        return false;
    }
    
    isInitialized_ = true;
    return true;
}

}  // namespace motor_control
```

---

## Documentation Standards

### File Headers
```cpp
/**
 * @file motor_controller.hpp
 * @brief Motor control implementation with current/velocity/position modes
 * 
 * This file provides the main motor control interface for the ODrive system.
 * Supports multiple control modes and encoder feedback.
 * 
 * @author ODrive Robotics
 * @date 2026-01-14
 */
```

### Class Documentation
```cpp
/**
 * @brief Controls a single motor with multiple control modes
 * 
 * The MotorController class provides high-level motor control functionality
 * including velocity control, position control, and current control modes.
 * 
 * Thread-safety: This class is not thread-safe. External synchronization
 * is required if accessed from multiple threads.
 * 
 * Example usage:
 * @code
 * MotorController motor;
 * if (motor.initialize()) {
 *     motor.setMode(ControlMode::Velocity);
 *     motor.setSpeed(1000.0f);  // 1000 RPM
 *     motor.update();
 * }
 * @endcode
 */
class MotorController {
    // ...
};
```

### Method Documentation
```cpp
/**
 * @brief Sets the target motor speed
 * 
 * Sets the desired motor speed in RPM. The actual speed will be achieved
 * gradually based on the configured acceleration limits.
 * 
 * @param speed Target speed in RPM, range [-10000, 10000]
 * @return true if speed was set successfully, false if out of range
 * 
 * @note This function clamps the speed to valid range automatically
 * @warning Ensure motor is initialized before calling this function
 * 
 * @see getSpeed(), setMode()
 */
bool setSpeed(float speed);
```

### Inline Comments
```cpp
// Use comments to explain WHY, not WHAT
void calculateTorque() {
    // Apply Clarke transform to convert three-phase to two-phase
    float alpha = current.a;
    float beta = (current.a + 2.0f * current.b) / sqrtf(3.0f);
    
    // Park transform to rotate into d-q frame
    // This allows independent control of torque and flux
    float d = alpha * cosf(theta) + beta * sinf(theta);
    float q = -alpha * sinf(theta) + beta * cosf(theta);
    
    // ✅ GOOD: Explains reasoning
    // Limit current to prevent overheating
    if (q > kMaxCurrent) {
        q = kMaxCurrent;
    }
    
    // ❌ BAD: States the obvious
    // Set q to max current
    if (q > kMaxCurrent) {
        q = kMaxCurrent;
    }
}
```

---

## Modern C++ Best Practices

### Use Modern Initialization
```cpp
// ✅ GOOD - Uniform initialization (C++11)
int count{0};
float speed{100.0f};
std::vector<int> values{1, 2, 3, 4, 5};
MotorController motor{config};

// ✅ GOOD - Member initialization in constructor
MotorController::MotorController()
    : speed_{0.0f}
    , mode_{ControlMode::Voltage}
    , isEnabled_{false} {
}

// ❌ BAD - Old-style initialization
int count = 0;
float speed = 100.0f;
```

### Use Auto Appropriately
```cpp
// ✅ GOOD - Clear from context
auto values = std::vector<float>{1.0f, 2.0f, 3.0f};
auto motor = std::make_unique<MotorController>();
auto it = container.find(key);

// ✅ GOOD - Avoid repetition
std::map<std::string, std::unique_ptr<Motor>> motors;
auto it = motors.find("axis0");  // Clear and concise

// ⚠️ CAUTION - Type not obvious
auto result = complexCalculation();  // What type?

// ✅ BETTER - Explicit when unclear
float result = complexCalculation();
```

### Use Range-Based For Loops
```cpp
// ✅ GOOD - Range-based for
std::vector<Motor> motors;
for (const auto& motor : motors) {
    motor.update();
}

// ✅ GOOD - Structured bindings (C++17)
std::map<int, Motor> motorMap;
for (const auto& [id, motor] : motorMap) {
    std::cout << "Motor " << id << " speed: " << motor.getSpeed();
}

// ❌ BAD - Index-based when not needed
for (size_t i = 0; i < motors.size(); ++i) {
    motors[i].update();
}
```

### Use constexpr and const
```cpp
// ✅ GOOD - constexpr for compile-time constants
constexpr float kMaxVoltage = 56.0f;
constexpr size_t kBufferSize = 256;

// ✅ GOOD - constexpr functions
constexpr float degreesToRadians(float degrees) {
    return degrees * 3.14159f / 180.0f;
}

// ✅ GOOD - const member functions
class Motor {
public:
    float getSpeed() const { return speed_; }
    bool isEnabled() const { return enabled_; }
    
private:
    float speed_;
    bool enabled_;
};
```

### Use Smart Pointers
```cpp
// ✅ GOOD - Unique ownership
std::unique_ptr<Motor> motor = std::make_unique<Motor>();

// ✅ GOOD - Shared ownership (use sparingly)
std::shared_ptr<Config> config = std::make_shared<Config>();

// ✅ GOOD - Non-owning reference
std::weak_ptr<Config> weakConfig = config;

// ❌ BAD - Raw pointer with ownership
Motor* motor = new Motor();  // Who deletes this?
```

### Use Override and Final
```cpp
class BaseMotor {
public:
    virtual void initialize() = 0;
    virtual float getSpeed() const = 0;
    virtual ~BaseMotor() = default;
};

// ✅ GOOD - Explicit override
class StepperMotor : public BaseMotor {
public:
    void initialize() override {  // Compiler verifies
        // Implementation
    }
    
    float getSpeed() const override final {  // Cannot override further
        return speed_;
    }
    
private:
    float speed_;
};

// ❌ BAD - Typos undetected
class StepperMotor : public BaseMotor {
public:
    void initialise() {  // Typo! Creates new function
        // ...
    }
};
```

### Use [[nodiscard]] for Return Values
Mark functions with `[[nodiscard]]` when ignoring the return value is likely a bug.

```cpp
// ✅ GOOD - Prevents ignoring important return values
class Motor {
public:
    [[nodiscard]] bool initialize();      // Must check success
    [[nodiscard]] float getSpeed() const; // Getter should be used
    [[nodiscard]] ErrorCode setSpeed(float speed); // Error must be handled
    
    void update();  // No return - no [[nodiscard]] needed
};

// Usage
if (!motor.initialize()) {  // Compiler warns if unchecked
    handleError();
}

motor.getSpeed();  // Compiler warning: return value ignored
```

---

## Code Formatting

### Indentation and Spacing
- **4 spaces** for indentation (no tabs)
- **Single space** after keywords: `if (`, `for (`, `while (`
- **No space** for function calls: `function(arg)`
- **Space around operators**: `a + b`, `x = y`, `i < n`

```cpp
// ✅ GOOD
if (isEnabled) {
    float result = calculateSpeed(position, time);
    for (size_t i = 0; i < count; ++i) {
        process(data[i]);
    }
}

// ❌ BAD
if(isEnabled){
float result=calculateSpeed( position,time );
for(size_t i=0;i<count;++i){
process( data[ i ] );
}
}
```

### Braces
- **Opening brace on same line** for functions, classes, control structures
- Always use braces for single-line conditionals

```cpp
// ✅ GOOD
void function() {
    if (condition) {
        doSomething();
    }
}

class Motor {
    // ...
};

// ❌ BAD - No braces
if (condition)
    doSomething();  // Dangerous for maintenance

// ❌ BAD - Opening brace on new line
void function()
{
    // ...
}
```

### Line Length
- **Maximum 120 characters** per line (aligned with project-wide standard)
- Break long lines logically at operators or after commas

```cpp
// ✅ GOOD - Readable line breaks
bool result = motor.initialize() 
    && encoder.calibrate() 
    && driver.configure();

motor.setParameters(
    targetSpeed,
    accelerationLimit,
    currentLimit
);

// ❌ BAD - Too long
bool result = motor.initialize() && encoder.calibrate() && driver.configure() && system.start();
```

---

## General Guidelines

### Single Responsibility Principle
Each class/function should do one thing well.

```cpp
// ✅ GOOD - Focused classes
class EncoderReader {
    int32_t readPosition();
    float readVelocity();
};

class MotorController {
    void setSpeed(float speed);
    void update();
};

// ❌ BAD - God class
class MotorSystem {
    void readEncoder();
    void controlMotor();
    void processUSB();
    void updateDisplay();
    void saveToFlash();
    // Too many responsibilities
};
```

### Prefer Composition Over Inheritance
```cpp
// ✅ GOOD - Composition
class Motor {
    EncoderInterface encoder_;
    GateDriver driver_;
    CurrentController controller_;
};

// ⚠️ CAUTION - Deep inheritance hierarchies
class BaseMotor { };
class ACMotor : public BaseMotor { };
class BrushlessMotor : public ACMotor { };
class FOCMotor : public BrushlessMotor { };  // Getting complex
```

### Avoid Magic Numbers
```cpp
// ✅ GOOD - Named constants
constexpr float kMaxCurrent = 60.0f;  // Amperes
constexpr int kTimeout = 1000;        // Milliseconds
constexpr size_t kBufferSize = 256;   // Bytes

if (current > kMaxCurrent) {
    shutdown();
}

// ❌ BAD - Magic numbers
if (current > 60.0f) {  // What is 60?
    shutdown();
}

delay(1000);  // Milliseconds? Seconds?
```

### Keep Functions Short
- Aim for functions under 50 lines
- If longer, consider breaking into smaller functions
- Each function should do one thing

```cpp
// ✅ GOOD - Focused function
float calculateElectricalAngle(float mechanicalAngle, int polePairs) {
    return mechanicalAngle * polePairs;
}

// ✅ GOOD - Composed from smaller functions
void updateMotor() {
    readSensors();
    calculateControl();
    outputPWM();
}
```

---

## Error Handling

### Use Exceptions for Exceptional Conditions
```cpp
// ✅ GOOD - Exceptions for errors
void Motor::initialize() {
    if (!hardware.isPresent()) {
        throw std::runtime_error("Motor hardware not found");
    }
    
    if (!calibrate()) {
        throw std::runtime_error("Calibration failed");
    }
}
```

### Return Error Codes for Expected Failures
```cpp
// ✅ GOOD - Error codes for expected cases
enum class ErrorCode {
    Success,
    OutOfRange,
    NotInitialized,
    HardwareError
};

ErrorCode Motor::setSpeed(float speed) {
    if (!isInitialized_) {
        return ErrorCode::NotInitialized;
    }
    
    if (speed < kMinSpeed || speed > kMaxSpeed) {
        return ErrorCode::OutOfRange;
    }
    
    speed_ = speed;
    return ErrorCode::Success;
}
```

### Use std::optional for Optional Values
```cpp
// ✅ GOOD - Optional return
std::optional<float> Motor::getTemperature() const {
    if (!temperatureSensor_.isValid()) {
        return std::nullopt;
    }
    return temperatureSensor_.read();
}

// Usage
if (auto temp = motor.getTemperature()) {
    std::cout << "Temperature: " << *temp;
} else {
    std::cout << "Temperature sensor unavailable";
}
```

---

## Performance Considerations

### Prefer Pass-by-const-reference for Large Objects
```cpp
// ✅ GOOD - Large objects by const reference
void processConfig(const MotorConfig& config);
void updateState(const std::vector<float>& samples);

// ✅ GOOD - Small objects by value
void setSpeed(float speed);
void setMode(ControlMode mode);
```

### Reserve Capacity for Vectors
```cpp
// ✅ GOOD - Pre-allocate
std::vector<float> samples;
samples.reserve(1000);  // Avoid reallocations
for (size_t i = 0; i < 1000; ++i) {
    samples.push_back(readSample());
}
```

### Use In-Place Construction
```cpp
// ✅ GOOD - Construct in place
std::vector<Motor> motors;
motors.emplace_back(config1);  // Construct directly in vector
motors.emplace_back(config2);

// ❌ LESS EFFICIENT - Temporary object
motors.push_back(Motor(config1));  // Constructs then moves
```

### Avoid Premature Optimization
- Write clear, correct code first
- Profile before optimizing
- Optimize hot paths only

---

## Additional Style Guidelines

### Self-Contained Headers
Every header file should compile on its own without requiring specific include order.

```cpp
// ✅ GOOD - Self-contained header
#pragma once
#include <cstdint>
#include <string>

class MyClass {
    std::string name_;  // All dependencies included
};

// ❌ BAD - Requires user to include dependencies first
class MyClass {
    std::string name_;  // Compile error if <string> not included
};
```

### Include What You Use (IWYU)
If a source file uses a symbol, include the header that provides it directly.

```cpp
// ✅ GOOD - Explicit includes
#include "foo.h"
#include <vector>
std::vector<int> data;  // Always works

// ❌ BAD - Relies on transitive includes
#include "foo.h"
std::vector<int> data;  // Works only if foo.h includes <vector>
```

### Explicit Constructors
Single-argument constructors should be marked `explicit` to prevent accidental implicit conversions.

```cpp
// ✅ GOOD - Prevents accidental conversion
class Voltage {
    explicit Voltage(float v) : value_(v) {}
};

void setVoltage(Voltage v);
setVoltage(5.0f);           // Compile error - good!
setVoltage(Voltage{5.0f});  // OK - explicit and intentional

// ❌ BAD - Allows accidental conversion
class Voltage {
    Voltage(float v) : value_(v) {}  // 5.0f silently converts
};
```

### Prefer `using` over `typedef`
Modern `using` syntax is clearer and works with templates.

```cpp
// ✅ GOOD - Modern syntax
using Callback = std::function<void(ErrorCode)>;
using Buffer = std::array<uint8_t, 256>;

// Template aliases (only possible with 'using')
template<typename T>
using Vec = std::vector<T>;

// ❌ OLD STYLE
typedef std::function<void(ErrorCode)> Callback;
```

### Prefer Preincrement
Use `++i` instead of `i++` when the result isn't used. Preincrement is never slower and often faster for iterators.

```cpp
// ✅ GOOD - Preincrement
for (auto it = vec.begin(); it != vec.end(); ++it) {
    // No unnecessary copy
}

for (int i = 0; i < 10; ++i) {
    // Consistent style
}

// ❌ AVOID - Postincrement creates temporary
for (auto it = vec.begin(); it != vec.end(); it++) {
    // it++ may copy for complex iterators
}
```

### Explicit Copy/Move Semantics
Every class should explicitly declare what copy/move operations it supports.

```cpp
// ✅ Copyable class
class Copyable {
public:
    Copyable(const Copyable&) = default;
    Copyable& operator=(const Copyable&) = default;
};

// ✅ Move-only class (like std::unique_ptr)
class MoveOnly {
public:
    MoveOnly(MoveOnly&&) = default;
    MoveOnly& operator=(MoveOnly&&) = default;
    MoveOnly(const MoveOnly&) = delete;
    MoveOnly& operator=(const MoveOnly&) = delete;
};

// ✅ Non-copyable, non-movable (like mutex)
class NoCopyOrMove {
public:
    NoCopyOrMove(const NoCopyOrMove&) = delete;
    NoCopyOrMove& operator=(const NoCopyOrMove&) = delete;
};
```

---

## Summary Checklist

### Every Code Change Should:
- [ ] Follow naming conventions consistently
- [ ] Include appropriate documentation
- [ ] Use modern C++ features (C++17 minimum)
- [ ] Handle errors appropriately
- [ ] Avoid raw pointers for ownership
- [ ] Use const correctness
- [ ] Initialize all variables
- [ ] Keep functions focused and short
- [ ] Avoid magic numbers
- [ ] Be formatted consistently

---

*This guide should be followed for all C++ code in the project. Consistency is key to maintainability.*

---

## Header File Standards

The following rules apply specifically to header files (`.h`, `.hpp`).

### Include Guards

Use `#pragma once` at the top of every header file. For compatibility, you may add traditional guards as a fallback:

```cpp
#pragma once
#ifndef ODRIVE_MOTORCONTROL_ENCODER_HPP_
#define ODRIVE_MOTORCONTROL_ENCODER_HPP_
// ...
#endif // ODRIVE_MOTORCONTROL_ENCODER_HPP_
```

Guard naming: `PROJECTNAME_PATH_FILENAME_HPP_` — all uppercase with underscores.

### Header File Structure

Follow this organization order:
1. `#pragma once`
2. File header comment (`@file`, `@brief`)
3. System includes (alphabetical)
4. Third-party includes (alphabetical)
5. Project includes (alphabetical)
6. Forward declarations
7. Namespace
8. Constants and type aliases
9. Enumerations
10. Class declarations

### Include What You Use (IWYU)

Only include headers necessary for declarations in the file. Use forward declarations where possible:

| Use Case | Forward Declare? |
|----------|------------------|
| Pointer member (`Motor*`) | Yes |
| Reference member (`Motor&`) | Yes |
| Function parameter (`void foo(Motor*)`) | Yes |
| Value member (`Motor motor_`) | No — need full include |
| Inheritance (`class Foo : Motor`) | No — need full include |
| Calling methods (`motor.update()`) | No — need full include |

### Include Order

1. Related header (for `.cpp` files — first include)
2. C system headers (`<cstdint>`, `<cmath>`)
3. C++ standard library (`<vector>`, `<memory>`)
4. Third-party libraries
5. Project headers

Separate each group with a blank line. Alphabetize within groups.

### Namespace Pollution

**NEVER** use `using namespace` at global scope in a header file — it pollutes every includer. Acceptable: `using` declarations inside function bodies or class scope.

### Inline Implementation

Keep implementation **out of headers** unless:
- It is a **template** (must be in header)
- It is a **constexpr** function
- It is a **trivial getter/setter** (1-2 lines)

### Self-Contained Headers

Every header must compile on its own. Include all dependencies. Test by making the header the first include in its `.cpp` file.

### `[[nodiscard]]` for Return Values

Use `[[nodiscard]]` on getters and functions where ignoring the return value is likely a bug.

### Header Checklist

- [ ] Uses `#pragma once`
- [ ] Follows standard structure order
- [ ] Includes only what is needed (IWYU)
- [ ] Uses forward declarations where possible
- [ ] No `using namespace` at global scope
- [ ] Implementation in .cpp unless template/constexpr/trivial
- [ ] Self-contained (compiles on its own)
- [ ] Uses `[[nodiscard]]` for value-returning getters