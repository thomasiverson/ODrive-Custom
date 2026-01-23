# Section 6: Hands-On Debugging Exercises

**Duration:** 15 minutes  
**Format:** Individual practice  
**Goal:** Apply @terminal and /fix to debug real code issues

---

## Exercise Overview

You'll debug **3 bugs** in ODrive-style motor control code. Each uses different Copilot debugging techniques.

| Bug | Technique | Difficulty | Time |
|-----|-----------|------------|------|
| 1. Circular Buffer | /fix | ⭐⭐ Medium | 5 min |
| 2. Race Condition | /fix + context | ⭐⭐⭐ Advanced | 5 min |
| 3. Integer Overflow | /explain + /fix | ⭐⭐ Medium | 5 min |

---

## Setup

### Files Provided
You should have these files in your workspace:
- `buggy_motor.cpp` - Motor control with bugs
- `buggy_encoder.cpp` - Encoder with race condition and overflow
- `test_fixes.cpp` - Unit tests to verify fixes

### If Files Don't Exist
Create them with the buggy code provided in each exercise below.

---

## Bug 1: Off-By-One in Circular Buffer (5 min)

### Background
The motor controller logs the last 10 faults in a circular buffer. Users report that sometimes the system crashes when logging the 11th fault.

### Buggy Code

**File:** `buggy_motor.cpp`

```cpp
#define FAULT_HISTORY_SIZE 10

class Motor {
private:
    uint32_t fault_history_[FAULT_HISTORY_SIZE];
    size_t fault_idx_ = 0;
    
public:
    void log_fault(uint32_t error_code) {
        fault_history_[fault_idx_] = error_code;
        fault_idx_++;
        
        // BUG: Boundary check is wrong!
        if (fault_idx_ > FAULT_HISTORY_SIZE) {
            fault_idx_ = 0;
        }
    }
    
    void print_faults() {
        for (size_t i = 0; i < FAULT_HISTORY_SIZE; i++) {
            printf("Fault %zu: 0x%08X\n", i, fault_history_[i]);
        }
    }
};
```

### Your Task

**Step 1: Identify the Bug (2 min)**

Select the `log_fault()` function and type:
```
/fix the circular buffer boundary check
```

**Questions to answer:**
- What's wrong with `if (fault_idx_ > FAULT_HISTORY_SIZE)`?
- What should it be instead?
- Why does this cause a crash?

**Step 2: Apply the Fix (1 min)**

Change the code based on Copilot's suggestion.

**Step 3: Verify (2 min)**

Ask Copilot to generate a test:
```
@ODrive-QA Generate a unit test that logs 15 faults and verifies no crash
```

> **Note:** Using `@ODrive-QA` invokes the `odrive-qa-assistant` skill for test generation.

Run the test mentally or with a simple main():
```cpp
int main() {
    Motor motor;
    for (int i = 0; i < 15; i++) {
        motor.log_fault(0x1000 + i);
    }
    motor.print_faults();
    return 0;
}
```

### Success Criteria
- ✅ Understand why `>` is wrong and `>=` is correct
- ✅ Code handles wrapping correctly at index 9 → 0
- ✅ No buffer overflow when logging 15+ faults

### Solution

<details>
<summary>Click to reveal solution</summary>

**The Bug:**
```cpp
if (fault_idx_ > FAULT_HISTORY_SIZE) {  // BUG!
```

With `FAULT_HISTORY_SIZE = 10`, valid indices are 0-9.
- When `fault_idx_` reaches 10, it's NOT > 10, so it doesn't wrap
- Next iteration tries to access `fault_history_[10]` → Buffer overflow!

**The Fix:**
```cpp
if (fault_idx_ >= FAULT_HISTORY_SIZE) {  // CORRECT
    fault_idx_ = 0;
}
```

Now when `fault_idx_` reaches 10, it equals `FAULT_HISTORY_SIZE`, wraps to 0.

</details>

---

## Bug 2: Race Condition (5 min)

### Background
The encoder updates position estimates in an 8 kHz interrupt. The main control loop reads these estimates at 1 kHz. On an ARM Cortex-M4, float assignments are not atomic, leading to corrupted position readings.

### Buggy Code

**File:** `buggy_encoder.cpp`

