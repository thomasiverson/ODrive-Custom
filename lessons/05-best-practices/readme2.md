# Lesson 5: C++ Best Practices with GitHub Copilot

**Session Duration:** 50 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Overview

This lesson teaches you how to leverage GitHub Copilot for modern C++ development in embedded systems. You'll learn to apply RAII patterns, enforce embedded constraints (no heap, no exceptions), implement RTOS patterns, and generate production-quality code using specialized prompts.

**What You'll Learn:**
- Modern C++ patterns: RAII, templates, const correctness, move semantics
- Embedded constraints: static allocation, error codes, volatile, ISR safety
- RTOS patterns: state machines, HAL abstractions, task synchronization
- Generating embedded-safe code with Copilot using specialized prompts

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **RAII** | Resource Acquisition Is Initialization - automatic cleanup |
| **Static Allocation** | No heap (malloc/new) - fixed memory footprint |
| **Error Codes** | No exceptions - return enum class error codes |
| **Volatile** | Required for hardware registers and ISR-shared variables |
| **State Machines** | Task chain pattern for complex control flow |
| **HAL Abstractions** | Hide vendor HAL details behind clean interfaces |

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Why C++ Best Practices Matter](#why-c-best-practices-matter)
- [Learning Path](#learning-path)
- [Modern C++ Patterns](#1-modern-c-patterns-12-min)
- [Embedded C++ Specifics](#2-embedded-c-specifics-12-min)
- [RTOS & Hardware Patterns](#3-rtos--hardware-patterns-10-min)
- [Hands-On: Generate Components](#4-hands-on-generate-components-16-min)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference-mode-selection-guide)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **Completed Planning & Steering Documents** - Understanding of custom instructions and agents
- ✅ **Completed Agentic Development** - Understanding of context engineering
- ✅ **Visual Studio Code** with GitHub Copilot extensions installed and enabled
- ✅ **C++ development experience** - Familiar with classes, templates, STL
- ✅ **ODrive workspace** - Access to the ODrive firmware codebase

### Verify Your Setup

1. **Check ODrive Firmware access:**
   - Ensure `src-ODrive/Firmware/` folder is accessible
   - Verify `MotorControl/`, `Drivers/`, and `fibre-cpp/` subdirectories exist

2. **Verify custom agents are available:**
   - Open Chat view (Ctrl+Alt+I)
   - Check agents dropdown for `@ODrive-Engineer`, `@ODrive-QA`

3. **Test code navigation:**
   - Open `src-ODrive/Firmware/MotorControl/axis.cpp`
   - Verify Go to Definition (F12) works

---

## Why C++ Best Practices Matter

Embedded C++ has unique constraints that distinguish it from desktop/server development. Copilot can help enforce these constraints when given proper context.

### Embedded vs Desktop C++

| Aspect | Desktop C++ | Embedded C++ |
|--------|-------------|--------------|
| Memory | Dynamic allocation OK | Static allocation only |
| Exceptions | Standard practice | Forbidden (code size, determinism) |
| RTTI | Available | Usually disabled |
| Stack | Generous | Very limited (KB) |
| Timing | Best effort | Hard real-time deadlines |

### Benefits of Copilot for Embedded C++

1. **Consistent Patterns**
   - Generates RAII wrappers automatically
   - Follows project coding standards
   - Applies embedded constraints consistently

2. **Reduced Boilerplate**
   - HAL abstractions from templates
   - State machine scaffolding
   - Error handling patterns

3. **Learning Accelerator**
   - Explains unfamiliar patterns in codebase
   - Suggests best practices for new features
   - Validates designs against constraints

---

## Learning Path

This lesson covers four key areas. Work through them sequentially for the best learning experience.

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Modern C++ Patterns | RAII, templates, const correctness | 12 min |
| Embedded C++ Specifics | Static allocation, error codes, volatile | 12 min |
| RTOS & Hardware Patterns | State machines, HAL, task sync | 10 min |
| Hands-On: Generate Components | LED driver, SPI sensor, ring buffer | 16 min |

---

## 1. Modern C++ Patterns (12 min)

### RAII & Resource Management
**🎯 Copilot Modes: Agent + Chat**

**Key Files:**
- [src-ODrive/Firmware/fibre-cpp/include/fibre/cpp_utils.hpp](../../src-ODrive/Firmware/fibre-cpp/include/fibre/cpp_utils.hpp) - Custom `variant` with destructor
- [src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp](../../src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp) - GPIO class example

**💬 Chat Mode Prompt (Analysis):**
```
Review this GPIO class and suggest RAII improvements:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp

Analyze:
- Current resource lifecycle management
- Missing RAII patterns
- Copy/move semantics issues
- Potential double-free or leak scenarios
```

**🤖 Agent Mode Prompt (Implementation):**
```
@ODrive-Engineer Implement RAII improvements for GPIO class

Context: #file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp
         #file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.cpp

Requirements:
- Add destructor that calls unsubscribe() if owns_subscription_
- Delete copy constructor and copy assignment
- Implement move constructor and move assignment
- Add owns_subscription_ member to track cleanup responsibility

Acceptance Criteria:
- No manual unsubscribe() needed in typical usage
- Safe to store in containers with move semantics
- Thread-safe as documented
```

### Templates & Type Traits
**🎯 Copilot Modes: Chat + Agent**

**💬 Chat Mode Prompt (Explain Pattern):**
```
Explain the template metaprogramming patterns in:
#file:src-ODrive/Firmware/fibre-cpp/include/fibre/cpp_utils.hpp

Focus on:
- integer_sequence implementation and use cases
- Type trait techniques for compile-time checks
- SFINAE patterns used
- Benefits for embedded systems (zero runtime cost)
```

**🤖 Agent Mode Prompt (Convert to Generic):**
```
@ODrive-Engineer Make buffer class generic using templates

Context: #file:src-ODrive/Firmware/fibre-cpp/include/fibre/bufptr.hpp

Task:
- Convert to template class with type parameter T
- Add static_assert to ensure T is POD (std::is_trivial)
- Preserve const correctness
- Maintain zero-overhead abstraction

Acceptance Criteria:
- Works with uint8_t, uint16_t, uint32_t, custom POD structs
- Compile error for non-POD types with clear message
- No runtime overhead vs original
```

### Const Correctness
**🎯 Copilot Modes: Chat + Agent**

**💬 Chat Mode Prompt (Audit):**
```
Audit const correctness in this class:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp

Check:
1. Which methods should be marked const but aren't?
2. Which parameters should be const references?
3. Are there any const methods that modify mutable state?
4. Suggest const overloads where appropriate
```

---

## 2. Embedded C++ Specifics (12 min)

### Static Allocation (No Heap)
**🎯 Copilot Modes: Agent + Chat**

**Pattern: TheInstance<T> Singleton**
```cpp
template<typename T>
struct TheInstance {
    static T instance;
    static bool in_use;
};
```

**💬 Chat Mode Prompt (Identify Issues):**
```
Analyze dynamic memory usage in this driver:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.cpp

Identify:
1. All uses of new, delete, malloc, free
2. std::vector or other heap-based containers
3. Unbounded queues or buffers
4. Memory allocation in hot paths

For each issue, suggest static allocation alternatives.
```

**🤖 Agent Mode Prompt (Refactor to Static):**
```
@ODrive-Engineer Refactor SPI arbiter to use static allocation only

Context: #file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.cpp

Refactoring steps:
1. Replace std::vector with std::array<SpiTask, 8>
2. Use TheInstance<> pattern for singleton
3. Convert dynamic queue to fixed-size circular buffer
4. Add overflow handling (return error, not crash)
5. Remove all new/delete/malloc/free

Acceptance Criteria:
- Zero calls to heap allocator
- Fixed RAM footprint (no growth at runtime)
- Performance equal or better than original
```

### No Exceptions - Error Code Pattern
**🎯 Copilot Modes: Chat + Agent**

**Key Files:**
- [src-ODrive/Firmware/MotorControl/encoder.cpp](../../src-ODrive/Firmware/MotorControl/encoder.cpp) - `set_error()` pattern
- [src-ODrive/Firmware/MotorControl/axis.cpp](../../src-ODrive/Firmware/MotorControl/axis.cpp) - State machine error handling

**💬 Chat Mode Prompt (Design Error System):**
```
Analyze error handling patterns across ODrive firmware:
#file:src-ODrive/Firmware/MotorControl/encoder.cpp
#file:src-ODrive/Firmware/MotorControl/axis.cpp

Design unified error handling system:
1. Catalog all current error conditions by category
2. Propose enum class ErrorCode with severity levels:
   - Info (0x0000-0x0FFF)
   - Warning (0x1000-0x1FFF)
   - Error (0x2000-0x2FFF)
   - Critical (0x3000-0x3FFF)
3. Define error propagation strategy
4. Suggest error recovery patterns per category
```

**🤖 Agent Mode Prompt (Convert Function):**
```
@ODrive-Engineer Convert calibration function to use error codes

Context: #file:src-ODrive/Firmware/MotorControl/encoder.cpp:run_offset_calibration

Conversion steps:
1. Change return type from void to enum class ErrorCode
2. Replace set_error() calls with error code returns
3. Add error checking after each operation
4. Update all callers to check return value
5. Add Doxygen @return documentation for each error

Acceptance Criteria:
- No exceptions or throw statements
- Every error path returns specific error code
- Errors are actionable (clear what went wrong)
```

### Volatile for Hardware Registers
**🎯 Copilot Mode: Inline + Chat**

**Inline Completion Example:**
```cpp
// Define ADC register structure
struct ADC_Regs {
    volatile uint32_t CR1;    // Copilot completes register map
```

**Chat Validation:**
```
Review volatile keyword usage in:
#file:src-ODrive/Firmware/Board/v3/board.cpp

Check:
- All shared ISR variables are volatile
- Hardware register pointers use volatile
- No missing volatile qualifiers
```

### ISR Handlers
**🎯 Copilot Mode: Inline + Edit**

**Inline Prompt:**
```cpp
// Generate TIM13 overflow ISR with critical section
extern "C" void TIM13_IRQHandler(void) {
    // Copilot completes handler with proper pattern
```

**Edit Mode Example:**
```
Add critical section protection to this ISR:
#file:src-ODrive/Firmware/Board/v3/board.cpp:TIM8_UP_TIM13_IRQHandler

Requirements:
- Use cpu_enter_critical/cpu_exit_critical
- Minimize critical section duration
- Clear interrupt flags correctly
- No blocking calls (osDelay, malloc)
```

---

## 3. RTOS & Hardware Patterns (10 min)

### State Machines
**🎯 Copilot Modes: Chat + Agent**

**The Crown Jewel:** [src-ODrive/Firmware/MotorControl/axis.cpp](../../src-ODrive/Firmware/MotorControl/axis.cpp)

**Key Pattern (Task Chain):**
```cpp
void Axis::run_state_machine_loop() {
    for (;;) {
        switch (current_state_) {
            case AXIS_STATE_MOTOR_CALIBRATION:
                status = motor_.run_calibration();
                break;
            // ... more states
        }
    }
}
```

**💬 Chat Mode Prompt (Understand Pattern):**
```
Explain the state machine architecture in Axis class:
#file:src-ODrive/Firmware/MotorControl/axis.cpp:run_state_machine_loop

Analyze:
1. How does the task chain pattern work?
2. How are states sequenced automatically?
3. How does error handling interrupt state flow?
4. How are resources acquired/released per state?

Create a state transition diagram in Mermaid format.
```

**🤖 Agent Mode Prompt (Generate State Machine):**
```
@ODrive-Engineer Create LED controller with state machine pattern

Reference: #file:src-ODrive/Firmware/MotorControl/axis.cpp

States:
- LED_STATE_OFF: GPIO low, no power
- LED_STATE_ON: GPIO high, steady
- LED_STATE_BLINKING: Toggle at configured rate
- LED_STATE_FADING: PWM fade in/out
- LED_STATE_ERROR: Fast blink pattern

Features:
1. Task chain for automatic sequences
2. State entry/exit actions
3. Timeout handling
4. Error recovery
5. RAII guard for GPIO lifecycle

Acceptance Criteria:
- Follows Axis pattern (switch/case with task chain)
- FreeRTOS task with osDelay timing
- Static allocation only
- Error codes, no exceptions
```

### HAL Abstractions
**🎯 Copilot Modes: Chat + Agent**

**Key Files:**
- [src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp](../../src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp) - GPIO HAL
- [src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp](../../src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp) - SPI HAL

**💬 Chat Mode Prompt (Learn Pattern):**
```
Analyze HAL abstraction patterns in ODrive:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp
#file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp

Extract common design principles:
1. How do they hide STM32 HAL implementation details?
2. How is resource ownership managed (RAII)?
3. How are async operations handled?
4. How is thread-safety achieved?
5. How are errors propagated?

Create a HAL Design Checklist for new abstractions.
```

**🤖 Agent Mode Prompt (Create New HAL):**
```
@ODrive-Engineer Create UART HAL abstraction following ODrive patterns

References: #file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp

UART HAL Requirements:
- Stm32UartHal class wrapping UART_HandleTypeDef
- RAII: constructor acquires, destructor releases
- Delete copy, implement move semantics
- Hide UART_HandleTypeDef* as private member

Public API:
- ErrorCode init(uint32_t baudrate)
- ErrorCode write(const uint8_t* data, size_t len, uint32_t timeout_ms)
- ErrorCode write_dma(const uint8_t* data, size_t len, Callback cb)
- std::pair<size_t, ErrorCode> read(uint8_t* buf, size_t max_len)

Internal Features:
- Static RX/TX ring buffers (std::array<uint8_t, 256>)
- DMA completion callbacks
- Critical sections for buffer access

Acceptance Criteria:
- No direct access to UART_HandleTypeDef by users
- Thread-safe buffer operations
- Zero dynamic allocation
```

### Task Synchronization (FreeRTOS)
**🎯 Copilot Mode: Inline + Chat**

**Inline Example:**
```cpp
// Create producer-consumer with semaphore
osSemaphoreDef(adc_ready);
// Copilot completes initialization and usage
```

**Chat Mode Pattern:**
```
Generate ADC sampling architecture using FreeRTOS:
#file:src-ODrive/Firmware/MotorControl/low_level.cpp

Design:
- ADC ISR writes to ring buffer (producer)
- Processing task reads from buffer (consumer)
- Binary semaphore for synchronization
- Queue for timestamped samples
- Proper stack size calculation
- Priority assignment rationale

Include full implementation with osThreadCreate, osSemaphoreCreate.
```

---

## 4. Hands-On: Generate Components (16 min)

### Exercise 1: LED Driver with State Machine
**🎯 Copilot Modes: Chat → Agent**

**Step 1 - Chat Mode (Design Review):**
```
Before implementing, review the design for LED state machine:

States: OFF, ON, BLINKING, FADING, ERROR

Questions:
1. Should we use GPIO toggle or PWM for blinking?
2. How to handle state transitions during animations?
3. What's the best FreeRTOS synchronization primitive?
4. Should fade use TIM PWM or bit-bang?

Provide recommendations based on ODrive patterns.
```

**Step 2 - Agent Mode (Implementation):**
```
@ODrive-Engineer Create LED driver with state machine

Context: #file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp
         #file:src-ODrive/Firmware/MotorControl/axis.cpp

States (enum class LedState): OFF, ON, BLINKING, FADING, ERROR

Public API:
- LedController(Stm32Gpio&& pin, osPriority priority)
- ErrorCode set_state(LedState state)
- ErrorCode configure_blink(uint32_t rate_hz)
- LedState get_state() const

Create files:
- Firmware/Drivers/led_controller.hpp
- Firmware/Drivers/led_controller.cpp

Acceptance Criteria:
- Compiles with -Wall -Werror
- No new/delete/malloc
- State machine follows Axis pattern
- Full Doxygen documentation
```

### Exercise 2: SPI Sensor Driver
**🎯 Copilot Modes: Chat → Agent**

**Step 1 - Chat Mode (Understand SPI Arbiter):**
```
Explain the SPI arbiter pattern and how to use it:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp

Questions:
1. How does the task queue prevent bus conflicts?
2. How are async callbacks invoked?
3. How to handle errors in SPI transactions?
4. How to ensure CS (chip select) timing?
```

**Step 2 - Agent Mode (Implement Driver):**
```
@ODrive-Engineer Create ADXL345 accelerometer driver using SPI arbiter

Context: #file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp

Public API:
- ErrorCode init(Stm32SpiArbiter& spi, Stm32Gpio&& cs_pin)
- ErrorCode self_test()
- ErrorCode read_acceleration(float& x, float& y, float& z)
- ErrorCode configure_range(uint8_t g_range)

Features:
- Async SPI transactions (non-blocking)
- Bounds checking on buffer access
- Error recovery (retry on CRC/timeout)
- Volatile for register bitfields
- Static allocation only

Create files:
- Firmware/Drivers/Sensors/adxl345.hpp
- Firmware/Drivers/Sensors/adxl345.cpp

Acceptance Criteria:
- Successfully reads device ID 0xE5
- SPI errors return ErrorCode, not assert
- Thread-safe (can call from multiple tasks)
```

### Exercise 3: Lock-Free Ring Buffer for ISR
**🎯 Copilot Modes: Chat → Agent**

**Step 1 - Chat Mode (Design Validation):**
```
Review lock-free ring buffer design for ISR safety:

Requirement: UART RX ISR writes samples, task reads them

Design questions:
1. Should we use atomic<size_t> or volatile size_t for indices?
2. How to detect full vs empty (head == tail ambiguity)?
3. Does read() need to be ISR-safe?
4. Should overflow drop oldest or newest?
5. Do we need memory barriers for ARM Cortex-M?

Provide recommendations based on FreeRTOS ISR safety.
```

**Step 2 - Agent Mode (Implementation):**
```
@ODrive-Engineer Create lock-free ring buffer for ISR-to-task communication

Template Class: RingBuffer<T, N>

Public API:
- bool write(const T& item)  // ISR-safe (producer)
- bool read(T& item)         // Task-safe (consumer)
- size_t available() const   // Items ready to read
- size_t free_space() const  // Space for writing
- void clear()               // Reset (not ISR-safe)

Requirements:
- Use volatile for head/tail
- Waste one slot to detect full
- write() from ISR context (single producer)
- read() from task context (single consumer)
- Overflow: drop newest (return false)

Create files:
- Firmware/Utils/ring_buffer.hpp
- Tests/ring_buffer_test.cpp (doctest)

Acceptance Criteria:
- No data races
- Survives rapid ISR writes
- Correct full/empty detection
- Unit tests pass
```

---

## Practice Exercises

### Exercise 1: RAII Wrapper
**Goal:** Create a RAII wrapper for a hardware resource

<details>
<summary>📋 Instructions</summary>

1. Choose a resource: timer, DMA channel, or peripheral clock
2. Ask Copilot to analyze existing HAL patterns
3. Generate a RAII wrapper with:
   - Constructor acquires resource
   - Destructor releases resource
   - Deleted copy, implemented move
   - Static allocation

**Prompt to use:**
```
@ODrive-Engineer Create RAII wrapper for TIM peripheral

Reference patterns: #file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp

Requirements:
- Constructor enables clock, configures timer
- Destructor disables timer, releases clock
- Delete copy semantics
- Implement move semantics
- No dynamic allocation
```

**Success Criteria:**
- ✅ No manual cleanup needed
- ✅ Safe in exception-free code
- ✅ Moveable between containers
</details>

<details>
<summary>💡 Solution Pattern</summary>

```cpp
class TimerGuard {
public:
    explicit TimerGuard(TIM_TypeDef* timer, const Config& cfg)
        : timer_(timer), owns_(true) {
        enable_clock(timer_);
        configure(cfg);
    }
    
    ~TimerGuard() {
        if (owns_) {
            disable_timer();
            disable_clock();
        }
    }
    
    // No copy
    TimerGuard(const TimerGuard&) = delete;
    TimerGuard& operator=(const TimerGuard&) = delete;
    
    // Move OK
    TimerGuard(TimerGuard&& other) noexcept
        : timer_(other.timer_), owns_(other.owns_) {
        other.owns_ = false;
    }
    
private:
    TIM_TypeDef* timer_;
    bool owns_;
};
```
</details>

---

### Exercise 2: Convert Exception to Error Code
**Goal:** Refactor code that uses exceptions to use error codes

<details>
<summary>📋 Instructions</summary>

1. Find or create code that might throw (or uses try/catch)
2. Design an ErrorCode enum
3. Ask Copilot to convert:

**Prompt to use:**
```
Convert this function to use error codes instead of exceptions:

```cpp
void calibrate_sensor() {
    auto reading = read_sensor();
    if (reading < 0) throw std::runtime_error("Sensor error");
    if (reading > MAX_VALUE) throw std::out_of_range("Value overflow");
    store_calibration(reading);
}
```

Requirements:
- Define enum class ErrorCode
- Return ErrorCode instead of void
- Document all possible errors
- Show caller example with error checking
```

**Success Criteria:**
- ✅ No throw statements
- ✅ All error paths covered
- ✅ Caller example included
</details>

<details>
<summary>💡 Solution Pattern</summary>

```cpp
enum class ErrorCode {
    OK = 0,
    SENSOR_ERROR,
    VALUE_OVERFLOW,
    STORAGE_FAILURE
};

/**
 * @brief Calibrate sensor and store result
 * @return ErrorCode::OK on success
 * @retval SENSOR_ERROR if sensor read fails
 * @retval VALUE_OVERFLOW if reading exceeds MAX_VALUE
 * @retval STORAGE_FAILURE if storage write fails
 */
[[nodiscard]] ErrorCode calibrate_sensor() {
    auto reading = read_sensor();
    if (reading < 0) {
        return ErrorCode::SENSOR_ERROR;
    }
    if (reading > MAX_VALUE) {
        return ErrorCode::VALUE_OVERFLOW;
    }
    if (!store_calibration(reading)) {
        return ErrorCode::STORAGE_FAILURE;
    }
    return ErrorCode::OK;
}

// Caller example:
if (auto err = calibrate_sensor(); err != ErrorCode::OK) {
    handle_error(err);
    return;
}
```
</details>

---

### Exercise 3: Ring Buffer Implementation
**Goal:** Implement an ISR-safe ring buffer

<details>
<summary>📋 Instructions</summary>

1. Use the prompt from Exercise 3 in Section 4
2. Verify Copilot's implementation against requirements
3. Write additional tests for edge cases

**Additional tests to request:**
```
Add tests for:
1. Write when full (should return false)
2. Read when empty (should return false)
3. Wrap-around at buffer boundary
4. Rapid alternating write/read
5. Stress test: 1000 writes, 1000 reads
```

**Success Criteria:**
- ✅ ISR-safe write
- ✅ Task-safe read
- ✅ Correct full/empty detection
- ✅ All tests pass
</details>

---

### Exercise 4: Embedded C++ Persona
**Goal:** Create a custom persona for embedded validation

<details>
<summary>📋 Instructions</summary>

1. Create `.github/agents/Embedded-Validator.agent.md`
2. Define validation checklist:
   - No dynamic allocation
   - No exceptions
   - Volatile correctness
   - Const correctness
   - RAII compliance

3. Test by asking it to review code

**Agent template:**
```markdown
---
description: Validate code for embedded C++ best practices
name: Embedded-Validator
tools: ['search', 'codebase']
---

# Embedded Code Validator

Validate embedded C++ code against these rules:

## Memory
- [ ] No new/delete/malloc/free
- [ ] No std::vector without custom allocator
- [ ] Fixed-size buffers with bounds checking

## Error Handling
- [ ] No throw/try/catch
- [ ] Error codes returned
- [ ] All errors documented

## Hardware
- [ ] Volatile for ISR-shared variables
- [ ] Volatile for hardware registers
- [ ] Critical sections around shared data

## Quality
- [ ] Const correctness
- [ ] RAII for resources
- [ ] Move semantics for non-copyable

For each violation, provide location and fix.
```

**Success Criteria:**
- ✅ Agent validates code accurately
- ✅ Catches common embedded violations
- ✅ Provides actionable fixes
</details>

---

## Quick Reference: Mode Selection Guide

### When to Use Each Mode

| Task | Mode | Why |
|------|------|-----|
| Explain existing code | Chat (Ask) | Read-only, exploratory |
| Add documentation | Inline (Ctrl+I) | Targeted, in-place |
| Refactor single function | Edit | Focused change |
| Implement new feature | Agent | Multi-file, planning |
| Review for best practices | Agent with custom agent | Specialized validation |
| Generate tests | Chat with `/tests` | Uses test framework |

### Embedded-Specific Prompts

**Static Allocation Check:**
```
Audit this file for dynamic allocation and suggest static alternatives:
#file:path/to/file.cpp
```

**Error Code Conversion:**
```
Convert this function to return ErrorCode instead of throwing:
[select function]
```

**Volatile Audit:**
```
Check volatile usage in this ISR and shared variable access:
#file:path/to/interrupts.cpp
```

**RAII Improvement:**
```
Add RAII wrapper for this resource to prevent leaks:
[select class]
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Generated code uses `new` | Add "static allocation only, no heap" to prompt |
| Generated code throws exceptions | Add "no exceptions, use error codes" to prompt |
| Missing volatile on ISR variables | Explicitly mention "ISR-shared" in prompt |
| Generic C++ patterns used | Reference specific ODrive files in prompt |
| Missing const correctness | Ask "audit const correctness" separately |
| Wrong HAL pattern | Include `#file:` reference to existing HAL |

### Common Prompt Improvements

**Too generic:**
```
Generate SPI driver
```

**Better (embedded-specific):**
```
Generate SPI driver following ODrive HAL patterns:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp

Requirements:
- Static allocation only
- Error codes, no exceptions
- Async completion callbacks
- Thread-safe arbitration
```

---

## Additional Resources

### Microsoft Learn
- [GitHub Copilot for Embedded Development](https://learn.microsoft.com/shows/learn-live/github-copilot-for-embedded-development)
- [Write Better C++ with GitHub Copilot](https://learn.microsoft.com/training/modules/write-better-code-github-copilot/)

### C++ References
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [MISRA C++ Guidelines](https://www.misra.org.uk/)
- [Embedded Artistry](https://embeddedartistry.com/)

### ODrive Patterns
- State Machines: `src-ODrive/Firmware/MotorControl/axis.cpp`
- HAL Abstraction: `src-ODrive/Firmware/Drivers/STM32/`
- Error Handling: `src-ODrive/Firmware/MotorControl/encoder.cpp`

---

## Frequently Asked Questions

### Q: How do I ensure Copilot generates embedded-safe code?

**Short Answer:** Use custom instructions and explicit constraints in prompts.

**Detailed Explanation:**
1. Create `.github/copilot-instructions.md` with embedded constraints
2. Include "no heap, no exceptions, static allocation" in every prompt
3. Reference existing ODrive patterns with `#file:`
4. Use the `@ODrive-Engineer` agent which has embedded context

---

### Q: How do I validate Copilot's code against embedded constraints?

**Short Answer:** Use the Embedded-Validator agent or explicit audit prompts.

**Detailed Explanation:**
1. Create a custom validation agent (see Exercise 4)
2. After generating code, ask: "Audit this for embedded constraints"
3. Check: dynamic allocation, exceptions, volatile, const correctness
4. Request fixes for any violations found

---

### Q: How do I get Copilot to use my project's HAL patterns?

**Short Answer:** Reference existing HAL files in your prompts.

**Detailed Explanation:**
```
Create UART driver following this project's HAL pattern:
#file:src-ODrive/Firmware/Drivers/STM32/stm32_gpio.hpp
#file:src-ODrive/Firmware/Drivers/STM32/stm32_spi_arbiter.hpp

Match the style for:
- RAII resource management
- Error code returns
- Callback mechanisms
- Thread-safety approach
```

---

### Q: How do I handle complex state machines?

**Short Answer:** Use the task chain pattern from ODrive's Axis class.

**Detailed Explanation:**
1. Reference `axis.cpp` in your prompt
2. Define states as enum class
3. Use switch/case in a FreeRTOS task loop
4. Add task chain array for automatic sequences
5. Implement entry/exit actions per state

---

### Q: Should I use std::atomic or volatile for ISR-shared variables?

**Short Answer:** For Cortex-M, volatile is usually sufficient; atomic adds overhead.

**Detailed Explanation:**
- **volatile:** Prevents compiler optimization, ensures memory reads
- **std::atomic:** Adds memory barriers, ensures visibility across cores
- **Cortex-M (single core):** volatile is typically sufficient
- **Multi-core or complex ordering:** Use std::atomic
- **ISR to task:** volatile + critical sections for non-atomic operations

---

## Summary: Key Takeaways

### 1. Modern C++ Patterns
- **RAII:** Acquire in constructor, release in destructor
- **Templates:** Zero-cost abstractions for type safety
- **Const correctness:** Mark everything const that should be

### 2. Embedded Constraints
- **No heap:** Use static allocation, std::array, fixed buffers
- **No exceptions:** Return error codes, use [[nodiscard]]
- **Volatile:** Required for hardware registers and ISR-shared data

### 3. RTOS Patterns
- **State machines:** Task chain pattern from ODrive Axis
- **HAL abstractions:** Hide vendor details, RAII ownership
- **Task sync:** Semaphores, queues, critical sections

### 4. Effective Prompts
- Reference existing code with `#file:`
- State constraints explicitly (no heap, no exceptions)
- Include acceptance criteria
- Use specialized agents for embedded work

### 5. Validation
- Audit generated code for constraint violations
- Create validation personas for consistent checking
- Test edge cases: ISR safety, error handling, resource cleanup

---

*Lesson 5: C++ Best Practices with GitHub Copilot*  
*Last Updated: January 2026*
