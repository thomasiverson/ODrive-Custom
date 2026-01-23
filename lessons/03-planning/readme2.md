# Lesson 3: Planning & Steering Documents - GitHub Copilot Customization

**Session Duration:** 60 minutes  
**Audience:** Embedded/C++ Developers/Project Managers/QA Engineers/Firmware Engineers  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Overview

This lesson teaches you how to customize GitHub Copilot's behavior through planning and steering documents. You'll learn to create persistent coding standards, reusable prompts, specialized agents, and skill folders that ensure consistent, high-quality AI output across your team.

**What You'll Learn:**
- Creating `copilot-instructions.md` for repo-wide coding standards
- Building reusable prompt files (`.prompt.md`) for common workflows
- Designing custom agents (`.agent.md`) for specialized personas
- Packaging skills with bundled resources for complex tasks

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **Custom Instructions** | Always-on coding standards applied to every request |
| **Prompt Files** | Reusable task templates invoked with `/prompt-name` |
| **Custom Agents** | Specialized personas with specific tools and behaviors |
| **Agent Skills** | Instruction folders with bundled scripts and resources |
| **Context Layering** | Building prompts with constitution → agent → files → constraints |

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Why Planning Matters](#why-planning-matters)
- [Learning Path](#learning-path)
- [Copilot Customization Hierarchy](#1-copilot-customization-hierarchy)
- [Custom Instructions](#2-custom-instructions-copilot-instructionsmd)
- [Prompt Files](#3-prompt-files-promptmd)
- [Custom Agents](#4-custom-agents-agentmd)
- [Agent Skills](#5-agent-skills-skillmd-folders)
- [Guided Hands-On: Create Steering Docs](#6-guided-hands-on-create-steering-docs)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference-customization-options)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **Completed Basic Feature Overview** - Understanding of Chat modes, participants, and slash commands
- ✅ **Visual Studio Code** with GitHub Copilot extensions installed and enabled
- ✅ **Active Copilot subscription** with access to all features
- ✅ **Workspace access** - Ability to create folders and files in `.github/` directory
- ✅ **Basic Markdown knowledge** - For authoring customization files

### Verify Your Setup

1. **Check workspace permissions:**
   - Ensure you can create folders in your workspace
   - Verify `.github/` directory exists or can be created

2. **Enable customization features:**
   - Open VS Code Settings (Ctrl+,)
   - Make sure custom instructions is enabled
   - Search for `chat.useAgentSkills` and enable it

3. **Test basic functionality:**
   - Open Chat view (Ctrl+Alt+I)
   - Verify agents dropdown is accessible
   - Confirm you can create new files in workspace

---

## Why Planning Matters

Front-loading context improves output quality dramatically. Instead of repeatedly providing the same context in every prompt, planning documents enable consistent, high-quality AI output.

### Benefits of Planning Documents

1. **Consistency Across Sessions**
   - Define coding standards once, apply everywhere
   - Ensure all team members get the same AI behavior
   - Maintain consistent code quality

2. **Reduced Repetition**
   - Stop copy-pasting the same instructions
   - Eliminate redundant context in prompts
   - Save time on every interaction

3. **Improved AI Output Quality**
   - More accurate code generation
   - Better adherence to project standards
   - Context-aware suggestions

4. **Team Collaboration**
   - Share best practices across the team
   - Version control for AI instructions
   - Onboard new developers faster

5. **Specialized Capabilities**
   - Create domain-specific agents
   - Build reusable workflows
   - Extend AI capabilities with custom tools

---

## Learning Path

This lesson covers six key areas. Work through them sequentially for the best learning experience.

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Customization Hierarchy | Where files go and when they're loaded | 5 min |
| Custom Instructions | Repo-level coding standards | 10 min |
| Prompt Files | Reusable task templates | 10 min |
| Custom Agents | Specialized personas | 12 min |
| Agent Skills | Bundled instructions with resources | 10 min |
| Guided Hands-On | Build a complete customization setup | 13 min |

---

## 1. Copilot Customization Hierarchy

### File Locations and Loading Behavior

| Customization | Location | When Loaded | Purpose |
|---------------|----------|-------------|---------|
| **Instructions** | `.github/copilot-instructions.md` | Always (every request) | Global coding standards |
| **Conditional Instructions** | `.github/instructions/*.instructions.md` | Via glob patterns | File-type specific rules |
| **Prompt Files** | `.github/prompts/*.prompt.md` | When invoked with `/prompt-name` | Reusable task templates |
| **Custom Agents** | `.github/agents/*.agent.md` | When selected from dropdown | Specialized personas |
| **Agent Skills** | `.github/skills/*/SKILL.md` | Auto-discovered from prompt | Task workflows with resources |

### Visual Hierarchy

```
.github/
├── copilot-instructions.md          # Always loaded
├── instructions/
│   ├── cpp.instructions.md          # Loaded for *.cpp, *.hpp files
│   └── python.instructions.md       # Loaded for *.py files
├── prompts/
│   ├── generate-test.prompt.md      # Invoked with /generate-test
│   └── review-code.prompt.md        # Invoked with /review-code
├── agents/
│   ├── ODrive-Engineer.agent.md     # Selected from dropdown
│   └── ODrive-QA.agent.md           # Selected from dropdown
└── skills/
    └── misra-compliance/
        ├── SKILL.md                 # Skill definition
        ├── rules.md                 # Reference material
        └── examples/                # Example code
```

---

## 2. Custom Instructions (copilot-instructions.md)

### Global Instructions File
**Location:** `.github/copilot-instructions.md`

Custom instructions define common guidelines that automatically influence how AI generates code and handles development tasks.

**Example for Embedded C++ Project:**

```markdown
# Project Coding Standards

## C++ Standards
- Use C++17 standard
- Follow Google C++ Style Guide
- Use smart pointers (std::unique_ptr, std::shared_ptr)
- Avoid raw pointers except for non-owning references

## Embedded Constraints
- No dynamic memory allocation (no malloc/new)
- No exceptions (use error codes)
- Static allocation only
- Use volatile for hardware registers

## Documentation
- Use Doxygen-style comments
- Document all public APIs
- Include @brief, @param, @return tags

## Testing
- Use doctest framework
- Write unit tests for all functions
- Aim for 80% code coverage
```

### Conditional Instructions Files
**Location:** `.github/instructions/*.instructions.md`

Apply to specific file types using glob patterns:

```markdown
---
applyTo: "Firmware/**/*.{c,h,cpp,hpp}"
description: Embedded C/C++ coding standards
---

# Embedded C/C++ Standards
- No dynamic memory allocation
- Use static allocation only
- Document interrupt handlers
- Use volatile for hardware registers
- Follow MISRA C guidelines where applicable
```

---

## 3. Prompt Files (.prompt.md)

### Prompt File Structure

Prompt files define reusable prompts for common development tasks:

```markdown
---
description: Brief description of what this prompt does
name: prompt-name
argument-hint: Optional hint text for users
agent: ask|edit|agent|custom-agent-name
model: Claude Sonnet 4
tools: ['search', 'fetch', 'githubRepo']
---

# Prompt Instructions

Your detailed instructions go here...

Use variables:
- ${workspaceFolder}
- ${file}
- ${selection}
- ${input:variableName}
- ${input:variableName:placeholder text}
```

### Example: State Machine Generator

```markdown
---
description: Generate embedded state machine with task chain pattern
name: generate-state-machine
argument-hint: StateMachineName
agent: agent
tools: ['edit_files', 'create_file', 'codebase']
---

# Generate State Machine

Create a state machine following ODrive's task chain pattern.

## Requirements
- State machine name: ${input:name:StateMachineName}
- Use enum class for states
- Implement FreeRTOS task with osDelay
- Add entry/exit actions for each state
- Include error state with recovery path
- Static allocation only, no exceptions

## Reference Pattern
See #file:src-ODrive/Firmware/MotorControl/axis.cpp for the task chain pattern.

## Output Files
- ${input:name}_controller.hpp (class definition)
- ${input:name}_controller.cpp (implementation)
```

### Using Prompt Files

1. Type `/generate-state-machine` in Chat view
2. Provide the state machine name when prompted
3. Copilot generates files following the template

---

## 4. Custom Agents (.agent.md)

### Custom Agent Structure

```markdown
---
description: Brief description shown in chat input
name: agent-name
argument-hint: Optional hint text
tools: ['search', 'fetch', 'edit_files']
model: Claude Sonnet 4
infer: true
handoffs:
  - label: Next Step Button Text
    agent: target-agent-name
    prompt: Prompt to send to next agent
    send: false
---

# Agent Instructions

Your specialized instructions go here...
```

### Example: Embedded Expert Agent

```markdown
---
description: Expert in embedded C/C++ and RTOS development
name: Embedded-Expert
tools: ['search', 'edit_files', 'create_file', 'codebase']
model: Claude Sonnet 4
---

# Embedded Systems Expert

You are an expert in embedded C/C++ development with deep knowledge of 
RTOS, hardware abstraction layers, and real-time constraints.

## Embedded Constraints

**Always consider:**
- No dynamic memory allocation
- No exceptions
- Static allocation only
- Interrupt safety
- Real-time requirements
- Memory constraints

## Code Patterns

**Use these patterns:**
- State machines for complex logic
- Hardware abstraction layers (HAL)
- Volatile for hardware registers
- Const correctness
- RAII patterns (C++)

## MISRA Compliance

**Follow MISRA C/C++ guidelines:**
- No goto statements
- Single return point per function
- Explicit type conversions
- No recursion
- Limited nesting depth
```

### Example: Planning Agent with Handoffs

```markdown
---
description: Generate implementation plans for features
name: Planner
tools: ['search', 'fetch', 'githubRepo', 'usages', 'codebase']
model: Claude Sonnet 4
handoffs:
  - label: Start Implementation
    agent: agent
    prompt: Implement the plan outlined above.
    send: false
---

# Planning Instructions

You are in planning mode. Generate implementation plans WITHOUT making 
code edits.

## Plan Structure

1. **Overview**: Brief description of the feature/task
2. **Requirements**: Detailed requirements list
3. **Architecture**: High-level design decisions
4. **Implementation Steps**: Step-by-step plan
5. **Testing Strategy**: How to verify
6. **Risks & Considerations**: Potential issues

## Process

1. Analyze existing codebase using #tool:codebase
2. Research similar implementations using #tool:githubRepo
3. Identify affected files using #tool:usages
4. Generate comprehensive plan
5. Don't make any code changes - planning only
```

---

## 5. Agent Skills (SKILL.md folders)

### Skill vs Instructions Comparison

| Feature | Agent Skills | Custom Instructions |
|---------|-------------|---------------------|
| **Purpose** | Specialized capabilities & workflows | Coding standards & guidelines |
| **Portability** | Works across VS Code, CLI, GitHub.com | VS Code and GitHub.com only |
| **Content** | Instructions + scripts + examples | Instructions only |
| **Loading** | On-demand when relevant | Always applied |
| **Standard** | Open standard (agentskills.io) | VS Code-specific |

### Skill Structure

```
.github/skills/misra-compliance/
├── SKILL.md                 # Skill definition
├── rules.md                 # MISRA rules reference
├── scripts/
│   └── check-compliance.sh  # Helper scripts
├── examples/
│   ├── good-code.cpp
│   └── bad-code.cpp
└── templates/
    └── review-report.md
```

### SKILL.md Format

```markdown
---
name: misra-compliance
description: Check code for MISRA C/C++ compliance. Use when reviewing 
embedded code for safety-critical systems.
---

# MISRA Compliance Checker

Validate embedded C/C++ code against MISRA guidelines.

## Validation Checklist

1. **Memory Management**
   - No dynamic allocation (Rule 21.3)
   - No pointer arithmetic (Rule 18.4)

2. **Control Flow**
   - No goto statements (Rule 15.1)
   - Single exit point (Rule 15.5)

3. **Type Safety**
   - Explicit casts required (Rule 10.1)
   - No implicit conversions (Rule 10.3)

## Resources

- [MISRA Rules Reference](./rules.md)
- [Compliant Examples](./examples/good-code.cpp)
- [Non-Compliant Examples](./examples/bad-code.cpp)

## Output

Generate a compliance report using [report template](./templates/review-report.md).
```

---

## 6. Guided Hands-On: Create Steering Docs

### Step 1: Create copilot-instructions.md (3 min)

1. Create `.github/copilot-instructions.md`
2. Add your project's coding standards:

```markdown
# Project Coding Standards

## C++ Standards
- Use C++17
- No exceptions, use error codes
- Static allocation only
- Use volatile for hardware registers

## Documentation
- Doxygen-style comments
- Document all public APIs
```

3. Test: Ask Copilot to generate code and verify it follows your standards

### Step 2: Create a Prompt File (4 min)

1. Create `.github/prompts/add-doxygen.prompt.md`:

```markdown
---
description: Add Doxygen documentation to selected code
name: add-doxygen
agent: edit
---

# Add Doxygen Documentation

Add comprehensive Doxygen comments to the selected code:
- @brief description
- @param for each parameter with units and range
- @return description
- @note for important details
- @warning for safety-critical information
```

2. Test: Select a function and type `/add-doxygen`

### Step 3: Create a Custom Agent (4 min)

1. Create `.github/agents/Code-Reviewer.agent.md`:

```markdown
---
description: Review code for best practices and issues
name: Code-Reviewer
tools: ['search', 'codebase']
---

# Code Review Agent

Review code for:
1. RAII compliance
2. Const correctness
3. Thread safety
4. Error handling
5. Memory management

Provide specific recommendations with code examples.
```

2. Test: Select the agent and ask it to review a file

### Step 4: Create a Skill (2 min)

1. Create `.github/skills/test-generator/SKILL.md`:

```markdown
---
name: test-generator
description: Generate unit tests for embedded C++ code using doctest framework
---

# Test Generator Skill

Generate comprehensive unit tests:
- Normal operation cases
- Edge cases and boundaries
- Error conditions
- Thread-safety tests (if applicable)

Use doctest framework with CHECK() and REQUIRE() macros.
```

2. Test: Ask "Generate tests for this function" - skill should auto-load

---

## Practice Exercises

### Exercise 1: Create Project-Specific Instructions
**Goal:** Define coding standards for your project

<details>
<summary>📋 Instructions</summary>

1. Create `.github/copilot-instructions.md`
2. Add sections for:
   - Language standards (C++17, etc.)
   - Memory management rules
   - Error handling patterns
   - Documentation requirements
   - Testing framework

3. Test by asking Copilot to generate a new function
4. Verify it follows your standards

**Success Criteria:**
- ✅ Instructions file created
- ✅ Standards are specific and actionable
- ✅ Generated code follows standards
</details>

<details>
<summary>💡 Solution Template</summary>

```markdown
# [Project Name] Coding Standards

## Language Standards
- C++ Version: C++17
- Style Guide: Google C++ Style
- Naming: snake_case for functions, PascalCase for classes

## Memory Management
- [x] Static allocation only
- [x] No new/delete in production code
- [x] Use std::array instead of C arrays
- [x] Fixed-size buffers with bounds checking

## Error Handling
- [x] Return error codes (enum class)
- [x] No exceptions
- [x] Document all error conditions
- [x] Always check return values

## Documentation
- [x] Doxygen-style comments
- [x] @brief, @param, @return required
- [x] Document thread-safety
- [x] Include usage examples

## Testing
- Framework: doctest
- Coverage goal: 80%
- Test edge cases and error paths
```
</details>

---

### Exercise 2: Build a Reusable Prompt
**Goal:** Create a prompt file for a common task

<details>
<summary>📋 Instructions</summary>

1. Identify a task you do frequently
2. Create `.github/prompts/[task-name].prompt.md`
3. Define:
   - Description and name
   - Agent mode (ask/edit/agent)
   - Required tools
   - Detailed instructions
   - Variables for customization

4. Test the prompt with `/[task-name]`

**Success Criteria:**
- ✅ Prompt file follows correct format
- ✅ Invokes correctly with `/name`
- ✅ Produces consistent, high-quality output
</details>

<details>
<summary>💡 Solution: Generate HAL Driver Prompt</summary>

```markdown
---
description: Generate HAL driver for a peripheral
name: generate-hal-driver
argument-hint: PeripheralName (e.g., UART, SPI, I2C)
agent: agent
tools: ['edit_files', 'create_file', 'codebase']
---

# Generate HAL Driver

Create a Hardware Abstraction Layer driver for: ${input:peripheral:PeripheralName}

## Requirements
- RAII for resource management
- Error codes, no exceptions
- Static allocation only
- Thread-safety documented
- Hide vendor HAL implementation

## Class Structure
```cpp
class ${input:peripheral}Hal {
public:
    struct Config { /* user-friendly config */ };
    explicit ${input:peripheral}Hal(const Config& config);
    ~${input:peripheral}Hal();
    
    // Delete copy, allow move
    ${input:peripheral}Hal(const ${input:peripheral}Hal&) = delete;
    ${input:peripheral}Hal& operator=(const ${input:peripheral}Hal&) = delete;
    ${input:peripheral}Hal(${input:peripheral}Hal&&) = default;
    ${input:peripheral}Hal& operator=(${input:peripheral}Hal&&) = default;
    
    [[nodiscard]] ErrorCode init();
    // ... peripheral-specific methods
};
```

## Output Files
- Drivers/${input:peripheral}_hal.hpp
- Drivers/${input:peripheral}_hal.cpp
```
</details>

---

### Exercise 3: Create a Specialized Agent
**Goal:** Design an agent for a specific role

<details>
<summary>📋 Instructions</summary>

1. Choose a specialized role (code reviewer, architect, tester)
2. Create `.github/agents/[role].agent.md`
3. Define:
   - Description and name
   - Appropriate tools
   - Specialized knowledge
   - Constraints and guidelines
   - Optional handoffs

4. Select the agent and test with relevant prompts

**Success Criteria:**
- ✅ Agent appears in dropdown
- ✅ Responds with specialized knowledge
- ✅ Follows defined constraints
</details>

<details>
<summary>💡 Solution: Safety Reviewer Agent</summary>

```markdown
---
description: Review code for safety-critical embedded systems
name: Safety-Reviewer
tools: ['search', 'codebase', 'usages']
model: Claude Sonnet 4
handoffs:
  - label: Generate Fixes
    agent: edit
    prompt: Fix the safety issues identified above.
    send: false
---

# Safety-Critical Code Reviewer

You review embedded code for safety-critical systems.

## Safety Checklist

### Memory Safety
- [ ] No buffer overflows (bounds checking)
- [ ] No null pointer dereferences
- [ ] No use-after-free
- [ ] No memory leaks

### Concurrency Safety
- [ ] No race conditions
- [ ] Proper mutex usage
- [ ] ISR-safe data access
- [ ] Volatile for shared variables

### Arithmetic Safety
- [ ] No integer overflow
- [ ] No division by zero
- [ ] Proper range checking

### Control Flow Safety
- [ ] All paths return values
- [ ] No infinite loops without exit
- [ ] Proper error handling

## Output Format

For each issue:
- **Severity:** Critical/High/Medium/Low
- **Location:** file:line
- **Issue:** Description
- **Risk:** What could go wrong
- **Fix:** Recommended solution
```
</details>

---

### Exercise 4: Build a Complete Skill
**Goal:** Create a skill with bundled resources

<details>
<summary>📋 Instructions</summary>

1. Create `.github/skills/[skill-name]/` directory
2. Create SKILL.md with:
   - Name and description
   - Detailed instructions
   - References to bundled resources

3. Add supporting files:
   - Templates in `templates/`
   - Examples in `examples/`
   - Scripts in `scripts/` (if applicable)

4. Test: Ask a question that should trigger the skill

**Success Criteria:**
- ✅ Skill is auto-discovered
- ✅ Uses bundled resources
- ✅ Produces comprehensive output
</details>

<details>
<summary>💡 Solution: API Documentation Skill</summary>

**Directory structure:**
```
.github/skills/api-docs/
├── SKILL.md
├── templates/
│   └── api-doc-template.md
└── examples/
    └── sample-api-doc.md
```

**SKILL.md:**
```markdown
---
name: api-docs
description: Generate comprehensive API documentation for embedded libraries. 
Use when documenting public APIs, HAL interfaces, or library functions.
---

# API Documentation Generator

Generate professional API documentation.

## Documentation Sections

1. **Overview** - What the API does
2. **Getting Started** - Basic usage example
3. **API Reference** - All public functions
4. **Error Handling** - Error codes and recovery
5. **Thread Safety** - Concurrency considerations
6. **Examples** - Complete usage examples

## Template

Use [api-doc-template.md](./templates/api-doc-template.md) for consistent formatting.

## Example Output

See [sample-api-doc.md](./examples/sample-api-doc.md) for the expected format.
```
</details>

---

## Quick Reference: Customization Options

### File Locations

| Type | Workspace Location | User Profile |
|------|-------------------|--------------|
| Global Instructions | `.github/copilot-instructions.md` | N/A |
| Conditional Instructions | `.github/instructions/*.instructions.md` | Profile folder |
| Prompt Files | `.github/prompts/*.prompt.md` | Profile folder |
| Custom Agents | `.github/agents/*.agent.md` | Profile folder |
| Agent Skills | `.github/skills/*/SKILL.md` | `~/.copilot/skills/` |

### When to Use Each

| Use Case | Solution |
|----------|----------|
| Project coding standards | `.github/copilot-instructions.md` |
| Language-specific rules | `*.instructions.md` with `applyTo` glob |
| Common development tasks | `.prompt.md` files |
| Specialized personas | `.agent.md` files |
| Complex workflows with resources | Skills with SKILL.md |
| Planning workflows | Agent with read-only tools + handoffs |

### Variables in Prompt Files

| Variable | Description |
|----------|-------------|
| `${workspaceFolder}` | Workspace root path |
| `${file}` | Current file path |
| `${fileBasename}` | Current file name |
| `${selection}` | Selected text |
| `${input:name}` | User input variable |
| `${input:name:placeholder}` | User input with placeholder |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Instructions not applying | Verify `github.copilot.chat.codeGeneration.useInstructionFiles` is enabled |
| Prompt file not found | Check file is in `.github/prompts/` with `.prompt.md` extension |
| Custom agent not showing | Verify file is in `.github/agents/` with `.agent.md` extension |
| Skill not loading | Enable `chat.useAgentSkills` setting and verify SKILL.md format |
| Glob pattern not matching | Test pattern syntax, ensure paths are relative to workspace root |
| Variables not resolving | Use correct syntax `${variableName}`, check variable is supported |
| Handoff button not appearing | Verify `handoffs` array in agent frontmatter |

### Debug Tips

1. **Check which instructions are loaded:**
   - Look at References section in chat response
   
2. **Verify tool availability:**
   - Use Tools picker in Chat view
   
3. **Test glob patterns:**
   - Use VS Code's file search with glob pattern
   
4. **Review agent configuration:**
   - Configure Custom Agents > hover over agent name

---

## Additional Resources

### Microsoft Learn
- [Custom Instructions Guide](https://code.visualstudio.com/docs/copilot/copilot-customization)
- [Prompt Files Documentation](https://code.visualstudio.com/docs/copilot/prompt-files)
- [Custom Agents Documentation](https://code.visualstudio.com/docs/copilot/custom-agents)

### Community Resources
- [Agent Skills Standard](https://agentskills.io)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/copilot-settings)

---

## Frequently Asked Questions

### Q: How do I share customizations with my team?

**Short Answer:** Commit `.github/` folder files to your repository.

**Detailed Explanation:**
- All files in `.github/` (instructions, prompts, agents, skills) can be version controlled
- Team members get the same AI behavior when they clone the repo
- Changes can be reviewed via pull requests
- Use `~/.copilot/skills/` for personal customizations that shouldn't be shared

---

### Q: What's the difference between agents and skills?

**Short Answer:** Agents are personas you select; skills are auto-loaded capabilities.

**Detailed Explanation:**
- **Agents:** You explicitly select from dropdown. Define specialized behavior and tools.
- **Skills:** Automatically discovered based on prompt content. Bundled with resources.

Example:
- Agent: "Embedded Expert" - always responds with embedded constraints in mind
- Skill: "MISRA Compliance" - auto-loads when you mention MISRA or code review

---

### Q: Can I use conditional instructions for different parts of my project?

**Short Answer:** Yes, use glob patterns in `applyTo` frontmatter.

**Detailed Explanation:**
Create multiple `.instructions.md` files with different patterns:

```markdown
---
applyTo: "Firmware/**/*.cpp"
---
# Firmware C++ Rules
```

```markdown
---
applyTo: "Tools/**/*.py"
---
# Python Tool Rules
```

The appropriate instructions load based on which file you're working with.

---

### Q: How do I debug why my custom agent isn't working?

**Short Answer:** Check file location, extension, and frontmatter format.

**Detailed Explanation:**
1. **Location:** Must be in `.github/agents/` or user profile
2. **Extension:** Must be `.agent.md`
3. **Frontmatter:** Must have valid YAML with `name` and `description`
4. **Tools:** Tool names must match exactly (`edit_files` not `editFiles`)
5. **Reload:** Sometimes VS Code needs restart to pick up new agents

---

### Q: Can skills reference external URLs or APIs?

**Short Answer:** Skills can include instructions for using `#fetch` tool.

**Detailed Explanation:**
Skills themselves don't make API calls, but they can:
1. Include `fetch` in their tool list
2. Provide instructions for fetching specific URLs
3. Document API endpoints and expected responses
4. The agent then uses the fetch tool during execution

---

### Q: How do handoffs work between agents?

**Short Answer:** Handoffs create buttons that switch to another agent with context.

**Detailed Explanation:**
```yaml
handoffs:
  - label: "Start Implementation"    # Button text
    agent: agent                     # Target agent
    prompt: "Implement the plan..."  # Prompt sent to target
    send: false                      # true = auto-send, false = user reviews
```

When clicked:
1. Conversation context transfers to the target agent
2. The specified prompt is queued (or sent automatically)
3. User can review and modify before sending

---

## Summary: Key Takeaways

### 1. Customization Hierarchy
- **Instructions:** Always-on coding standards
- **Prompts:** Reusable task templates (`/name`)
- **Agents:** Specialized personas (dropdown selection)
- **Skills:** Auto-loaded capabilities with resources

### 2. File Locations Matter
- `.github/copilot-instructions.md` - Global, always applied
- `.github/instructions/*.instructions.md` - Conditional via glob
- `.github/prompts/*.prompt.md` - Invoked with `/name`
- `.github/agents/*.agent.md` - Selected from dropdown
- `.github/skills/*/SKILL.md` - Auto-discovered

### 3. Front-Loading Context Wins
- Define standards once, apply everywhere
- Reduce repetition in prompts
- Ensure consistent team behavior
- Version control your AI configuration

### 4. Layer Your Customizations
- Base: Global instructions (coding standards)
- Task: Prompt files (specific workflows)
- Role: Custom agents (specialized personas)
- Capability: Skills (complex tasks with resources)

### 5. Test and Iterate
- Verify instructions are being applied
- Test prompts produce expected output
- Refine agents based on actual usage
- Share successful patterns with team

---

*Lesson 3: Planning & Steering Documents - GitHub Copilot Customization*  
*Last Updated: January 2026*
