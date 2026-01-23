# Section 3 Demo Script: Planning & Steering Documents

**Duration:** 60 minutes total (demos ~45 min, hands-on ~15 min)  
**Presenter Notes:** This script provides exact steps and dialogue for live demos

---

## Demo 1: Why Planning Matters - Before & After (5 min)

### Setup
- Open VS Code with ODrive workspace
- Clear any existing `.github/copilot-instructions.md` (or rename it temporarily)
- Open Copilot Chat panel

### Demo Flow

---

### Part A: Without Custom Instructions (2 min)

**Presenter Says:**
> "Let's see what happens when we generate code WITHOUT any custom instructions. This is how most people start with Copilot."

**Type in Chat:**
```
Create a function to read temperature from an ADC sensor and return the value in Celsius
```

**Wait for response, then critique:**

**Presenter Says:**
> "Look at what we got:
> - Generic variable names (`temp`, `value`)
> - No error handling
> - Uses `new`/`malloc` - not embedded-safe!
> - No documentation
> - Doesn't follow our coding standards
> - Might use exceptions
>
> This code would fail code review. Let me show you how planning fixes this."

---

### Part B: With Custom Instructions (3 min)

**Presenter Says:**
> "Now let's add our custom instructions file and try the same prompt."

**Create file:** `.github/copilot-instructions.md`

**Type this content (or show pre-prepared):**

```markdown
# ODrive Coding Standards

## C++ Requirements
- Use C++17 features
- No dynamic memory allocation (no new/malloc)
- No exceptions - use error codes
- All functions must have Doxygen documentation
- Use snake_case for functions, PascalCase for classes
- Prefix member variables with underscore: _member

## Embedded Constraints
- Static allocation only
- MISRA C++ compliance preferred
- Consider interrupt safety for motor control code
- Use fixed-point math where possible for performance

## Project Patterns
- Error handling: return bool or error enum, not exceptions
- Logging: use ODRIVE_LOG() macro
- Configuration: store in Config structs
```

**Save the file**

**Presenter Says:**
> "I've created `.github/copilot-instructions.md`. Copilot automatically loads this for every request. Let's try the same prompt again."

**Start a new chat session (Ctrl+N)**

**Type the same prompt:**
```
Create a function to read temperature from an ADC sensor and return the value in Celsius
```

**Presenter Says:**
> "Look at the difference now:
> - ✅ Proper naming conventions
> - ✅ No dynamic allocation
> - ✅ Error handling with return codes
> - ✅ Doxygen documentation
> - ✅ Embedded-safe patterns
>
> Same prompt, dramatically better output! The instructions are applied automatically to EVERY request."

---

## Demo 2: Custom Instructions Deep Dive (8 min)

### Setup
- Keep the instructions file open
- Have Chat panel visible

### Demo Flow

---

### Part A: Global vs Conditional Instructions (4 min)

**Presenter Says:**
> "There are two types of instruction files. Let me show you."

**Show folder structure:**
```
.github/
├── copilot-instructions.md          # Global - always loaded
└── instructions/
    ├── cpp.instructions.md          # Loaded for *.cpp, *.hpp
    └── python.instructions.md       # Loaded for *.py
```

**Create file:** `.github/instructions/cpp.instructions.md`

```markdown
---
applyTo: "**/*.cpp,**/*.hpp,**/*.h"
---

# C++ Specific Instructions

When generating C++ code:
- Use `#pragma once` instead of include guards
- Prefer `constexpr` over `#define` for constants
- Use `std::array` instead of C-style arrays
- Mark single-argument constructors `explicit`
- Use `[[nodiscard]]` for functions returning important values
```

**Presenter Says:**
> "See the `applyTo` frontmatter? This instruction file only loads when you're working with C++ files. The glob pattern controls when it activates."

**Create file:** `.github/instructions/python.instructions.md`

```markdown
---
applyTo: "**/*.py"
---

# Python Specific Instructions

When generating Python code:
- Follow PEP 8 style guidelines
- Use type hints for all function parameters and returns
- Prefer f-strings over .format() or % formatting
- Use pathlib for file path operations
- Add docstrings to all public functions
```

**Presenter Says:**
> "Now C++ files get C++ rules, Python files get Python rules. The global instructions apply everywhere, conditional instructions layer on top."

---

### Part B: Instruction Best Practices (4 min)

**Presenter Says:**
> "Let me show you what makes good vs bad instructions."

**Show BAD example:**
```markdown
# Bad Instructions ❌