```cpp
class Encoder {
private:
    int32_t count_ = 0;
    int32_t last_count_ = 0;
    float position_estimate_ = 0.0f;
    float velocity_estimate_ = 0.0f;
    int32_t cpr_ = 8192;  // Counts per revolution
    
public:
    // Called from 8 kHz interrupt
    void update_isr() {
        int32_t delta = get_delta_count();  // Hardware read
        count_ += delta;
        
        // RACE: Main loop reads these while ISR writes!
        position_estimate_ = (float)count_ / (float)cpr_;
        velocity_estimate_ = (float)delta / (float)cpr_ * 8000.0f;  // delta * freq
    }
    
    // Called from main loop (1 kHz)
    float get_position() {
        return position_estimate_;  // RACE: ISR writes this!
    }
    
    float get_velocity() {
        return velocity_estimate_;  // RACE: ISR writes this!
    }
    
private:
    int32_t get_delta_count() {
        // Simulated: read encoder hardware
        return 10;  // Dummy value
    }
};
```

### Your Task

**Step 1: Identify the Race (2 min)**

Select both `update_isr()` and `get_position()` functions. Type:
```
/fix thread safety issue between ISR and main loop

Context:
- ISR runs at 8 kHz (every 125 μs)
- Main loop at 1 kHz (every 1 ms)
- ARM Cortex-M4 (float not atomic)
- Need lowest overhead solution
```

**Questions to answer:**
- Why is this a race condition?
- What can go wrong when main loop reads during ISR write?
- Which Copilot suggestion has the lowest overhead?

> **Tip:** For complex race conditions spanning multiple files, use `@ODrive-Engineer` for deeper codebase analysis.

**Step 2: Evaluate Solutions (2 min)**

Copilot might suggest:
1. **Disable interrupts** during read
2. **Double buffering** (shadow copies)
3. **Atomic variables** (std::atomic<float>)
4. **Volatile** (NOT sufficient!)

Ask Copilot:
```
Which solution has lowest overhead for 8 kHz ISR on ARM Cortex-M4?
```

**Step 3: Apply the Fix (1 min)**

Implement the recommended solution.

### Success Criteria
- ✅ Understand why float read/write isn't atomic
- ✅ Know multiple solutions and their trade-offs
- ✅ Choose the lowest-overhead solution
- ✅ Explain when to use each approach

### Solution

<details>
<summary>Click to reveal solution</summary>

**The Race:**
On ARM Cortex-M4, float is 32-bit but load/store isn't guaranteed atomic:
```
Float write:  [byte0][byte1][byte2][byte3]
                 ↑ ISR interrupted here
Float read:   [OLD0][OLD1][NEW2][NEW3]  ← Corrupted!
```

**Solution 1: Disable Interrupts (Lowest Overhead - ~10 cycles)**
```cpp
float Encoder::get_position() {
    __disable_irq();
    float pos = position_estimate_;
    __enable_irq();
    return pos;
}

float Encoder::get_velocity() {
    __disable_irq();
    float vel = velocity_estimate_;
    __enable_irq();
    return vel;
}
```

**Solution 2: Double Buffering (More Complex)**
```cpp
class Encoder {
private:
    float position_shadow_ = 0.0f;
    float velocity_shadow_ = 0.0f;
    volatile bool ready_ = false;
    
public:
    void update_isr() {
        // ... calculate ...
        position_shadow_ = new_position;
        velocity_shadow_ = new_velocity;
        ready_ = true;
    }
    
    float get_position() {
        if (ready_) {
            position_estimate_ = position_shadow_;
            ready_ = false;
        }
        return position_estimate_;
    }
};
```

**Solution 3: Atomic (C++11, might not compile on all embedded)**
```cpp
std::atomic<float> position_estimate_;
std::atomic<float> velocity_estimate_;
```

**Recommended for embedded:** Solution 1 (interrupt disable) - simple, fast, predictable.

</details>

---

## Bug 3: Integer Overflow in Speed Calculation (5 min)

### Background
The encoder calculates motor RPM from tick counts. At low speeds it works fine, but at high speeds (>10,000 RPM), the displayed value jumps to huge numbers like 2 billion RPM.

### Buggy Code

**File:** `buggy_encoder.cpp`

