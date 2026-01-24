# Lesson 3: Hands-On Exercises

**Duration:** 20 minutes  
**Format:** Individual practice  
**Goal:** Practice creating custom instructions, prompt files, agents, and skills

---

## Overview

This hands-on session lets you practice creating and testing GitHub Copilot customizations. Complete as many exercises as time allows.

| Exercise | Focus | Time |
|----------|-------|------|
| 1. Custom Instructions | Create coding standards + test with file references | 5 min |
| 2. Prompt Files | Create reusable prompts + test with `/command` | 5 min |
| 3. Custom Agents | Create specialized persona + test with real code | 5 min |
| 4. Agent Skills | Create skill folder + test auto-discovery | 5 min |

> 💡 **Tip:** Focus on Exercises 1-2 if short on time. They provide the most immediate value.

---

## Exercise 1: Create Custom Instructions (5 min)

### Task: Create a coding standards file

> 💡 **Quick Creation:** Click **gear icon (⚙️)** → **Chat Instructions** → **New Instruction File**

1. Create `.github/copilot-instructions.md` with:

```markdown
# Project Coding Standards

## C++ Standards
- Use C++17 standard
- PascalCase for classes, camelCase for methods
- Trailing underscore for private members (e.g., `value_`)
- Use `kPascalCase` for constants (e.g., `kMaxSpeed`)

## Embedded Constraints
- No dynamic memory allocation (no malloc/new)
- No exceptions (use error codes)
- Use volatile for hardware registers

## Documentation
- Use Doxygen-style comments (@brief, @param, @return)
- Document all public APIs
```

### 🧪 Test It: Try These Prompts

**Test 1: C++ with File Reference**
```
Add a method to enable the NVIC interrupt for a GPIO pin in #file:Firmware/Drivers/STM32/stm32_gpio.cpp

The method should:
- Take priority and sub-priority as parameters
- Use the get_irq_number() helper function
- Follow the existing code patterns
```

✅ **Check:** References panel shows `cpp_coding_standards.instructions.md`

**Test 2: Python with File Reference**
```
Add a function to #file:docs/conf.py that validates all fibre interface files exist before building documentation.

The function should:
- Check each path in fibre_interface_files list
- Log warnings for missing files
- Return True if all files exist, False otherwise
```

✅ **Check:** References panel shows `python_coding_standards.instructions.md`

**Test 3: Header with File Reference**
```
Add a method declaration to #file:Firmware/Drivers/STM32/stm32_gpio.hpp for configuring alternate function mode.

The method should:
- Take the alternate function number (0-15) as parameter
- Return bool for success/failure
- Be consistent with existing config() method
```

✅ **Check:** References panel shows `header_file_rules.instructions.md`

### Success Criteria
- ✅ Instructions file created
- ✅ References panel shows correct instruction files
- ✅ Generated code follows your standards

---

## Exercise 2: Create a Prompt File (5 min)

### Task: Create a reusable documentation prompt

> 💡 **Quick Creation:** Click **gear icon (⚙️)** → **Prompt Files** → **New Prompt File**

1. Create `.github/prompts/add-doxygen.prompt.md`:

```markdown
---
mode: edit
description: Add Doxygen documentation to selected code
---

# Add Doxygen Documentation

Add comprehensive Doxygen documentation to the selected code:

## Required Elements
- `@brief` - One-line summary
- `@param` - For each parameter with [in], [out], or [in,out]
- `@return` - Return value description
- `@note` - Important usage notes

## Style
- Use `/** */` block comments
- Keep `@brief` under 80 characters
- Include units for physical quantities (e.g., "velocity in rad/s")
```

### 🧪 Test It: Use Your Prompt

**Test 1: Add Documentation**
1. Open `Firmware/Drivers/STM32/stm32_gpio.cpp`
2. Select the `config()` function
3. Type in Chat: `/add-doxygen`
4. Verify documentation follows your rules

**Test 2: With File Context**
```
/add-doxygen #file:Firmware/Drivers/STM32/stm32_gpio.cpp
```

### Success Criteria
- ✅ Prompt appears in slash command menu
- ✅ Documentation follows defined format
- ✅ Works with file context

---

## Exercise 3: Create a Custom Agent (5 min)

### Task: Create a code reviewer agent

> 💡 **Quick Creation:** Click **gear icon (⚙️)** → **Custom Agents** → **New Custom Agent**

1. Create `.github/agents/safety-reviewer.agent.md`:

