# ODrive Prompts Library

Reusable workflow prompts for common ODrive development tasks. Each prompt is designed to work with the agentic system, invoking appropriate skills to gather data and execute tasks.

---

## 📋 Available Prompts

### Build & Test

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[build-firmware](build-firmware.prompt.md)** | Build ODrive firmware for specific board variants | odrive-qa-assistant | ✅ |
| **[generate-doctest](generate-doctest.prompt.md)** | Generate unit tests using doctest framework | odrive-qa-assistant, ODrive-Engineer | ⚠️ |

### Code Quality

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[refactor-modern-cpp-v2](refactor-modern-cpp-v2.prompt.md)** | Refactor code to modern C++17 standards | ODrive-Engineer, odrive-qa-assistant | ✅ |
| **[add-doxygen](add-doxygen.prompt.md)** | Add Doxygen documentation to code | ODrive-Engineer | ⚠️ |
| **[audit-todos](audit-todos.prompt.md)** | Audit and prioritize TODO comments | ODrive-Engineer | ⚠️ |
| **[check-safety](check-safety.prompt.md)** | Validate safety-critical code | ODrive-Engineer | ⚠️ |

### Debugging & Analysis

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[debug-motor-error-v2](debug-motor-error-v2.prompt.md)** | Analyze and debug motor errors | odrive-qa-assistant, ODrive-Engineer | ✅ |
| **[explain-foc](explain-foc.prompt.md)** | Explain FOC algorithm concepts | ODrive-Engineer | ⚠️ |

### Motor Control

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[tune-motor-controller](tune-motor-controller.prompt.md)** | Analyze and tune motor control parameters | foc-tuning (🚧), ODrive-Engineer | ✅ |

### Performance

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[optimize-critical](optimize-critical.prompt.md)** | Optimize performance-critical code | ODrive-Engineer, odrive-qa-assistant | ⚠️ |

### Documentation

| Prompt | Description | Skills Used | Status |
|--------|-------------|-------------|--------|
| **[doc-arduino-interface](doc-arduino-interface.prompt.md)** | Document Arduino interface | ODrive-Engineer | ⚠️ |

**Legend:**
- ✅ Enhanced with skill integration
- ⚠️ Needs enhancement to use skills
- 🚧 Requires planned skill implementation

---

## 🎯 How to Use Prompts

### Basic Usage

1. **Identify your need** from the table above
2. **Open the prompt file** to see detailed instructions
3. **Invoke the appropriate agent** with your request

### Example: Build Firmware

```bash
# Using the build-firmware prompt
@odrive-qa Build firmware for board v3.6
```

Behind the scenes:
```
User Request → ODrive-QA agent → odrive-qa-assistant skill → Executes build commands
```

### Example: Debug Motor Error

```bash
# Using the debug-motor-error-v2 prompt
@odrive-engineer Debug ERROR_CONTROL_DEADLINE_MISSED - what causes this?
```

Behind the scenes:
```
User Request → ODrive-Engineer agent → odrive-qa-assistant skill (symbol search) → Analysis
```

---

## 📝 Prompt Structure

Each enhanced prompt follows this structure:

```markdown
# [Prompt Title]

[Brief description]

## Instructions
Use the **[skill/agent]** to [action]

### Input Required
- **Parameter**: Description

### What This Prompt Does
1. Step 1
2. Step 2
...

### Commands
```bash
# Actual commands that will be executed
```

### Example Usage
Example invocations

### Skills Invoked
Table of skills used

### Related Prompts
Links to related prompts
```

---

## 🔧 Skills Integration

Prompts are designed to work with these skills:

| Skill | Purpose | Files |
|-------|---------|-------|
| **odrive-qa-assistant** | Build, test, search | `.github/skills/odrive-qa-assistant/` |
| **devops-engineer** | CI/CD, releases | `.github/skills/devops-engineer/` |
| **foc-tuning** 🚧 | Motor control tuning | `.github/skills/foc-tuning/` |
| **control-algorithms** 🚧 | Control patterns | `.github/skills/control-algorithms/` |

---

## 🛠️ Skill Script Examples

Skills contain executable scripts that prompts can invoke:

### odrive-qa-assistant Scripts

```bash
# Build firmware
python .github/skills/odrive-qa-assistant/scripts/build_firmware.py board-v3.6-56V

# Search symbols
python .github/skills/odrive-qa-assistant/scripts/search_symbol.py Motor::update

# List errors
python .github/skills/odrive-qa-assistant/scripts/list_errors.py
```

### Benefits
- **Consistent**: Same commands across prompts
- **Tested**: Scripts are validated and reliable
- **Safe**: Read-only operations by default
- **Reusable**: One script, many prompts

---

## 🚀 Creating New Prompts

### Template

Use this template for new prompts:

```markdown
# [Prompt Name]

[Description]

## Instructions

Use the **[agent/skill]** to [action]

### Input Required
- **Variable**: ${{VARIABLE_NAME}}

### What This Prompt Does
1. [Step]
2. [Step]

### Commands
```bash
# Commands
```

### Example Usage
Examples

### Skills Invoked
| Skill | Purpose |
|-------|---------|
| name | purpose |

### Related Prompts
- Link
```

### Best Practices

1. **Specify skills** - Which skill handles what
2. **Show commands** - Actual commands that execute
3. **Include examples** - Real usage scenarios
4. **Link related** - Connect to other prompts
5. **Safety first** - Note hardware operations

---

## 📊 Prompt Enhancement Status

| Category | Total | Enhanced | Needs Work |
|----------|-------|----------|------------|
| Build & Test | 2 | 1 | 1 |
| Code Quality | 4 | 1 | 3 |
| Debugging | 2 | 1 | 1 |
| Motor Control | 1 | 1 | 0 |
| Performance | 1 | 0 | 1 |
| Documentation | 1 | 0 | 1 |
| **TOTAL** | **11** | **4** | **7** |

---

## 🔗 Related Documentation

- **Constitution**: `.github/copilot-instructions.md`
- **Agents**: `.github/agents/`
- **Skills**: `.github/skills/`
- **Quick Reference**: `.github/QUICK_REFERENCE.md`

---

**Note:** As skills are implemented, prompts will be enhanced to leverage new capabilities automatically.
