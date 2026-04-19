# Lesson 2: Hands-On Exercises

**Duration:** 30 minutes  
**Format:** Individual practice  
**Goal:** Practice GitHub Copilot fundamentals for C++ development, debugging, and refactoring

---

## Overview

These exercises map to the three lesson sections. Complete as many as time allows.

| Exercise | Lesson Section | Focus | Time |
|----------|---------------|-------|------|
| 1. Explore the Project with Ask Mode | Copilot Fundamentals | Understand project structure, dependencies, and layout | 5 min |
| 2. Inline Code Suggestions | Copilot Fundamentals | Get C++ completions as you type | 3 min |
| 3. Understand C++ Templates & Macros | Copilot Fundamentals | Use Ask Mode + /explain on unfamiliar C++ | 5 min |
| 4. Navigate a Large C++ Repo | Copilot Fundamentals | Use #codebase to find patterns and trace code | 5 min |
| 5. /explain and /fix on C++ Code | Copilot Fundamentals | Slash commands on real firmware code | 5 min |
| 6. Diagnose Compiler Errors | Debugging & Refactoring | Use Copilot to understand and fix build errors | 5 min |
| 7. Debug Runtime Issues | Debugging & Refactoring | Null pointers, memory issues, undefined behavior | 4 min |
| 8. @terminal and /fix Workflow | Debugging & Refactoring | Build in terminal, analyze errors, fix code | 3 min |

> **Tip:** Exercises 1–5 cover **Copilot Fundamentals**. Exercises 6–8 cover **Debugging & Refactoring**. Prioritize the section you're currently on.

---

## Before You Start

### Quick Mode Refresher

| Mode | Access | Use For |
|------|--------|---------|
| **Ask Mode** | Chat view (`Ctrl+Alt+I`) | Questions, exploration, understanding |
| **Edit Mode** | Inline chat (`Ctrl+I`) | Targeted code changes, docs, refactoring |
| **Agent Mode** | Chat view → Agent toggle | Complex multi-step, cross-file tasks |

### Useful References

| Feature | Syntax | Example |
|---------|--------|---------|
| Reference a file | `#file:` | `#file:motor.cpp` |
| Search codebase | `#codebase` | `find all uses of DRV8301 #codebase` |
| Terminal help | `@terminal` | `@terminal how do I build with tup?` |
| VS Code help | `@vscode` | `@vscode configure Cortex-Debug` |
| Slash commands | `/explain`, `/fix`, `/doc`, `/tests` | Select code → `Ctrl+I` → `/fix` |

---

## Section A: Copilot Fundamentals for C++ Development

---

### Exercise 1: Explore the Project with Ask Mode (5 min)

**Goal:** Use Ask Mode to understand the ODrive project before writing any code

<details>
<summary>📋 Instructions</summary>

1. Open the Chat view (`Ctrl+Alt+I`) and make sure you are in **Ask Mode**
2. Paste the following prompt and review the response:

   ```
   I'm new to the ODrive firmware project. Please answer the following:

   1. **Project overview** — What is this project, what hardware does it
      target, and what is the overall architecture (RTOS, control loops,
      communication layers)?

   2. **Dependencies** — List every external dependency the firmware relies
      on (RTOS, HAL libraries, driver ICs, third-party libs, build tools).
      For each, note the version or source if visible in the repo.

   3. **Project layout** — Describe the directory structure. What lives in
      Firmware/MotorControl/, Firmware/Drivers/, Firmware/Board/,
      Firmware/communication/, tools/, and docs/? How do they relate?

   4. **Adding a new module** — If I wanted to add a new control module
      (e.g., a thermal protection module), which files and build
      configuration would I need to create or modify? Are there
      registration steps, header includes, or build-system entries
      (Tup/Makefile) that must be updated?

   #codebase
   ```

