# Lesson 6: Debugging with GitHub Copilot

**Session Duration:** 45 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Why Debugging with Copilot Matters](#why-debugging-with-copilot-matters)
- [Agenda](#agenda-debugging-with-copilot-45-min)
- [@terminal for Build Errors](#1-terminal-for-build-errors-10-min)
- [/fix for Bug Resolution](#2-fix-for-bug-resolution-10-min)
- [Common C++ Debugging](#3-common-c-debugging-10-min)
- [Hands-On: Debug Session](#4-hands-on-debug-session-15-min)
- [Speaker Instructions](#speaker-instructions)
- [Participant Instructions](#participant-instructions)
- [Quick Reference](#quick-reference-debugging-tools)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Prerequisites

Before starting this session, ensure you have:

- **Completed C++ Best Practices** - Understanding of modern C++ patterns and embedded constraints
- **Visual Studio Code** with GitHub Copilot extensions installed and enabled
- **Active Copilot subscription** with access to all features
- **ODrive workspace** - Access to the ODrive firmware codebase for debugging exercises
- **Build environment** - Ability to compile firmware (tup/make configured)

### Verify Your Setup

1. **Test terminal access:**
   - Open integrated terminal (Ctrl+`)
   - Run a build command: `tup` or `make`
   - Verify you can see compiler output

2. **Test @terminal in chat:**
   - Open Chat view (Ctrl+Alt+I)
   - Type `@terminal` and verify it's recognized
   - Confirm terminal output is accessible to Copilot

3. **Test /fix command:**
   - Select any code snippet
   - Type `/fix` in chat
   - Verify command is recognized

---

## Why Debugging with Copilot Matters

Debugging is where developers spend 30-50% of their time. AI-assisted debugging can dramatically reduce this overhead.

### Benefits of Copilot-Assisted Debugging

1. **Faster Error Resolution**
   - AI interprets cryptic compiler errors instantly
   - Context-aware suggestions based on your codebase
   - Fix it right the first time, not after multiple Google searches

2. **Domain-Specific Insights**
   - Understands embedded constraints (no heap, ISR safety)
   - Recognizes common patterns in motor control code
   - Suggests fixes appropriate for real-time systems

3. **Learning Accelerator**
   - Explains WHY bugs occur, not just how to fix them
   - Teaches you to recognize patterns for next time
   - Builds debugging intuition faster

4. **Systematic Approach**
   - Guides you through debugging workflows
   - Suggests related areas to check
   - Helps verify fixes are complete

---

## Agenda: Debugging with Copilot (45 min)

| Sub-Topic | Focus | Time |
|-----------|-------|------|
| @terminal for Build Errors | Compiler/linker error interpretation | 10 min |
| /fix for Bug Resolution | Logic bugs, race conditions, memory issues | 10 min |
| Common C++ Debugging | 5 most common embedded C++ bugs | 10 min |
| **Hands-On:** Debug Session | Fix 3 bugs in motor control code | 15 min |

---

## 1. @terminal for Build Errors (10 min)

### Why @terminal is Powerful
**🎯 Copilot Modes: Chat**

**Files to demonstrate:**
- [src-ODrive/Firmware/MotorControl/motor.cpp](../../src-ODrive/Firmware/MotorControl/motor.cpp) - Common error source
- [src-ODrive/Firmware/MotorControl/encoder.cpp](../../src-ODrive/Firmware/MotorControl/encoder.cpp) - Linker error examples

**Traditional Debugging:**
- Read cryptic compiler errors
- Google the error message
- Try to understand the root cause
- Make a guess at the fix
- Compile again... repeat

**With @terminal:**
- AI reads the error in context
- AI understands your codebase
- AI suggests specific fixes
- AI explains WHY the error occurred
- Fix it right the first time

### When to Use @terminal

✅ **Excellent for:**
- Compiler errors (syntax, type mismatches)
- Linker errors (undefined references, duplicate symbols)
- Build system issues (Make, CMake, Tup)
- Tool chain problems (missing dependencies)
- Warning messages you don't understand

❌ **Not ideal for:**
- Runtime logic errors (use /fix on the code instead)
- Performance profiling (need specialized tools)
- Memory leaks (use valgrind, then ask AI to interpret)

### @terminal Workflow
**🎯 Copilot Mode: Chat**

**Step 1: Trigger the error**
```powershell
# Run your build command
make -j4
# Or for ODrive:
tup
```

**Step 2: Copy error to Copilot Chat**

**💬 Chat Mode Prompt:**
```
@terminal shows this error: [paste error]

Can you explain what's wrong and suggest a fix?
```

**Step 3: Get context-aware explanation**
AI analyzes:
- The error message
- Your workspace files
- Recent changes
- Common patterns

**Step 4: Apply the fix**
AI suggests specific file changes with line numbers

### Common Compiler Error Types

#### 1. **Type Mismatch Errors**

**Example Error:**
```
motor.cpp:145:23: error: cannot convert 'float*' to 'const float&'
    update_current_control(phase_current);
                          ^~~~~~~~~~~~~
```

**💬 Chat Mode Prompt:**
```
@terminal shows type error on motor.cpp:145. 
Can you explain why phase_current can't convert and suggest the fix?
```

**AI Response:**
- Identifies function signature mismatch
- Shows the expected type
- Suggests: dereference pointer or change function signature

#### 2. **Undefined Reference (Linker Errors)**

**Example Error:**
```
undefined reference to `Encoder::update_pll_gains(float, float)'
```

**💬 Chat Mode Prompt:**
```
@terminal shows linker error for Encoder::update_pll_gains.
The declaration exists in encoder.hpp but linker can't find it.
What's wrong?
```

**AI Response:**
- Checks if function is defined in encoder.cpp
- Verifies function signature matches declaration
- Checks if encoder.cpp is included in build
- Suggests: add missing implementation or fix signature

#### 3. **Template Instantiation Errors**

**Example Error:**
```
template_controller.hpp:87:12: error: no matching function for call to 'min(unsigned int, int)'
    size_t len = std::min(buffer_size, count);
                 ^~~~~~~~
```

**💬 Chat Mode Prompt:**
```
@terminal shows template error with std::min. 
Types don't match (unsigned int vs int).
What's the best fix for embedded C++?
```

**AI Response:**
- Explains implicit conversion issues
- Suggests explicit cast or type consistency
- Recommends embedded-safe approach (no exceptions)

#### 4. **Missing Header / Include Errors**

**Example Error:**
```
axis.cpp:23:5: error: 'uint32_t' does not name a type
    uint32_t control_deadline_;
    ^~~~~~~~
```

**💬 Chat Mode Prompt:**
```
@terminal shows 'uint32_t' not recognized in axis.cpp.
Which header is missing?
```

**AI Response:**
- Identifies missing `#include <cstdint>` or `<stdint.h>`
- Checks existing includes
- Suggests proper header to add

### Demo Example: ODrive Build Error
**🎯 Copilot Mode: Chat**

**Scenario:** You're modifying motor.cpp and introduce a build error

**Error Message:**
```
[ tup ] motor.cpp:234:error: 'motor_current_limit' was not declared in this scope
[ tup ] Build failed
```

**💬 Chat Mode Prompt:**
```
@terminal shows compile error: 'motor_current_limit' not declared in motor.cpp:234

Context: I'm in the update() method trying to limit phase current.
What's the correct variable name and where is it defined?
```

**Expected AI Response:**
```
The error indicates 'motor_current_limit' is not in scope. Looking at motor.hpp,
the correct member variable is:

    motor_.config_.current_lim

Not 'motor_current_limit'. The current limit is accessed through the config struct.

Fix in motor.cpp line 234:
    float Iq_limit = motor_.config_.current_lim;

The config struct is defined in motor.hpp around line 45.
```

### Best Practices

**1. Provide Context**
```
Good: "@terminal shows error at motor.cpp:234. 
       I'm trying to access the current limit configuration."

Bad:  "@terminal fix this"
```

**2. Include the Full Error**
```
Good: [paste entire error including file, line, and message]

Bad:  "I got an error about uint32_t"
```

**3. Mention What You Were Doing**
```
"@terminal error after adding thermal monitoring to motor.cpp.
 I included thermistor.hpp but getting undefined reference."
```

**4. Ask for Explanation + Fix**
```
"@terminal can you explain this linker error AND suggest the fix?"
```

---

## 2. /fix for Bug Resolution (10 min)

### What is /fix?
**🎯 Copilot Modes: Chat + Inline**

**Files to demonstrate:**
- [src-ODrive/Firmware/MotorControl/motor.cpp](../../src-ODrive/Firmware/MotorControl/motor.cpp) - Logic bug examples
- [src-ODrive/Firmware/MotorControl/axis.cpp](../../src-ODrive/Firmware/MotorControl/axis.cpp) - State machine debugging

The `/fix` command is a **code-focused debugging assistant** that:
- Analyzes your code for bugs
- Suggests specific fixes
- Explains the root cause
- Can be applied directly to your code

### /fix vs @terminal

| @terminal | /fix |
|-----------|------|
| Build/compile errors | Logic bugs in code |
| Tool chain issues | Runtime errors |
| Linker problems | Algorithm mistakes |
| Error message interpretation | Code improvement |
| **Works on terminal output** | **Works on code selection** |

### /fix Workflow
**🎯 Copilot Mode: Inline + Chat**

**Step 1: Select the buggy code**
- Highlight the function or block with the bug
- Or position cursor on the error line

**Step 2: Invoke /fix**
- Type `/fix` in chat
- Or select code → Right-click → "Fix using Copilot"
- Or use inline chat: `Ctrl+I` then type `/fix`

**Step 3: Review the suggestion**
- AI shows the fix with explanation
- You can accept, reject, or iterate

**Step 4: Test the fix**
- Apply the change
- Rebuild and test
- Iterate if needed

### Common Bug Types /fix Handles

#### 1. **Off-by-One Errors**

**Buggy Code:**
```cpp
// motor.cpp - Circular buffer implementation
void Motor::log_fault(Error error) {
    fault_history_[fault_index_] = error;
    fault_index_++;
    if (fault_index_ > FAULT_HISTORY_SIZE) {  // BUG!
        fault_index_ = 0;
    }
}
```

**💬 Chat Mode Prompt (Select code + /fix):**
```
/fix this circular buffer logic
```

**AI Response:**
```
Off-by-one error detected. The condition should be '>=' not '>'.

With FAULT_HISTORY_SIZE = 10, valid indices are 0-9.
Current code: fault_index_ > 10 means it wraps at 11, causing buffer overflow.

Fix:
    if (fault_index_ >= FAULT_HISTORY_SIZE) {
        fault_index_ = 0;
    }
```

#### 2. **Null Pointer Dereference**

**Buggy Code:**
```cpp
void Axis::update_watchdog() {
    if (config_.watchdog_timeout > 0) {
        watchdog_timer_->reset();  // CRASH if watchdog_timer_ is nullptr!
    }
}
```

**💬 Chat Mode Prompt (Select code + /fix):**
```
/fix potential null pointer crash
```

**AI Response:**
```
Null pointer dereference risk. watchdog_timer_ might be nullptr
if watchdog is not enabled.

Fix:
    if (config_.watchdog_timeout > 0 && watchdog_timer_) {
        watchdog_timer_->reset();
    }

Or initialize watchdog_timer_ in constructor to avoid nullptr.
```

#### 3. **Race Conditions (Thread Safety)**

**Buggy Code:**
```cpp
// Called from interrupt
void Encoder::handle_index_pulse() {
    index_found_ = true;
    position_estimate_ = 0.0f;  // RACE: Main loop reads this!
}

// Called from main loop
float Encoder::get_position() {
    return position_estimate_;  // RACE: ISR writes this!
}
```

**💬 Chat Mode Prompt (Select code + /fix):**
```
/fix thread safety issue between ISR and main loop
```

**AI Response:**
```
Race condition: ISR writes position_estimate_ while main loop reads it.
On ARM Cortex-M4, float is 32-bit but assignment isn't atomic.

Fixes:
1. Use atomic operations:
   std::atomic<float> position_estimate_;

2. Or disable interrupts during read:
   __disable_irq();
   float pos = position_estimate_;
   __enable_irq();

3. Or use a lock-free queue to pass data from ISR to main.

Recommendation for embedded: Option 2 (interrupt disable) is fastest.
```

#### 4. **Memory Leaks**

**Buggy Code:**
```cpp
void setup_can_filters() {
    CAN_FilterTypeDef* filter = new CAN_FilterTypeDef();  // LEAK!
    filter->FilterIdHigh = 0x123;
    HAL_CAN_ConfigFilter(&hcan, filter);
    // filter is never deleted!
}
```

**💬 Chat Mode Prompt (Select code + /fix):**
```
/fix memory leak
```

**AI Response:**
```
Memory leak: 'filter' is allocated with 'new' but never deleted.

However, for embedded systems, dynamic allocation is discouraged.

Better fix (no heap allocation):
    CAN_FilterTypeDef filter;  // Stack allocation
    filter.FilterIdHigh = 0x123;
    HAL_CAN_ConfigFilter(&hcan, &filter);
    // Automatically freed when function exits

If heap is required:
    std::unique_ptr<CAN_FilterTypeDef> filter = 
        std::make_unique<CAN_FilterTypeDef>();
```

#### 5. **Integer Overflow**

**Buggy Code:**
```cpp
// Calculate velocity from encoder ticks
float Encoder::get_velocity() {
    int32_t delta_ticks = current_ticks_ - last_ticks_;
    float delta_time = 0.000125f;  // 8 kHz = 125 μs
    return (delta_ticks / encoder_cpr_) * (1.0f / delta_time);  // Overflow!
}
```

**💬 Chat Mode Prompt (Select code + /fix):**
```
/fix potential overflow in velocity calculation
```

**AI Response:**
```
Integer overflow risk if delta_ticks * (1/delta_time) exceeds int32_t range.

Also, integer division 'delta_ticks / encoder_cpr_' loses precision.

Fix:
    float velocity = (float)delta_ticks / (float)encoder_cpr_ / delta_time;

Or better:
    float velocity = static_cast<float>(delta_ticks) / 
                     static_cast<float>(encoder_cpr_) / delta_time;

Cast to float BEFORE division to preserve precision.
```

### /fix with Embedded Systems Context
**🎯 Copilot Mode: Chat + Inline**

When using `/fix` for embedded code, add context:

**💬 Chat Mode Prompt:**
```
/fix this interrupt handler

Context:
- Runs at 8 kHz (125μs period)
- Must complete in <50μs
- No heap allocation allowed
- MISRA C++ compliant
- ARM Cortex-M4 target
```

AI will provide fixes that respect these constraints!

---

## 3. Common C++ Debugging (10 min)

### The 5 Most Common C++ Bugs
**🎯 Copilot Modes: Chat + Agent**

**Files to demonstrate:**
- [src-ODrive/Firmware/MotorControl/encoder.cpp](../../src-ODrive/Firmware/MotorControl/encoder.cpp) - Variable initialization
- [src-ODrive/Firmware/Board/v3/board.cpp](../../src-ODrive/Firmware/Board/v3/board.cpp) - Volatile usage

#### 1. **Uninitialized Variables**

**Problem:**
```cpp
void Motor::calibrate() {
    float offset;  // Uninitialized!
    if (some_condition) {
        offset = measure_offset();
    }
    apply_calibration(offset);  // BUG: offset might be garbage
}
```

**How to Debug:**
```
Select code → /fix uninitialized variable
```

**Fix:**
```cpp
float offset = 0.0f;  // Always initialize!
```

**Copilot Tip:** Enable compiler warnings: `-Wuninitialized`

#### 2. **Buffer Overflows**

**Problem:**
```cpp
char message[32];
sprintf(message, "Axis %d: Position %.6f, Velocity %.6f", 
        axis_id, position, velocity);  // Might overflow!
```

**How to Debug:**
```
Select code → /fix buffer overflow risk
```

**Fix:**
```cpp
snprintf(message, sizeof(message), 
         "Axis %d: Pos %.3f, Vel %.3f", 
         axis_id, position, velocity);
```

**Copilot Tip:** Ask for `snprintf` replacements automatically

#### 3. **Dangling Pointers**

**Problem:**
```cpp
Motor* motor = &axis->motor_;
delete axis;  // Oops!
motor->update();  // CRASH: dangling pointer
```

**How to Debug:**
```
Select code → /fix dangling pointer after delete
```

**Fix:**
```cpp
// Option 1: Don't delete until done
motor->update();
delete axis;

// Option 2: Use smart pointers
std::unique_ptr<Axis> axis = std::make_unique<Axis>();
Motor* motor = &axis->motor_;
motor->update();
// axis deleted automatically, no dangling pointer risk
```

#### 4. **Const Correctness**

**Problem:**
```cpp
float Motor::get_temperature() {  // Should be const!
    return thermistor_.read();  // But read() isn't const either!
}

// Can't call on const motor:
void display(const Motor& motor) {
    float temp = motor.get_temperature();  // ERROR!
}
```

**How to Debug:**
```
Select code → /fix const correctness
```

**Fix:**
```cpp
float Motor::get_temperature() const {  // Add const
    return thermistor_.read();
}

// Also fix Thermistor::read():
float Thermistor::read() const {
    return last_reading_;  // Read from cached value
}
```

#### 5. **Volatile Misuse**

**Problem:**
```cpp
// Hardware register
volatile uint32_t* DMA_STATUS = (uint32_t*)0x40020400;

// BUG: Compiler might optimize away repeated reads!
while (*DMA_STATUS & DMA_BUSY) {
    // Wait...
}
```

**How to Debug:**
```
Select code → /fix volatile usage for hardware register
```

**Fix:**
```cpp
// Already correct IF DMA_STATUS is volatile
// But check the actual register definition:

// Good:
#define DMA1_SR  (*(volatile uint32_t*)0x40020400)

// Better (type-safe):
struct DMA_Regs {
    volatile uint32_t SR;   // Status register
    volatile uint32_t CR;   // Control register
};
DMA_Regs* const dma1 = (DMA_Regs*)0x40020000;

while (dma1->SR & DMA_BUSY) {
    // Compiler cannot optimize away volatile read
}
```

### Debugging Strategy with Copilot
**🎯 Copilot Modes: Chat + Agent**

**Step 1: Reproduce the Bug**
- Can you trigger it consistently?
- What are the preconditions?

**Step 2: Isolate the Problem**

**🤖 Agent Mode Prompt:**
```
@workspace find all places where motor_current_limit is written
```

**Step 3: Examine Suspicious Code**

**💬 Chat Mode Prompt:**
```
Select function → "/explain why this might crash"
```

**Step 4: Apply Fix**

**💬 Chat Mode Prompt:**
```
Select code → "/fix the race condition"
```

**Step 5: Verify Fix**

**💬 Chat Mode Prompt:**
```
"Generate a unit test for this fix"
```

---

## 4. Hands-On: Debug Session (15 min)

### Exercise: Fix Bugs in ODrive Motor Control
**🎯 Copilot Modes: Chat + Inline**

**Scenario:** You've inherited buggy motor control code with 3 known issues. Use Copilot to find and fix them!

**Files to work with:**
- [src-ODrive/Firmware/MotorControl/motor.cpp](../../src-ODrive/Firmware/MotorControl/motor.cpp) - Fault history bug
- [src-ODrive/Firmware/MotorControl/encoder.cpp](../../src-ODrive/Firmware/MotorControl/encoder.cpp) - Race condition and overflow

---

### Bug 1: Off-By-One in Fault History (5 min)

**File:** `motor.cpp` (hypothetical buggy version)

**Buggy Code:**
```cpp
void Motor::log_current_fault() {
    if (current_faults_ > 0) {
        fault_history_[fault_write_idx_] = get_active_error();
        fault_write_idx_++;
        
        // BUG: Should this be > or >=?
        if (fault_write_idx_ > FAULT_HISTORY_SIZE) {
            fault_write_idx_ = 0;
        }
    }
}
```

**Your Task:**

**Step 1:** Identify the bug using Copilot
```
Select the function → Type in chat:
"/explain what's wrong with this circular buffer logic"
```

**Step 2:** Get the fix
```
"/fix the off-by-one error"
```

**Step 3:** Understand WHY it's wrong
```
"Why is >= correct but > is wrong for array bounds?"
```

**Expected Fix:**
```cpp
if (fault_write_idx_ >= FAULT_HISTORY_SIZE) {
    fault_write_idx_ = 0;
}
```

---

### Bug 2: Race Condition in Position Estimate (5 min)

**File:** `encoder.cpp` (hypothetical)

**Buggy Code:**
```cpp
// Called from 8 kHz interrupt
void Encoder::update() {
    count_ += get_delta();
    position_estimate_ = (float)count_ / (float)cpr_;  // RACE!
    velocity_estimate_ = calculate_velocity();          // RACE!
}

// Called from main loop (1 kHz)
void Axis::control_loop() {
    float pos = encoder_.position_estimate_;  // RACE!
    float vel = encoder_.velocity_estimate_;  // RACE!
    // Use pos and vel for control...
}
```

**Your Task:**

**Step 1:** Identify the race condition
```
Select both functions → Type:
"/fix thread safety between ISR and main loop"
```

**Step 2:** Evaluate proposed solutions
Copilot might suggest:
- Atomics
- Interrupt disabling
- Double buffering
- Volatile (not sufficient!)

**Step 3:** Choose the best for embedded
```
"Which fix has the lowest overhead for ARM Cortex-M4?"
```

**Expected Fix:**
```cpp
// Option 1: Disable interrupts briefly
void Axis::control_loop() {
    float pos, vel;
    __disable_irq();
    pos = encoder_.position_estimate_;
    vel = encoder_.velocity_estimate_;
    __enable_irq();
    // Use pos and vel...
}

// Option 2: Double buffering (copy in ISR)
void Encoder::update() {
    // ISR updates shadow copies
    shadow_position_ = (float)count_ / (float)cpr_;
    shadow_velocity_ = calculate_velocity();
    ready_flag_ = true;
}

void Encoder::get_estimates(float* pos, float* vel) {
    if (ready_flag_) {
        *pos = shadow_position_;
        *vel = shadow_velocity_;
        ready_flag_ = false;
    }
}
```

---

### Bug 3: Integer Overflow in Speed Calculation (5 min)

**File:** `encoder.cpp` (hypothetical)

**Buggy Code:**
```cpp
float Encoder::calculate_rpm() {
    int32_t delta_count = count_ - last_count_;
    int32_t delta_time_us = 125;  // 8 kHz
    
    // BUG: Intermediate overflow!
    int32_t rpm = (delta_count * 60 * 1000000) / (cpr_ * delta_time_us);
    
    return (float)rpm;
}
```

**Your Task:**

**Step 1:** Use Copilot to detect overflow
```
Select function → "/fix potential integer overflow"
```

**Step 2:** Understand the problem
```
"Show me the math for when this overflows"
```

**Step 3:** Apply the fix
```
"/fix use float math to avoid overflow"
```

**Expected Fix:**
```cpp
float Encoder::calculate_rpm() {
    int32_t delta_count = count_ - last_count_;
    float delta_time_s = 125e-6f;  // 125 μs in seconds
    
    // Convert to float early to avoid overflow
    float revolutions = (float)delta_count / (float)cpr_;
    float rps = revolutions / delta_time_s;
    float rpm = rps * 60.0f;
    
    return rpm;
}
```

---

## Speaker Instructions

### Session Setup (Before Class)

1. **Prepare demonstration errors:**
   - Have pre-made buggy code snippets ready
   - Test that @terminal works with your terminal output
   - Verify /fix command is responsive

2. **Environment check:**
   - Build environment configured (tup/make)
   - Sample compiler errors ready to show
   - ODrive workspace open with motor control files

### Demonstration Flow

1. **@terminal demo (5 min):**
   - Trigger a real compile error in motor.cpp
   - Show @terminal interpreting the error
   - Apply the suggested fix

2. **/fix demo (5 min):**
   - Select buggy circular buffer code
   - Use /fix to get correction
   - Explain why the fix works

3. **Common bugs walkthrough (5 min):**
   - Show each bug pattern briefly
   - Highlight embedded-specific concerns
   - Point out ISR safety issues

### Key Teaching Points

- **Context matters:** Show good vs bad prompts side-by-side
- **Iterate:** First fix might not be perfect - show refinement
- **Always review:** Never accept fixes blindly
- **Test fixes:** Rebuild and verify after applying changes

---

## Participant Instructions

### Exercise 1: @terminal for Build Errors (5 min)

**Goal:** Use @terminal to diagnose and fix a compiler error

**Steps:**
1. Open `src-ODrive/Firmware/MotorControl/motor.cpp`
2. Introduce an intentional error (e.g., typo in variable name)
3. Build the project: `tup` or `make`
4. Copy the error to Copilot Chat with @terminal
5. Apply the suggested fix
6. Rebuild to verify

**Success Criteria:**
- [ ] Error correctly diagnosed by @terminal
- [ ] Fix applied successfully
- [ ] Project builds without errors

### Exercise 2: /fix for Logic Bugs (5 min)

**Goal:** Use /fix to correct off-by-one and null pointer bugs

**Steps:**
1. Find or create a circular buffer with off-by-one error
2. Select the buggy code
3. Type `/fix this circular buffer logic` in chat
4. Review and apply the suggested fix
5. Explain why >= is correct instead of >

**Success Criteria:**
- [ ] Off-by-one error identified
- [ ] Correct fix applied
- [ ] Can explain the reasoning

### Exercise 3: Race Condition Detection (5 min)

**Goal:** Identify and fix ISR/main loop race conditions

**Steps:**
1. Review the encoder position race condition example
2. Select both ISR and main loop functions
3. Ask Copilot: `/fix thread safety between ISR and main loop`
4. Evaluate the proposed solutions
5. Choose the best fix for embedded (interrupt disable)

**Success Criteria:**
- [ ] Race condition understood
- [ ] Multiple fix options evaluated
- [ ] Embedded-appropriate solution selected

---

## Quick Reference: Debugging Tools

### Tool Comparison

| Tool | Use Case | Input | Output |
|------|----------|-------|--------|
| `@terminal` | Build/compile errors | Terminal output | Diagnosis + fix |
| `/fix` | Logic bugs | Selected code | Code correction |
| `/explain` | Understanding code | Selected code | Explanation |
| `@workspace` | Finding code | Search query | File locations |

### @terminal Prompts

| Scenario | Prompt Template |
|----------|-----------------|
| Type mismatch | `@terminal shows type error on [file]:[line]. Explain and suggest fix.` |
| Undefined reference | `@terminal linker error for [symbol]. Declaration in [header] but linker can't find it.` |
| Missing header | `@terminal shows '[type]' not recognized. Which header is missing?` |
| Template error | `@terminal template error with [function]. Types don't match. Best fix for embedded?` |

### /fix Prompts

| Bug Type | Prompt Template |
|----------|-----------------|
| Off-by-one | `/fix this circular buffer logic` |
| Null pointer | `/fix potential null pointer crash` |
| Race condition | `/fix thread safety between ISR and main loop` |
| Memory leak | `/fix memory leak` |
| Integer overflow | `/fix potential integer overflow` |

### Debugging Workflow

```
1. Reproduce the bug
   ↓
2. @workspace: Find related code
   ↓
3. /explain: Understand the logic
   ↓
4. /fix: Get suggested fix
   ↓
5. @terminal: If build fails
   ↓
6. Test the fix
   ↓
7. Generate regression test
```

---

## Troubleshooting

| Issue | Possible Cause | Debug Tips |
|-------|----------------|------------|
| @terminal not recognizing errors | Terminal output not captured | Copy/paste error directly into chat |
| /fix suggests wrong fix | Insufficient context | Add constraints: "embedded, no heap, ISR-safe" |
| Fix doesn't compile | AI missed type or signature | Provide more surrounding code context |
| Race condition fix too slow | Used mutex in ISR | Ask for "lowest overhead fix for Cortex-M4" |
| Overflow fix changes behavior | Float precision differs | Specify precision requirements in prompt |
| AI suggests heap allocation | Didn't specify embedded | Add "static allocation only, no new/malloc" |

### Common Mistakes to Avoid

1. **Vague prompts:** Always include file, line, and what you're trying to do
2. **Accepting blindly:** Review every fix before applying
3. **Skipping rebuild:** Always rebuild after applying fixes
4. **Missing constraints:** Specify embedded requirements (no exceptions, static alloc)
5. **Not iterating:** If first fix is wrong, provide more context and try again

---

## Additional Resources

### Official Documentation

- [GitHub Copilot Chat Documentation](https://docs.github.com/en/copilot/github-copilot-chat)
- [VS Code Debugging](https://code.visualstudio.com/docs/editor/debugging)
- [C++ Debugging in VS Code](https://code.visualstudio.com/docs/cpp/cpp-debug)

### ODrive Reference Files

- [src-ODrive/Firmware/MotorControl/motor.cpp](../../src-ODrive/Firmware/MotorControl/motor.cpp) - Motor implementation
- [src-ODrive/Firmware/MotorControl/encoder.cpp](../../src-ODrive/Firmware/MotorControl/encoder.cpp) - Encoder logic
- [src-ODrive/Firmware/MotorControl/axis.cpp](../../src-ODrive/Firmware/MotorControl/axis.cpp) - State machine

### Further Practice

- Enable all compiler warnings: `-Wall -Wextra -Wpedantic`
- Use static analysis: `cppcheck`, `clang-tidy`
- Ask Copilot to explain warning messages

---

## Q&A

### Common Questions

**"Does /fix work for all bugs?"**
- No - /fix is best for clear logical errors
- Complex architectural issues need human insight
- Runtime bugs need more context

**"Can Copilot debug hardware issues?"**
- Yes, if you describe the symptoms
- "Motor stutters at high speed" → AI suggests control loop timing
- But can't debug physical hardware faults

**"What if the fix doesn't work?"**
- Iterate! Provide more context
- Try different approaches: "What other ways to fix this?"
- Sometimes you need multiple iterations

**"Should I trust AI fixes blindly?"**
- NO! Always review and understand the fix
- Test thoroughly
- AI can miss edge cases or constraints

---

## Key Takeaways

✅ **@terminal** interprets build errors in context  
✅ **/fix** suggests code fixes for logic bugs  
✅ **Context is crucial** - tell AI what you're trying to do  
✅ **Iterate** - first fix might not be perfect  
✅ **Always review** - understand before accepting  
✅ **Test** - verify the fix works  
✅ **Learn** - ask AI to explain WHY the bug occurred  

**Remember:** Copilot is a debugging assistant, not a replacement for thinking. Use it to accelerate your debugging, not to avoid understanding your code!

---

*GitHub Copilot Hackathon - Debugging with Copilot Guide*

*Last Updated: January 2026*