```cpp
class Encoder {
private:
    int32_t count_ = 0;
    int32_t last_count_ = 0;
    int32_t cpr_ = 8192;  // Counts per revolution
    
public:
    // Called every 125 μs (8 kHz)
    float calculate_rpm() {
        int32_t delta_count = count_ - last_count_;
        last_count_ = count_;
        
        int32_t delta_time_us = 125;  // 8 kHz = 125 μs period
        
        // BUG: Integer overflow in calculation!
        // RPM = (counts/revolution) * (revolutions/second) * (60 sec/min)
        // RPM = (delta_count / cpr) * (1,000,000 us/s / delta_time_us) * 60
        int32_t rpm = (delta_count * 60 * 1000000) / (cpr_ * delta_time_us);
        
        return (float)rpm;
    }
};
```

### Your Task

**Step 1: Understand the Bug (2 min)**

Select the `calculate_rpm()` function and type:
```
/explain why this gives wrong values at high speeds
```

**Questions to answer:**
- At what motor speed does overflow occur?
- What is the intermediate value that overflows?
- What's the max value of int32_t?

**Hint:** At 10,000 RPM, delta_count ≈ 1000 per 125 μs

**Step 2: Calculate Overflow Point (1 min)**

Ask Copilot:
```
Show me the math for when (delta_count * 60 * 1000000) overflows int32_t
```

**Step 3: Get the Fix (1 min)**

Type:
```
/fix use float math to avoid overflow
```

**Step 4: Verify with Test (1 min)**

Ask:
```
@ODrive-QA Generate a unit test for calculate_rpm that tests speeds from 100 to 50,000 RPM
```

> **Note:** `@ODrive-QA` will invoke the `odrive-qa-assistant` skill to create comprehensive test cases.

### Success Criteria
- ✅ Understand intermediate overflow concept
- ✅ Know int32_t max value (2,147,483,647)
- ✅ Fix by converting to float early
- ✅ More readable and accurate calculation

### Solution

<details>
<summary>Click to reveal solution</summary>

**The Overflow:**
```cpp
// At 10,000 RPM: delta_count ≈ 1000
int32_t rpm = (delta_count * 60 * 1000000) / (cpr_ * delta_time_us);
              ^^^^^^^^^^^^^^^^^^^^^^^^^
              1000 * 60 * 1000000 = 60,000,000,000
              
Max int32_t: 2,147,483,647
60 billion > 2.1 billion → OVERFLOW!
```

**The Fix:**
```cpp
float Encoder::calculate_rpm() {
    int32_t delta_count = count_ - last_count_;
    last_count_ = count_;
    
    float delta_time_s = 125e-6f;  // 125 μs = 0.000125 s
    
    // Convert to float early - no overflow
    float revolutions = (float)delta_count / (float)cpr_;
    float rps = revolutions / delta_time_s;  // Revolutions per second
    float rpm = rps * 60.0f;
    
    return rpm;
}
```

**Why This Works:**
- float range: ±3.4e38 (way more than we need)
- No integer division (more accurate)
- More readable (clear units)

**Bonus: Optimize Further**
```cpp
// Precompute constants
static constexpr float SCALE = 60.0f / (8192.0f * 125e-6f);  // = 58593.75

float calculate_rpm() {
    int32_t delta_count = count_ - last_count_;
    last_count_ = count_;
    return (float)delta_count * SCALE;
}
```

</details>

---

## Bonus Challenge (If Time Permits)

### Bug 4: Memory Leak in Configuration

**Buggy Code:**
```cpp
void load_motor_config(const char* filename) {
    MotorConfig* config = new MotorConfig();  // LEAK!
    
    // Load from file
    FILE* f = fopen(filename, "r");
    if (f) {
        fread(config, sizeof(MotorConfig), 1, f);
        fclose(f);
    }
    
    apply_motor_config(config);
    // config is never deleted!
}
```

**Task:**
1. Use `/fix memory leak`
2. Get embedded-friendly solution (no heap allocation)
3. Alternative: Use smart pointers if heap is required

---

## General Tips for All Exercises

### Debugging Workflow
```
1. Read the bug description
   ↓
2. Look at the code and try to spot the bug
   ↓
3. Use /explain or /fix to get AI help
   ↓
4. Understand the root cause
   ↓
5. Apply the fix
   ↓
6. Ask for unit test
   ↓
7. Verify fix works
```

### Using Copilot Effectively