3. Read through the response. Verify the information by spot-checking a few of the directories and files mentioned.
4. Ask a follow-up to go deeper on anything that surprised you, for example:
   ```
   Which third-party libraries are vendored directly in the repo versus
   pulled in during the build? #codebase
   ```

**Success Criteria:**
- ✅ Can describe the ODrive firmware architecture in one paragraph
- ✅ Know at least 4 external dependencies and where they live
- ✅ Understand which files to touch when adding a new module
</details>

<details>
<summary>💡 Solution</summary>

**Key things the response should cover:**

| Area | Expected Answer |
|------|----------------|
| Architecture | FreeRTOS on STM32, FOC control loop, USB/CAN/UART comms |
| Dependencies | FreeRTOS, STM32 HAL, CMSIS, DRV8301 driver, Tup build system, ARM GCC toolchain |
| Layout | `MotorControl/` = FOC + PID, `Drivers/` = HAL wrappers, `Board/` = pin maps + linker scripts, `communication/` = protocol handlers |
| New module | Add `.cpp`/`.hpp` in `MotorControl/`, include in `Tupfile` or `Makefile`, register with `Axis` or `Motor`, add to interface generator for remote access |

**Good follow-up prompts:**
```
Show me an example of how an existing module (e.g., Thermistor or
Encoder) is wired into the Axis class. I want to follow the same
pattern for my new module. #codebase
```
</details>

---

### Exercise 2: Inline Code Suggestions (3 min)

**Goal:** Experience Copilot's inline completions for C++ code

<details>
<summary>📋 Instructions</summary>

1. Open `Firmware/MotorControl/utils.cpp` (or any `.cpp` file)
2. Position your cursor at the end of the file
3. Type a comment, then start the function signature:
   ```cpp
   // Clamp a float value between min and max bounds
   float clamp_float(
   ```
4. Observe the inline suggestion — press `Tab` to accept
5. Try another: type a comment describing an ISR-safe ring buffer, then start the struct

**Tips for better suggestions:**
- Write a descriptive comment *before* the code
- Use meaningful names: `calculate_torque` not `calc`
- Have related files open in editor tabs for context

**Success Criteria:**
- ✅ Received and accepted an inline suggestion
- ✅ Comment-driven suggestion matched your intent
- ✅ Understand how to accept (`Tab`) or reject (`Escape`)
</details>

<details>
<summary>💡 Solution</summary>

**Comments that produce good inline completions:**
```cpp
// Calculate motor torque from phase current using the torque constant Kt
// Input: phase_current in amps, torque_constant in Nm/A
// Returns: torque in Nm
float calculate_torque(float phase_current, float torque_constant) {
```

```cpp
// Convert encoder counts to radians
// encoder_cpr: counts per revolution
float counts_to_radians(int32_t counts, uint32_t encoder_cpr) {
```

The more specific your comment, the better the suggestion. Including parameter names, units, and constraints guides Copilot effectively.
</details>

---

### Exercise 3: Understand Unfamiliar C++ — Templates, Macros, Pointers (5 min)

**Goal:** Use Ask Mode and /explain to decode complex C++ constructs

<details>
<summary>📋 Instructions</summary>

**Part A — Templates:**

1. Open Chat view (`Ctrl+Alt+I`) in Ask Mode
2. Ask:
   ```
   Explain the C++ templates used in #file:Firmware/communication/interface_can.hpp.
   What are the template parameters and how does template specialization
   work here? Explain it as if I'm coming from a C or Ada background.
   ```

**Part B — Macros:**

3. Ask:
   ```
   Find all preprocessor macros (#define) in #file:Firmware/MotorControl/board_config_v3.h.
   Explain each macro — what does it control, and what are the risks
   of changing its value on a live motor controller?
   ```

**Part C — Pointers & Memory:**

4. Select a function that uses raw pointers (e.g., in `low_level.cpp` or `motor.cpp`)
5. Press `Ctrl+I` and type: `/explain`
6. Follow up: "What are the pointer ownership semantics here? Could this cause a dangling pointer or use-after-free?"