```markdown
---
name: Safety Reviewer
description: Reviews embedded C++ code for safety issues
tools: ['codebase', 'file']
---

# Safety-Critical Code Reviewer

You review embedded code for safety-critical systems.

## Review Checklist

### Memory Safety
- [ ] No buffer overflows
- [ ] No null pointer dereferences
- [ ] No dynamic allocation in ISRs

### Concurrency Safety
- [ ] No race conditions
- [ ] Proper volatile usage
- [ ] ISR-safe data access

### Arithmetic Safety
- [ ] No integer overflow
- [ ] No division by zero

## Output Format

For each issue:
- **Severity:** Critical/High/Medium/Low
- **Location:** file:line
- **Issue:** Description
- **Fix:** Recommended solution
```

### 🧪 Test It: Review Real Code

**Test 1: Select Agent and Review**
1. Select "Safety Reviewer" from agents dropdown
2. Type:
```
Review #file:Firmware/Drivers/STM32/stm32_gpio.cpp for safety issues.

Focus on:
- Interrupt safety
- Race conditions
- Null pointer handling
```

**Test 2: Architecture Analysis**
```
Analyze the design of the GPIO subscription system in #file:Firmware/Drivers/STM32/stm32_gpio.cpp

What patterns are used? Are there any architectural improvements?
```

### Success Criteria
- ✅ Agent appears in dropdown
- ✅ Uses defined checklist
- ✅ Output follows structured format

---

## Exercise 4: Create an Agent Skill (5 min)

### Task: Create a MISRA compliance skill

> 📝 **Note:** Skills are created manually as folder structures (no gear icon).

1. Create folder: `.github/skills/misra-check/`

2. Create `.github/skills/misra-check/SKILL.md`:

```markdown
---
name: MISRA Check
description: Check code for MISRA C++ compliance violations
---

# MISRA C++ Compliance Checker

Check embedded code for MISRA C++ 2008 violations.

## Key Rules

### Required Rules
- **Rule 5-0-3**: No implicit integral conversions
- **Rule 6-4-2**: All if...else chains need final else
- **Rule 0-1-1**: No unreachable code

### Common Violations
```cpp
// ❌ Implicit conversion (Rule 5-0-3)
int32_t a = some_float;

// ✅ Compliant
int32_t a = static_cast<int32_t>(some_float);
```

## Output Format

For each violation:
```
MISRA Violation: Rule X-Y-Z
Location: file.cpp:line
Issue: Description
Fix: Suggested fix
```
```

### 🧪 Test It: Trigger the Skill

**Test: MISRA Check (Skill Auto-Discovery)**
```
Check #file:Firmware/Drivers/STM32/stm32_gpio.cpp for MISRA C++ compliance violations.

Focus on:
- Implicit type conversions
- Missing else clauses
- Pointer safety
```

✅ **Check:** References section shows skill was loaded

### Success Criteria
- ✅ Skill folder created with SKILL.md
- ✅ Skill auto-loads when "MISRA" mentioned
- ✅ Output follows defined format

---

## 📊 Summary: What You've Practiced

| Exercise | What You Created | How You Tested |
|----------|-----------------|----------------|
| 1. Instructions | Coding standards file | `#file:` prompts, checked References |
| 2. Prompt Files | Reusable task template | `/prompt-name` with file context |
| 3. Custom Agents | Specialized persona | Agent + `#file:` for review |
| 4. Agent Skills | Bundled resources | Keyword triggers skill loading |

**Key Takeaway:** Always use `#file:` references and check the **References panel** to verify your customizations are being applied!

---

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| Instructions not loading | Check `useInstructionFiles` setting is enabled |
| Prompt not in menu | Verify file is in `.github/prompts/` with `.prompt.md` extension |
| Agent not in dropdown | Check file is in `.github/agents/` with `.agent.md` extension |
| Skill not auto-loading | Enable `chat.useAgentSkills` setting |
| Wrong instruction file | Check `applyTo` glob pattern matches file type |

---

## Bonus Challenges (If Time Permits)

### Challenge 1: Prompt with Variables
Create a prompt that accepts user input:
```markdown
---
description: Generate tests for ${input:framework} framework
---
Generate tests using **${input:framework}**.
```

### Challenge 2: Agent with Handoffs
Add a handoff button to your agent:
```yaml
handoffs:
  - label: "Fix Issues"
    agent: edit
    prompt: "Fix the issues identified above"
```

### Challenge 3: Multi-File Instructions
Create different instructions for different folders:
```yaml
applyTo: "Firmware/**/*.cpp"  # Firmware-specific
applyTo: "tools/**/*.py"      # Tools-specific
```

---

*Lesson 3 Hands-On Exercises - GitHub Copilot Customization*  
*Duration: 20 minutes*