Write good code.
Follow best practices.
Use proper naming.
```

**Presenter Says:**
> "This is too vague. Copilot can't act on 'good' or 'proper'. Let me show you better patterns."

**Show GOOD example:**
```markdown
# Good Instructions ✅

## Naming Conventions
- Functions: snake_case (e.g., `read_sensor_value`)
- Classes: PascalCase (e.g., `MotorController`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `MAX_CURRENT`)
- Member variables: prefix with underscore (e.g., `_velocity`)

## Error Handling Pattern
```cpp
// Return error code, not exceptions
ErrorCode do_something() {
    if (failed) return ErrorCode::INVALID_STATE;
    return ErrorCode::OK;
}
```

## Required Documentation
Every public function must have:
- @brief one-line description
- @param for each parameter
- @return description of return value
- @note for important caveats
```

**Presenter Says:**
> "Good instructions are:
> - **Specific** - exact patterns, not vague guidance
> - **Actionable** - Copilot can directly apply them
> - **Include examples** - show, don't just tell
> - **Organized** - grouped by topic for clarity"

---

## Demo 3: Prompt Files (.prompt.md) (8 min)

### Setup
- Create `.github/prompts/` directory
- Have Chat panel visible

### Demo Flow

---

### Part A: Create a Reusable Prompt (4 min)

**Presenter Says:**
> "Instructions are always-on. Prompt files are reusable templates you invoke when needed."

**Create file:** `.github/prompts/add-doxygen.prompt.md`

```markdown
---
mode: edit
description: Add Doxygen documentation to selected code
---

# Add Doxygen Documentation

Add comprehensive Doxygen documentation to the selected code following these rules:

## Required Elements
- `@brief` - One-line summary
- `@param` - For each parameter with [in], [out], or [in,out]
- `@return` - Return value description
- `@throws` - Any exceptions (if applicable)
- `@note` - Important usage notes
- `@warning` - Safety-critical information
- `@see` - Related functions

## Style
- Use `/** */` block comments
- Keep `@brief` under 80 characters
- Add blank line between sections
- Include units for physical quantities (e.g., "velocity in rad/s")

## Example Format
```cpp
/**
 * @brief Calculate motor phase currents using Clarke transform.
 * 
 * @param[in] i_a Phase A current in Amperes
 * @param[in] i_b Phase B current in Amperes
 * @param[out] i_alpha Alpha component of current
 * @param[out] i_beta Beta component of current
 * 
 * @return true if calculation succeeded
 * 
 * @note Assumes balanced three-phase system
 * @see inverse_clarke_transform()
 */
```

Apply this documentation style to the selected code.
```

**Presenter Says:**
> "Now I can use this prompt anytime with a slash command."

---

### Part B: Use the Prompt (2 min)

**Open a file with an undocumented function**

**Select the function**

**In Chat, type:**
```
/add-doxygen
```

**Presenter Says:**
> "See how it appears in the slash command menu? The prompt file becomes a reusable command. Let's see the output."

**Show the generated documentation:**

> "It followed all our rules:
> - Correct format
> - All required elements
> - Project-specific style
>
> One prompt file, consistent documentation across the team!"

---

### Part C: Prompt with Variables (2 min)

**Create file:** `.github/prompts/generate-test.prompt.md`

```markdown
---
mode: edit
description: Generate unit tests for selected code
---

# Generate Unit Tests

Generate unit tests for the selected code using the **${input:framework}** testing framework.

## Test Requirements
- Test happy path with normal inputs
- Test edge cases (zero, max, min values)
- Test error conditions
- Use descriptive test names: `test_<function>_<scenario>_<expected>`

## Framework-Specific Patterns

### If doctest:
```cpp
TEST_CASE("function_name") {
    SUBCASE("happy path") { ... }
    SUBCASE("edge case") { ... }
}
```

### If gtest:
```cpp
TEST(TestSuite, FunctionName_Scenario_Expected) {
    EXPECT_EQ(expected, actual);
}
```