**Success Criteria:**
- ✅ Can explain what a template parameter does in plain English
- ✅ Understand at least 3 macros and their effects
- ✅ Identified pointer ownership in one function
</details>

<details>
<summary>💡 Solution</summary>

**Effective prompts for C++ constructs:**

For templates:
```
What does `template<typename T>` mean in this context? Show me a
concrete example with actual types substituted in.
```

For macros:
```
List every #define in this file. For each, tell me:
1. What it controls
2. Default value
3. What breaks if I change it
```

For pointers:
```
This function takes a raw pointer parameter. Explain:
- Who owns the pointed-to memory?
- When is it allocated and freed?
- Is it safe to cache this pointer across function calls?
```
</details>

---

### Exercise 4: Navigate a Large C++ Repo (5 min)

**Goal:** Use `#codebase` and `#file:` to trace code paths across many files

<details>
<summary>📋 Instructions</summary>

Large C++ codebases (common in aerospace and embedded) are hard to navigate. Use Copilot to map them quickly.

1. Open Chat view (`Ctrl+Alt+I`)
2. **Trace an error code:**
   ```
   Where is ERROR_PHASE_RESISTANCE_OUT_OF_RANGE defined in this project?
   Trace every file where it is raised or checked. Show me the full
   call chain from detection to user notification. #codebase
   ```

3. **Map class relationships:**
   ```
   Explain the relationship between the Axis, Motor, Encoder, and
   Controller classes in #file:Firmware/MotorControl. How are they
   composed? Draw a Mermaid class diagram.
   ```

4. **Find patterns:**
   ```
   Find all interrupt handlers (functions ending with _IRQHandler) in
   the firmware. For each, list what peripheral it handles and which
   file it's in. #codebase
   ```

**Success Criteria:**
- ✅ Traced an error code from definition to every usage
- ✅ Understand the class hierarchy in MotorControl
- ✅ Found interrupt handlers across the codebase
</details>

<details>
<summary>💡 Solution</summary>

**Effective navigation prompts:**

```
Show me every file that #includes axis.hpp. What does each file
use from it? #codebase
```

```
Trace the data flow of a position setpoint from USB input through
the control loop to PWM output. List every function it passes
through. #codebase
```

```
What state machine controls the motor startup sequence? Show me the
states, transitions, and which file implements each. #codebase
```
</details>

---

### Exercise 5: /explain and /fix with C++ Examples (5 min)

**Goal:** Use slash commands on real firmware code

<details>
<summary>📋 Instructions</summary>

**Part A — /explain:**

1. Open `Firmware/MotorControl/foc.cpp`
2. Select the `FOC_voltage` or `FOC_current` function (or any substantial function)
3. Press `Ctrl+I` and type: `/explain`
4. Read the explanation, then ask a follow-up:
   ```
   What is the Clarke transform doing here? Explain the math
   in simple terms with the actual variable names from this code.
   ```

**Part B — /fix:**

1. Open `Firmware/MotorControl/controller.cpp`
2. Select a section of code
3. Press `Ctrl+I` and type:
   ```
   /fix Check this code for:
   - Integer overflow on arithmetic operations
   - Missing null checks on pointer dereferences
   - Race conditions if called from ISR context
   ```
4. Review the suggested fix — does it make sense for embedded?

**Success Criteria:**
- ✅ Got a clear explanation of a complex function
- ✅ /fix identified at least one real or potential issue
- ✅ Understand the difference between /explain (read-only) and /fix (suggests changes)
</details>

<details>
<summary>💡 Solution</summary>

**Targeted /explain prompts:**
```
/explain Focus on the control theory: what algorithm is this
implementing, what are the inputs/outputs, and what are the units?
```

**Targeted /fix prompts for embedded C++:**
```
/fix This code runs in a high-priority ISR. Check for:
- Dynamic memory allocation (malloc/new)
- Blocking calls (mutexes, printf)
- Shared variable access without volatile or atomics
```