**For Compile Errors:**
```
@terminal shows error: [paste error]
Context: [what you were trying to do]
```

**For Logic Bugs (Single File):**
```
/fix [description of problem]
Context: [constraints, platform, timing]
```

**For Complex Multi-File Bugs:**
```
@ODrive-Engineer analyze this bug:
[description]
Context: [files involved, expected vs actual behavior]
```

**For Understanding:**
```
/explain why [specific behavior]
```

**For Testing & Build Verification:**
```
@ODrive-QA Generate a unit test that would catch this bug
@ODrive-QA Verify the fix compiles correctly
```

> **Note:** `@ODrive-QA` invokes the `odrive-qa-assistant` skill for builds and tests.

### Context is Key

Always provide:
- **Platform:** ARM Cortex-M4, x86, etc.
- **Timing:** ISR frequency, loop rate
- **Constraints:** No heap, MISRA C++, real-time
- **Expected behavior:** What should happen

---

## Presenter Notes

### Time Management
- **5 min per bug** is tight but achievable
- Announce "2 minutes remaining" for each bug
- It's OK if participants don't finish all 3
- Goal is learning the workflow, not completing everything

### Circulating Tips

**Look for:**
- Participants not using /fix or @terminal → Show them
- Participants getting wrong answers → Help refine prompts
- Participants stuck → Point to the step-by-step guide

**Common Issues:**

**"Copilot's answer doesn't make sense"**
→ Add more context about platform/constraints

**"I don't know which bug to start with"**
→ Start with Bug 1 (easiest), then Bug 3, then Bug 2 (hardest)

**"My code doesn't compile"**
→ Use `@terminal` to debug the compile error!
→ Or use `@ODrive-QA` to invoke build skill for verification

**"Bug spans multiple files"**
→ Use `@ODrive-Engineer` for multi-file analysis instead of `/fix`

### Debrief Questions (After Exercise)

**Ask the group:**
> "Who fixed Bug 1 (circular buffer)? [show of hands]"
> "Who fixed Bug 2 (race condition)? [show of hands]"
> "Who fixed Bug 3 (integer overflow)? [show of hands]"

> "Which bug was hardest? Why?"

> "How did Copilot help compared to traditional debugging?"

> "What debugging scenarios in your work could benefit from this?"

---

## Solutions Summary

### Quick Reference

| Bug | Line | Issue | Fix |
|-----|------|-------|-----|
| 1. Circular Buffer | `if (fault_idx_ > SIZE)` | Should be `>=` | Change to `>=` |
| 2. Race Condition | ISR writes, main reads | Float not atomic | Disable interrupts |
| 3. Integer Overflow | `delta * 60 * 1000000` | Exceeds int32_t | Convert to float early |

### Full Solutions Available

See `solutions/section6-debugging/` folder for:
- `fixed_motor.cpp` - Bug 1 fix
- `fixed_encoder.cpp` - Bugs 2 & 3 fixes
- `tests.cpp` - Unit tests for all fixes

---

## Key Takeaways

After this exercise, you should be able to:
- ✅ Use @terminal for build errors
- ✅ Use /fix for single-file logic bugs
- ✅ Use `@ODrive-Engineer` for complex multi-file bugs
- ✅ Use `@ODrive-QA` for test generation and build verification
- ✅ Provide effective context to Copilot
- ✅ Evaluate multiple fix suggestions
- ✅ Generate tests to verify fixes
- ✅ Debug embedded systems issues (race conditions, overflows)

**Remember:** Copilot is a tool to accelerate debugging, not replace thinking. Always understand the fix before applying it!

---

## Additional Practice

Want more debugging practice after the workshop?

### Resources
- Enable all compiler warnings: `-Wall -Wextra -Wpedantic`
- Try `cppcheck` or `clang-tidy` and ask Copilot to explain warnings
- Debug real ODrive issues from GitHub Issues

### Practice Scenarios
1. **Null pointer bugs** - Add null checks
2. **Const correctness** - Fix const propagation
3. **Move semantics** - Fix inefficient copies
4. **Template errors** - Debug template instantiation
5. **Linker errors** - Fix missing symbols

Ask Copilot to generate buggy code for practice:
```
Generate buggy C++ code with [type of bug] that I can practice debugging
```

**Good luck! 🚀**