Generate comprehensive tests for the selected code.
```

**Presenter Says:**
> "See `${input:framework}`? This creates an input variable. When I use the prompt, Copilot asks for the value."

**Demo:**
```
/generate-test
```

**Type in the input box:** `doctest`

**Presenter Says:**
> "The prompt adapts based on my input. This single prompt handles multiple testing frameworks!"

---

## Demo 4: Custom Agents (.agent.md) (10 min)

### Setup
- Create `.github/agents/` directory
- Have Chat panel visible

### Demo Flow

---

### Part A: Create a Specialized Agent (5 min)

**Presenter Says:**
> "Custom agents are specialized personas with specific expertise and tools. Let me create one."

**Create file:** `.github/agents/firmware-reviewer.agent.md`

```markdown
---
name: Firmware Reviewer
description: Reviews embedded C++ code for quality, safety, and best practices
tools: ['codebase', 'file', 'terminal']
---

# Firmware Code Reviewer

You are an expert embedded systems engineer specializing in code review for motor control firmware. You focus on safety-critical code quality.

## Your Expertise
- MISRA C++ compliance
- Real-time systems constraints
- Memory safety (no dynamic allocation)
- Interrupt-safe programming
- Motor control algorithms (FOC, sensorless, etc.)

## Review Checklist

When reviewing code, always check:

### Safety
- [ ] No dynamic memory allocation
- [ ] No exceptions in interrupt context
- [ ] Proper volatile usage for hardware registers
- [ ] Correct interrupt enable/disable patterns
- [ ] No race conditions in shared data

### Quality
- [ ] Functions under 50 lines
- [ ] Cyclomatic complexity under 10
- [ ] Proper const correctness
- [ ] Meaningful variable names
- [ ] Complete documentation

### Performance
- [ ] No unnecessary copies
- [ ] Appropriate use of inline
- [ ] Consider cache effects
- [ ] Minimize ISR execution time

## Output Format

For each issue found:
1. **Severity**: Critical / Major / Minor
2. **Location**: File and line
3. **Issue**: Description
4. **Fix**: Suggested solution
5. **Why**: Explanation of the risk

Always end with a summary: issues found, risk assessment, and approval recommendation.
```

**Presenter Says:**
> "This agent has:
> - A specific **persona** (firmware reviewer)
> - Defined **expertise** areas
> - A **checklist** to follow
> - An **output format** to use
>
> Let's try it!"

---

### Part B: Use the Agent (3 min)

**Open a code file**

**In Chat, select the agent dropdown → Choose "Firmware Reviewer"**

**Or type:**
```
@firmware-reviewer Review this file for safety and quality issues: #file:Firmware/MotorControl/motor.cpp
```

**Presenter Says:**
> "Watch how the agent:
> - Follows its checklist
> - Uses its expertise
> - Formats output consistently
>
> Every team member gets the same thorough review!"

**Show the structured output:**

> "Notice the consistent format:
> - Severity ratings
> - Specific locations
> - Actionable fixes
> - Risk explanations
>
> This is far more useful than generic feedback!"

---

### Part C: Agent with Tool Access (2 min)

**Presenter Says:**
> "Notice the `tools` in the frontmatter? This controls what the agent can access."

**Show the frontmatter:**
```yaml
---
tools: ['codebase', 'file', 'terminal']
---
```

**Presenter Says:**
> "This agent can:
> - `codebase` - Search the entire workspace
> - `file` - Read specific files
> - `terminal` - Run commands
>
> You can restrict agents to only the tools they need. A documentation agent might only need `file`, while a build agent needs `terminal`."

---

## Demo 5: Agent Skills (SKILL.md) (8 min)

### Setup
- Create `.github/skills/` directory
- Have sample skill folder ready

### Demo Flow

---

### Part A: Skill Structure (3 min)

**Presenter Says:**
> "Skills are the most powerful customization. They bundle instructions with resources - scripts, templates, references."

**Show folder structure:**
```
.github/skills/
└── misra-compliance/
    ├── SKILL.md              # Main skill definition
    ├── rules/
    │   └── misra-rules.md    # Reference material
    ├── examples/
    │   └── compliant-code.cpp
    └── scripts/
        └── check-misra.py
```

**Presenter Says:**
> "A skill is a folder with:
> - `SKILL.md` - The main instructions
> - `references/` - Documentation the AI can read
> - `templates/` - Code patterns to follow
> - `scripts/` - Tools the AI can run"

---

### Part B: Create a Skill (3 min)

**Create folder:** `.github/skills/misra-compliance/`

**Create file:** `.github/skills/misra-compliance/SKILL.md`

```markdown
---
name: MISRA Compliance
description: Check and fix MISRA C++ violations in embedded code
---