```
/fix Refactor this to use static allocation instead of dynamic.
This runs on a microcontroller with 128KB RAM.
```
</details>

---

## Section B: Debugging and Refactoring C++ with Copilot

---

### Exercise 6: Diagnose Compiler Errors (5 min)

**Goal:** Use Copilot to understand and fix C++ build errors

<details>
<summary>📋 Instructions</summary>

1. Open `Firmware/MotorControl/motor.cpp`
2. Introduce a deliberate error — for example, change a variable type:
   ```cpp
   // Change a float to int to cause a narrowing conversion error
   // Or remove a semicolon, break a template parameter, etc.
   ```
3. Save the file — observe the squiggly error underlines
4. Hover over the error to see the compiler message
5. Select the line with the error, press `Ctrl+I` and type: `/fix`
6. Alternatively, paste the compiler error into Chat:
   ```
   I got this compiler error:
   error: cannot convert 'int' to 'float*' in assignment
   
   Explain what this means, why it happened, and how to fix it.
   The code is in #file:Firmware/MotorControl/motor.cpp
   ```
7. **Undo** your deliberate error after the exercise (`Ctrl+Z`)

**Real-World Scenario:**
Try asking about a template error:
```
Explain this error message:
error: no matching function for call to 'std::tuple<int, float>::get<2>()'
note: candidate template ignored: invalid explicitly-specified argument

What does "candidate template ignored" mean and how do I fix it?
```

**Success Criteria:**
- ✅ Copilot correctly explained a compiler error
- ✅ /fix generated a valid correction
- ✅ Understand how to paste terminal error output into Chat for diagnosis
</details>

<details>
<summary>💡 Solution</summary>

**For cryptic template errors:**
```
This template error is 50 lines long. Summarize:
1. What is the root cause (first error only)?
2. Which line of MY code caused it?
3. What's the fix?
Ignore the template instantiation backtrace.
```