# MISRA C++ Compliance Skill

This skill helps ensure code follows MISRA C++ 2008/2023 guidelines for safety-critical embedded systems.

## Capabilities

1. **Analyze** - Identify MISRA violations in code
2. **Fix** - Suggest compliant alternatives
3. **Explain** - Describe why rules exist

## Key MISRA Rules Reference

### Required Rules (Must Fix)
- **Rule 0-1-1**: No unreachable code
- **Rule 5-0-3**: No implicit integral conversions
- **Rule 6-4-2**: All if...else chains need final else
- **Rule 7-5-4**: Functions must have single exit point

### Advisory Rules (Should Fix)
- **Rule 3-9-2**: Use typedefs for all basic types
- **Rule 5-0-9**: Avoid explicit casts when possible

## When to Apply

Use this skill when:
- Reviewing safety-critical code
- Preparing for certification (ISO 26262, IEC 61508)
- Analyzing motor control or power electronics code

## Output Format

For each violation:
```
MISRA Violation: Rule X-Y-Z (Required/Advisory)
Location: file.cpp:line
Issue: Description
Fix: Suggested compliant code
```
```

**Create reference file:** `.github/skills/misra-compliance/rules/quick-reference.md`

```markdown
# MISRA C++ Quick Reference

## Most Common Violations in Embedded Code

### 1. Implicit Conversions (Rule 5-0-3)
```cpp
// ❌ Violation
int32_t a = some_float;

// ✅ Compliant
int32_t a = static_cast<int32_t>(some_float);
```

### 2. Missing Final Else (Rule 6-4-2)
```cpp
// ❌ Violation
if (x > 0) { ... }
else if (x < 0) { ... }

// ✅ Compliant
if (x > 0) { ... }
else if (x < 0) { ... }
else { /* x == 0 */ }
```
```

---

### Part C: Use the Skill (2 min)

**Presenter Says:**
> "Skills are auto-discovered based on your prompt. Watch this."

**Type in Chat:**
```
Check this code for MISRA compliance violations:
#file:Firmware/MotorControl/foc.cpp
```

**Presenter Says:**
> "Notice I didn't explicitly call the skill. Copilot matched my request to the skill description and loaded it automatically. The skill's rules, examples, and references are all available to the AI."

**Show the output:**

> "The response follows the skill's output format and references the actual MISRA rules. This is institutional knowledge packaged for AI consumption!"

---

## Demo 6: Plan Mode (8 min)

### Setup
- Open Copilot Chat on GitHub.com (Plan Mode works best there)
- Or use VS Code with latest Copilot

### Demo Flow

---

### Part A: Create Project Plan (4 min)

**Presenter Says:**
> "Plan Mode turns your ideas into structured GitHub Issues. Perfect for project kickoffs and complex features."

**Type in Chat:**
```
I'm planning to add CAN-FD support to the ODrive firmware. The feature should:
- Support higher data rates (up to 8 Mbps)
- Maintain backwards compatibility with CAN 2.0
- Include timestamp support for messages
- Update Python tools to parse CAN-FD frames