**For linker errors:**
```
I'm getting "undefined reference to `Motor::update()'".
This is a linker error, not a compile error. Explain the difference
and show me how to check that motor.cpp is included in the build.
```
</details>

---

### Exercise 7: Debug Runtime Issues — Null Pointers & Memory (4 min)

**Goal:** Use Copilot to identify and fix runtime bugs in C++ code

<details>
<summary>📋 Instructions</summary>

1. Open Chat view in Ask Mode
2. **Null pointer analysis:**
   ```
   Analyze #file:Firmware/MotorControl/axis.cpp for potential null
   pointer dereferences. Which pointers are used without null checks?
   For each, show the line number and suggest a safe alternative.
   ```

3. **Memory issue analysis:**
   ```
   Search for all uses of malloc, new, or free in the Firmware/ directory.
   Are any of these in ISR context or time-critical loops?
   Suggest replacements using static allocation. #codebase
   ```

4. **Undefined behavior:**
   ```
   Check #file:Firmware/MotorControl/controller.cpp for potential
   undefined behavior:
   - Signed integer overflow
   - Uninitialized variables
   - Out-of-bounds array access
   - Strict aliasing violations
   ```

**Success Criteria:**
- ✅ Identified at least one potential null pointer issue
- ✅ Found dynamic allocation usage (if any) and understand why it's risky in embedded
- ✅ Understand what "undefined behavior" means in C++ and why it matters
</details>

<details>
<summary>💡 Solution</summary>

**Memory-focused prompts:**
```
Is there any stack overflow risk in this function? Estimate the
stack usage and compare it to a typical FreeRTOS task stack size
of 1024 words.
```

```
This code stores a pointer to a local variable. Explain why this
is a dangling pointer bug and how to fix it.
```

```
Find all global mutable variables in #file:motor.cpp. Which ones
are accessed from both ISR and task context? Are they protected
with volatile, atomics, or critical sections?
```
</details>

---

### Exercise 8: @terminal and /fix Workflow (3 min)

**Goal:** Use `@terminal` to understand build output and chain it with `/fix`

<details>
<summary>📋 Instructions</summary>

1. Ask `@terminal` about the build system:
   ```
   @terminal What is the exact command to build the ODrive firmware
   for the v3.6-56V board? What does each flag mean?
   ```

2. If you have build errors in the terminal, select the error text, then:
   - Right-click → "Copilot" → "Explain This"
   - Or copy-paste into Chat:
     ```
     I ran the build and got this terminal output. Explain the errors
     and suggest fixes:
     
     [paste terminal output here]
     ```

3. Use `@terminal` for tool commands:
   ```
   @terminal How do I run the Python test suite for ODrive?
   Show me the command and explain how to run just one test file.
   ```

4. Chain the workflow — fix and rebuild:
   ```
   The build error says "undefined reference to Motor::check_timing".
   Use /fix to add the missing function definition, then show me
   the command to rebuild.
   ```

**Success Criteria:**
- ✅ Used @terminal to get a build command
- ✅ Can explain a build error using Chat
- ✅ Understand the fix → rebuild workflow
</details>

<details>
<summary>💡 Solution</summary>

**@terminal examples:**
```
@terminal Show me how to use arm-none-eabi-objdump to disassemble
a specific function from the firmware .elf file
```

```
@terminal I see "region 'FLASH' overflowed by 1234 bytes" in my
build output. What does this mean and how do I reduce firmware size?
```

```
@terminal Generate a one-liner to find all .cpp files in Firmware/
that have been modified in the last 24 hours
```
</details>

---

## Summary: What You Practiced

| Exercise | Lesson Section | Key Skill |
|----------|---------------|-----------|
| 1. Inline Suggestions | Fundamentals | Comment-driven C++ completions |
| 2. Templates & Macros | Fundamentals | Ask Mode + /explain for unfamiliar C++ |
| 3. Navigate Large Repo | Fundamentals | #codebase for tracing code across files |
| 4. /explain and /fix | Fundamentals | Slash commands on real firmware |
| 5. Compiler Errors | Debugging | Diagnose and fix build errors with Copilot |
| 6. Runtime Issues | Debugging | Find null pointers, memory bugs, UB |
| 7. @terminal + /fix | Debugging | Terminal ↔ Chat ↔ Editor workflow |

**Key Takeaways:**
- **Inline suggestions** work best with descriptive comments and meaningful names
- **Ask Mode + /explain** decodes templates, macros, and pointer semantics
- **#codebase** replaces manual grep for navigating large C++ repos
- **/fix** can target embedded-specific issues (ISR safety, static allocation, volatile)
- **@terminal** bridges build output and code fixes

---

## Bonus Challenges (If Time Permits)

### Challenge 1: Template Metaprogramming
```
Explain the SFINAE pattern used in this codebase. Find an example
in the communication/ directory and rewrite it using C++17
if constexpr for readability. #codebase
```

### Challenge 2: Refactor for Safety
```
Find a function in #file:Firmware/MotorControl/motor.cpp that uses
raw pointers. Refactor it to use std::span (C++20) or at minimum
add bounds checking. Explain what safety guarantees the refactored
version provides.
```

### Challenge 3: Memory Map Analysis
```
@terminal Show me how to use arm-none-eabi-size to analyze the
firmware binary. Then explain the output — what is .text, .data,
.bss, and how much RAM/Flash is used vs available on STM32F405?
```

### Challenge 4: Multi-File Bug Hunt
Use Agent Mode:
```
Search the entire Firmware/MotorControl/ directory for variables
that are written in ISR context and read in task context without
proper synchronization (volatile, atomics, or critical sections).
Show each finding with file, line, and a suggested fix.
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Chat view not opening | Verify GitHub Copilot Chat extension is installed |
| Inline chat not appearing | Press `Ctrl+I` with cursor in editor (not terminal) |
| Suggestions not relevant | Add more context with `#file:` references |
| /explain too verbose | Ask "Explain in 3 sentences" or "Focus on the algorithm only" |
| /fix suggests wrong language | Ensure the file has the correct language mode (bottom-right in VS Code) |
| @terminal not finding commands | Ensure a terminal is open; try opening a new one first |
| Build errors not recognized | Paste the exact error text into Chat for best results |