Please create a structured project plan with epics, features, and tasks.
```

**Presenter Says:**
> "Watch how Copilot generates a full project structure."

**Wait for response:**

> "It created:
> - **Epic**: CAN-FD Support
> - **Features**: Hardware config, Protocol handling, Tool updates
> - **Tasks**: Specific implementation items
>
> Each with descriptions and acceptance criteria!"

---

### Part B: Refine the Plan (2 min)

**Presenter Says:**
> "The first draft is rarely perfect. Let's refine it."

**Type in Chat:**
```
Can you break down the "Feature: Hardware Configuration" into smaller tasks? 
Include STM32 FDCAN peripheral setup, timing configuration, and interrupt handling.
```

**Show refined output:**

> "Now we have actionable tasks:
> - Task: Configure FDCAN clock source
> - Task: Set bit timing parameters
> - Task: Implement TX/RX interrupt handlers
>
> Each task is small enough to assign to a developer."

---

### Part C: Improve Descriptions (2 min)

**Type in Chat:**
```
Improve the description for "Task: Configure FDCAN clock source" with:
- Technical details for STM32H7
- Code snippets for initialization
- Acceptance criteria
- Links to reference documentation
```

**Presenter Says:**
> "Now the task has everything a developer needs to get started. You can iterate like this for each task, then create the issues in your repo with one click."

**Show the Plan Mode workflow diagram:**
```
Idea → Plan Mode → Refine → Create Issues → Agent Mode → Implementation
```

> "Plan Mode creates the structure, Agent Mode executes the tasks. They work together!"

---

## Hands-On Exercises (15 min)

**Presenter Says:**
> "Your turn! Create your own customization files."

### Exercise 1: Create Custom Instructions (5 min)

**Task:**
Create `.github/copilot-instructions.md` with:
- Your team's naming conventions
- Memory/performance constraints
- Documentation requirements
- Error handling patterns

**Test it:**
Ask Copilot to generate code and verify it follows your rules.

### Exercise 2: Create a Prompt File (5 min)

**Task:**
Create `.github/prompts/code-review.prompt.md` that:
- Defines review criteria
- Has an output format (✅/❌ checklist)
- Includes severity ratings

**Test it:**
Use `/code-review` on a file.

### Exercise 3: Create an Agent (5 min)

**Task:**
Create `.github/agents/my-expert.agent.md` for your domain:
- Define the persona
- List expertise areas
- Add a checklist
- Specify output format

**Test it:**
Select your agent and ask a domain question.

---

## Demo Tips for Presenters

### Before the Demo
- [ ] Clear/rename existing `.github/` customizations
- [ ] Have template files ready to copy
- [ ] Test that skills auto-discovery works
- [ ] Verify Plan Mode is accessible

### During the Demo
- **Show the file structure** - People need to see where files go
- **Highlight the YAML frontmatter** - Often overlooked
- **Compare before/after** - The difference is dramatic
- **Encourage questions** - "What standards does your team use?"

### Common Issues & Recovery
- **Instructions not loading:** Check file path and YAML syntax
- **Agent not appearing:** Restart VS Code or refresh agents list
- **Skill not discovered:** Ensure SKILL.md exists and description matches

### Time Management
- Demo 1 (Why Planning): 5 min
- Demo 2 (Instructions): 8 min
- Demo 3 (Prompts): 8 min
- Demo 4 (Agents): 10 min
- Demo 5 (Skills): 8 min
- Demo 6 (Plan Mode): 8 min
- Hands-On: 15 min (adjust as needed)

---

## Audience Engagement

### Questions to Ask

**After Demo 1:**
> "Who has been frustrated by inconsistent AI output? [hands]
> Custom instructions fix that - same rules, every time!"

**After Demo 3:**
> "What repetitive prompts do you use frequently? [discuss]
> Those are perfect candidates for prompt files!"

**After Demo 4:**
> "What specialized roles exist on your team? [discuss]
> Reviewers, architects, security experts - each could be an agent!"

### Expected Questions

**Q: "Do instruction files slow down Copilot?"**
A: "No noticeable impact. They're loaded with your prompt and add minimal overhead."

**Q: "Can I share instructions across repos?"**
A: "Yes! You can create a shared repo of instructions and reference them. Skills can also be installed globally in `~/.copilot/skills/`."

**Q: "What's the priority when multiple instructions conflict?"**
A: "File-specific instructions (via `applyTo`) take precedence over global. More specific patterns win."

**Q: "Can I disable instructions temporarily?"**
A: "Rename the file or move it out of `.github/`. There's no toggle yet."

**Q: "How do skills differ from agents?"**
A: "Agents are personas you select. Skills are auto-discovered based on your prompt. Agents can invoke skills, but you invoke agents directly."

---

## File Location Quick Reference

| Type | Location | When Loaded |
|------|----------|-------------|
| Global Instructions | `.github/copilot-instructions.md` | Always |
| Conditional Instructions | `.github/instructions/*.instructions.md` | When `applyTo` matches |
| Prompt Files | `.github/prompts/*.prompt.md` | When you type `/name` |
| Agents | `.github/agents/*.agent.md` | When you select from dropdown |
| Skills | `.github/skills/*/SKILL.md` | Auto-discovered by prompt |

---

**Demo Script Version:** 1.0  
**Last Updated:** January 2026