---

## Quick Reference

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open Chat view |
| `Ctrl+I` | Inline chat (in editor) |
| `Ctrl+Shift+Alt+L` | Quick Chat |
| `Tab` | Accept inline suggestion |
| `Escape` | Dismiss suggestion |

### Chat Participants

| Participant | Use For |
|-------------|---------|
| `@terminal` | Shell/build commands |
| `@vscode` | IDE configuration |
| `@github` | Repos, issues, PRs |

### Slash Commands

| Command | Use For |
|---------|---------|
| `/doc` | Generate documentation |
| `/explain` | Explain code |
| `/fix` | Fix errors |
| `/tests` | Generate tests |

---

*Lesson 2 Hands-On Exercises — Copilot Fundamentals & Debugging for C++*  
*Duration: 30 minutes*
# Lesson 2: Hands-On Exercises

**Duration:** 15 minutes  
**Format:** Individual practice  
**Goal:** Practice using GitHub Copilot's three modes, chat participants, and slash commands

---

## Overview

This hands-on session lets you practice using GitHub Copilot's core features. Complete as many exercises as time allows.

| Exercise | Focus | Time |
|----------|-------|------|
| 1. Explore the Codebase | Ask Mode - Understanding unfamiliar code | 3 min |
| 2. Generate Documentation | Edit Mode - Add Doxygen comments | 3 min |
| 3. Fix a Bug | Slash Commands - Use /fix | 3 min |
| 4. Generate Unit Tests | Slash Commands - Use /tests | 3 min |
| 5. Architecture Deep Dive | Chat Participants - @workspace | 3 min |

> 💡 **Tip:** Focus on Exercises 1-3 if short on time. They demonstrate the core interaction patterns.

---

## Try Each Copilot Mode

Before starting the exercises, familiarize yourself with the three modes:

### Ask Mode
- Open Chat view (`Ctrl+Alt+I`)
- Try: "Explain this project in simple, layman's terms. What is the high-level functionality? Provide a tour of the folder structure and explain the key external dependencies."

### Edit Mode
- Open a source file (e.g., `controller.cpp`)
- Select code and press `Ctrl+I`
- Try: "Add a new configuration variable `float soft_stop_rate` to the `ControllerConfig` struct. Then, update the `update()` method in #controller.cpp to use this rate to decelerate the velocity setpoint to zero when the axis state changes to `IDLE`."

### Agent Mode
- In Chat view, switch to Agent mode
- Try: "Implement a 'Stall Detection' feature. Research how other motor controllers detect stalls. Modifications should likely involve #file:motor.cpp to monitor back-EMF vs current. Create a plan, then add the config flag and the detection logic."

> **💡 Tip:** When referencing files in your prompts, type `#file:` followed by the filename (e.g., `#file:motor.cpp`). This tells GitHub Copilot to include that file's content as context.

---

## Try Chat Participants & Slash Commands

### Chat Participants (@-mentions)

- **@workspace:**
  - Try: "@workspace Trace where `ERROR_PHASE_RESISTANCE_OUT_OF_RANGE` is defined in #file:Firmware/odrive-interface.yaml and find all occurrences where it is raised in the C++ firmware files."

- **@terminal:**
  - Try: "@terminal What is the specific `tup` command to build only the firmware for the v3.6 board variant? Explain the flags."

- **@vscode:**
  - Try: "@vscode How do I configure `launch.json` to attach the Cortex-Debug extension to an ST-Link OpenOCD server for this project?"

### Slash Commands (/-commands)

- **Code documentation:**
  1. Select a function in the editor
  2. Press `Ctrl+I` and type: `/doc`

- **Fix code errors:**
  1. Select code with errors
  2. Press `Ctrl+I` and type: `/fix`

- **Generate tests:**
  1. Select a function
  2. Press `Ctrl+I` and type: `/tests`

### Chat Tools (#-mentions)

- **Reference specific files:**
  - In Chat view: "Explain #file:motor.cpp"

- **Search codebase:**
  - In Chat view: "Find all error handling code #codebase"

---

## Exercise 1: Explore the Codebase (3 min)

**Goal:** Use Ask Mode to understand an unfamiliar codebase

<details>
<summary>📋 Instructions</summary>

1. Open Chat view (`Ctrl+Alt+I`)
2. Ask: "Explain this project in simple, layman's terms. What is the high-level functionality?"
3. Follow up: "What are the key external dependencies?"
4. Follow up: "Show me the main entry point and explain the startup sequence"

**Success Criteria:**
- ✅ Understand the project's purpose
- ✅ Know the folder structure
- ✅ Identify key dependencies
</details>

<details>
<summary>💡 Solution</summary>

**Sample prompts that work well:**
```
Explain this project in simple, layman's terms. What is the high-level 
functionality? Provide a tour of the folder structure.
```

```
What are the external dependencies in this project? List them with 
a brief description of what each provides.
```

```
Where is the main entry point? Walk me through the startup sequence 
from power-on to ready state.
```
</details>

---

## Exercise 2: Generate Documentation (3 min)

**Goal:** Use Edit Mode to document a function

<details>
<summary>📋 Instructions</summary>

1. Open a C++ source file (e.g., `motor.cpp`)
2. Find a function without documentation
3. Select the function signature
4. Press `Ctrl+I` and type: `/doc`
5. Review and accept the generated Doxygen comments

**Success Criteria:**
- ✅ Function has `@brief` description
- ✅ Parameters are documented with `@param`
- ✅ Return value documented with `@return`
</details>

<details>
<summary>💡 Solution</summary>

**Alternative approaches:**
```
Add Doxygen-style comments to this function, including @brief, 
@param for each parameter, and @return.
```

You can also be more specific:
```
Document this function for embedded developers. Include:
- Purpose and when to call it
- Parameter ranges and units
- Return value meaning
- Thread-safety notes
- Example usage
```
</details>

---

## Exercise 3: Fix a Bug with /fix (3 min)

**Goal:** Use slash commands to diagnose and fix issues

<details>
<summary>📋 Instructions</summary>

1. Find code with a known issue or warning
2. Select the problematic code
3. Press `Ctrl+I` and type: `/fix`
4. Review the suggested fix
5. Accept or refine the solution

**Success Criteria:**
- ✅ Issue is correctly identified
- ✅ Fix is appropriate and complete
- ✅ Code compiles without warnings
</details>

<details>
<summary>💡 Solution</summary>

**For more context-aware fixes:**
```
/fix This code has a race condition when accessed from ISR context. 
Suggest a thread-safe alternative.
```

**For embedded-specific fixes:**
```
/fix This uses dynamic allocation. Refactor to use static allocation 
appropriate for embedded systems.
```
</details>

---

## Exercise 4: Generate Unit Tests (3 min)

**Goal:** Use /tests to create test coverage

<details>
<summary>📋 Instructions</summary>

1. Open a file with a utility function
2. Select the function you want to test
3. In Chat, type: `/tests`
4. Review the generated test cases
5. Ask for additional edge cases if needed

**Success Criteria:**
- ✅ Tests cover normal cases
- ✅ Tests cover edge cases
- ✅ Tests follow project testing framework
</details>

<details>
<summary>💡 Solution</summary>

**For comprehensive test generation:**
```
/tests Generate doctest unit tests for this function. Include:
- Normal operation with typical inputs
- Edge cases (zero, max values, boundaries)
- Error conditions and invalid inputs
- Performance-sensitive cases if applicable
```

**Follow-up for more tests:**
```
Add tests for thread-safety: what happens if this function is 
called from multiple threads simultaneously?
```
</details>

---

## Exercise 5: Use @workspace for Architecture (3 min)

**Goal:** Understand project architecture using chat participants

<details>
<summary>📋 Instructions</summary>

1. In Chat, ask: `@workspace How does the motor control loop work?`
2. Follow up: `@workspace Show me the relationship between Axis, Motor, and Encoder classes`
3. Ask: `@workspace Where are errors defined and how are they propagated?`

**Success Criteria:**
- ✅ Understand control loop architecture
- ✅ See class relationships
- ✅ Understand error handling patterns
</details>

<details>
<summary>💡 Solution</summary>

**Effective @workspace queries:**
```
@workspace Explain the high-level architecture of Firmware/MotorControl. 
How do the Axis, Motor, and Encoder classes interact during the control loop?
```

```
@workspace Create a Mermaid diagram showing the state machine in axis.cpp
```

```
@workspace What error codes are defined and where are they raised? 
Show me the error propagation pattern.
```
</details>

---

## 📊 Summary: What You've Practiced

| Exercise | Mode/Feature | Key Skill |
|----------|--------------|-----------|
| 1. Explore Codebase | Ask Mode | Understanding unfamiliar code |
| 2. Generate Docs | Edit Mode + /doc | Inline documentation generation |
| 3. Fix Bugs | Edit Mode + /fix | Diagnostic and repair |
| 4. Generate Tests | /tests | Test coverage creation |
| 5. Architecture | @workspace | Project-wide understanding |

**Key Takeaway:** Match the mode to the task - Ask for exploration, Edit for changes, Agent for complex multi-step work.

---

## Bonus Challenges (If Time Permits)

### Challenge 1: Multi-File Refactoring
Use Agent Mode to rename a function across multiple files:
```
Find all usages of the function `delay_us` and rename it to `delay_microseconds`. 
Update all call sites and add documentation explaining the new name.
```

### Challenge 2: Architecture Diagram
Ask Copilot to generate a visual:
```
@workspace Create a Mermaid sequence diagram showing how a position 
command flows from USB input through the control loop to PWM output.
```

### Challenge 3: Error Analysis
Use @workspace to find patterns:
```
@workspace List all error codes in the project and for each one, 
show where it's raised and how it's handled. Are there any that 
are defined but never used?
```

### Challenge 4: Code Review
Use Agent Mode to review code quality:
```
Review #file:motor.cpp for:
- Thread safety issues
- Missing error handling
- Documentation gaps
- Code that doesn't follow embedded best practices

Provide a prioritized list of improvements.
```

---

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| Chat view not opening | Verify GitHub Copilot Chat extension is installed |
| Inline chat not appearing | Press `Ctrl+I` with code selected |
| @workspace not finding files | Ensure workspace is opened as folder (not just file) |
| Suggestions not relevant | Add more context with `#file:` references |
| /doc not generating comments | Select the full function signature |

---

## Quick Reference

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open Chat view |
| `Ctrl+I` | Inline chat (in editor) |
| `Ctrl+Shift+Alt+L` | Quick Chat |
| `Tab` | Accept inline suggestion |
| `Escape` | Dismiss suggestion |

### Chat Participants

| Participant | Use For |
|-------------|---------|
| `@workspace` | Project-wide questions |
| `@terminal` | Shell/build commands |
| `@vscode` | IDE configuration |
| `@github` | Repos, issues, PRs |

### Slash Commands

| Command | Use For |
|---------|---------|
| `/doc` | Generate documentation |
| `/explain` | Explain code |
| `/fix` | Fix errors |
| `/tests` | Generate tests |

---

*Lesson 2 Hands-On Exercises - GitHub Copilot Basic Features*  
*Duration: 15 minutes*
