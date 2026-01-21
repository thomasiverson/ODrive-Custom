# Planning & Steering Documents: GitHub Copilot Customization

**Session Duration:** 60 minutes  
**Audience:** Embedded/C++ Developers/Project Managers/QA Engineers/Firmware Engineers  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Why Planning Matters](#why-planning-matters)
- [Agenda](#agenda-planning--steering-documents-60-min)
- [Copilot Customization Hierarchy](#copilot-customization-hierarchy)
- [Custom Instructions](#custom-instructions-copilot-instructionsmd)
- [Prompt Files](#prompt-files-promptmd)
- [Custom Agents](#custom-agents-agentmd)
- [Agent Skills](#agent-skills-skillmd-folders)
- [Speaker Instructions](#speaker-instructions)
- [Participant Instructions](#participant-instructions)
- [Quick Reference](#quick-reference-customization-options)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Prerequisites

Before starting this session, ensure you have:

- **Completed Basic Feature Overview** - Understanding of Chat modes, participants, and slash commands
- **Visual Studio Code** with GitHub Copilot extensions installed and enabled
- **Active Copilot subscription** with access to all features
- **Workspace access** - Ability to create folders and files in `.github/` directory
- **Basic Markdown knowledge** - For authoring customization files

### Verify Your Setup

1. **Check workspace permissions:**
   - Ensure you can create folders in your workspace
   - Verify `.github/` directory exists or can be created

2. **Enable customization features:**
   - Open VS Code Settings (Ctrl+,)
   - Make sure custom instructions is checked out
   ![alt text](image.png)
   - Search for `chat.useAgentSkills` and enable it

3. **Test basic functionality:**
   - Open Chat view (Ctrl+Alt+I)
   - Verify agents dropdown is accessible
   - Confirm you can create new files in workspace

---

## Why Planning Matters

Front-loading context improves output quality dramatically. Instead of repeatedly providing the same context in every chat prompt, planning documents enable you to:

### Benefits of Planning Documents

1. **Consistency Across Sessions**
   - Define coding standards once, apply everywhere
   - Ensure all team members get the same AI behavior
   - Maintain consistent code quality

2. **Reduced Repetition**
   - Stop copy-pasting the same instructions
   - Eliminate redundant context in prompts
   - Save time and effort on every interaction

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

## Agenda: Planning & Steering Documents (60 min)

| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Why Planning Matters | Front-loading context improves output quality | 10 min |
| copilot-instructions.md | Repo-level coding standards, constraints, patterns | 10 min |
| Prompt Files (.prompt.md) | Reusable task templates for common workflows | 10 min |
| Custom Agents (.agent.md) | Specialized agent profiles for domain-specific tasks | 12 min |
| Agent Skills (SKILL.md folders) | Self-contained instruction folders with bundled resources | 10 min |
| **Hands-On:** Create Steering Docs | Build copilot-instructions.md, custom agent, and skill folder | 8 min |

---

## Copilot Customization Hierarchy

| Customization | Location | When Loaded | Purpose |
|---------------|----------|-------------|---------|
| **Instructions** | `.github/copilot-instructions.md` or `*.instructions.md` | Always (every request) or conditionally via glob patterns | Global coding standards, style guides |
| **Prompt Files** | `.github/prompts/*.prompt.md` | When user invokes with `/prompt-name` | Reusable task templates |
| **Custom Agents** | `.github/agents/*.agent.md` | When selected from agents dropdown | Specialized assistant personas with tool configs |
| **Agent Skills** | `.github/skills/*/SKILL.md` or `~/.copilot/skills/*/SKILL.md` | Auto-discovered from prompt | Task workflows with bundled scripts/references/templates |

---

## Custom Instructions (copilot-instructions.md)

Custom instructions enable you to define common guidelines and rules that automatically influence how AI generates code and handles other development tasks.

### Types of Instructions Files

#### 1. Global Instructions File
**Location:** `.github/copilot-instructions.md`

- Automatically applies to **all chat requests** in the workspace
- Stored within the workspace for team sharing
- Works in VS Code, Visual Studio, and GitHub.com

**Example Structure:**

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

#### 2. Conditional Instructions Files
**Location:** `.github/instructions/*.instructions.md`

- Apply to specific file types using glob patterns
- Multiple files for different contexts
- Stored in workspace or user profile

**Example: Python Instructions**

```markdown
---
applyTo: "**/*.py"
description: Python coding standards
---

# Python Coding Standards
- Follow PEP 8 style guide
- Use type hints for all functions
- Write docstrings for all public functions
- Use pytest for testing
```

**Example: Embedded C Instructions**

```markdown
---
applyTo: "Firmware/**/*.{c,h}"
description: Embedded C coding standards
---

# Embedded C Standards
- No dynamic memory allocation
- Use static allocation only
- Document interrupt handlers
- Use volatile for hardware registers
- Follow MISRA C guidelines where applicable
```

---

## Prompt Files (.prompt.md)

Prompt files are Markdown files that define reusable prompts for common development tasks. They are standalone prompts that you can run directly in chat.

### Prompt File Structure

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

### Example: Generate React Form Component

```markdown
---
description: Generate a React form component with validation
name: create-react-form
argument-hint: formName=MyForm
agent: edit
tools: ['edit_files', 'create_file']
---

# Generate React Form Component

Create a React form component with the following requirements:

1. Form name: ${input:formName:FormName}
2. Include form validation using Formik
3. Use Material-UI components
4. Include TypeScript types
5. Add unit tests using React Testing Library

The component should:
- Handle form submission
- Display validation errors
- Support controlled inputs
- Be accessible (ARIA labels)
```

### Example: Security Review

```markdown
---
description: Perform security review of REST API endpoints
name: security-review
agent: ask
tools: ['search', 'codebase', 'usages']
---

# REST API Security Review

Analyze the selected REST API code for security vulnerabilities:

1. **Authentication & Authorization**
   - Check for proper authentication on all endpoints
   - Verify authorization logic
   - Look for privilege escalation risks

2. **Input Validation**
   - Identify missing input validation
   - Check for SQL injection risks
   - Look for XSS vulnerabilities

3. **Data Exposure**
   - Check for sensitive data in responses
   - Verify data sanitization
   - Look for information leakage

4. **Rate Limiting**
   - Check for rate limiting on endpoints
   - Verify DoS protection

Provide specific findings with code locations and remediation steps.
```

### Create a Prompt File

1. **In Chat view:**
   - Select Configure Chat (gear icon) > Prompt Files > New prompt file
   - Or use Command Palette: `Chat: New Prompt File`

2. **Choose location:**
   - **Workspace:** `.github/prompts/` (team sharing)
   - **User profile:** Available across all workspaces

3. **Author the prompt:**
   - Fill in YAML frontmatter
   - Write clear instructions
   - Use variables for flexibility

4. **Use the prompt:**
   - Type `/prompt-name` in Chat view
   - Provide any required arguments

---

## Custom Agents (.agent.md)

Custom agents enable you to configure the AI to adopt different personas tailored to specific development roles and tasks.

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

### Example: Planning Agent

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

You are in planning mode. Generate implementation plans without making code edits.

## Plan Structure

1. **Overview**: Brief description of the feature/task
2. **Requirements**: Detailed requirements list
3. **Architecture**: High-level design decisions
4. **Implementation Steps**: Detailed step-by-step plan
5. **Testing Strategy**: How to verify the implementation
6. **Risks & Considerations**: Potential issues to watch

## Process

1. Analyze existing codebase using #tool:codebase
2. Research similar implementations using #tool:githubRepo
3. Identify affected files using #tool:usages
4. Generate comprehensive plan
5. Don't make any code changes - planning only
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

You are an expert in embedded C/C++ development with deep knowledge of RTOS, hardware abstraction layers, and real-time constraints.

## Embedded Constraints

**Always consider:**
- No dynamic memory allocation
- No exceptions
- Static allocation only
- Interrupt safety
- Real-time requirements
- Memory constraints
- Power consumption

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

## Documentation

**Always document:**
- Interrupt handlers
- Hardware register access
- Timing constraints
- Thread safety assumptions
```

### Example: Code Review Agent

```markdown
---
description: Perform thorough code reviews
name: Code-Reviewer
tools: ['search', 'codebase', 'usages']
model: Claude Sonnet 4
handoffs:
  - label: Fix Issues
    agent: edit
    prompt: Fix the issues identified in the code review above.
    send: false
---

# Code Review Instructions

Perform comprehensive code review focusing on:

## Review Checklist

1. **Code Quality**
   - Readability and maintainability
   - Naming conventions
   - Code duplication
   - Function complexity

2. **Best Practices**
   - Design patterns usage
   - Error handling
   - Resource management
   - Thread safety

3. **Testing**
   - Unit test coverage
   - Edge cases
   - Error conditions

4. **Performance**
   - Algorithm efficiency
   - Memory usage
   - Potential bottlenecks

5. **Security**
   - Input validation
   - Authentication/authorization
   - Data sanitization

## Output Format

For each issue found:
- **Severity**: Critical/High/Medium/Low
- **Location**: File and line number
- **Issue**: Clear description
- **Recommendation**: How to fix
- **Example**: Code snippet if helpful
```

### Create a Custom Agent

1. **In Chat view:**
   - Select Configure Chat (gear icon) > Custom Agents > Create new custom agent
   - Or use Command Palette: `Chat: New Custom Agent`

2. **Choose location:**
   - **Workspace:** `.github/agents/` (team sharing)
   - **User profile:** Available across all workspaces

3. **Author the agent:**
   - Fill in YAML frontmatter
   - Define tools and model
   - Write specialized instructions
   - Add handoffs if needed

4. **Use the agent:**
   - Select from agents dropdown in Chat view
   - All prompts use this agent's configuration

---


## Agent Skills (SKILL.md folders)

Agent Skills are folders of instructions, scripts, and resources that Copilot can load when relevant to perform specialized tasks.

### Skill vs Instructions Comparison

| Feature | Agent Skills | Custom Instructions |
|---------|-------------|---------------------|
| **Purpose** | Specialized capabilities & workflows | Coding standards & guidelines |
| **Portability** | Works across VS Code, CLI, GitHub.com | VS Code and GitHub.com only |
| **Content** | Instructions + scripts + examples + resources | Instructions only |
| **Loading** | On-demand when relevant | Always applied or via glob patterns |
| **Standard** | Open standard (agentskills.io) | VS Code-specific |

### Skill Structure

```
.github/skills/webapp-testing/
├── SKILL.md                 # Skill definition
├── test-template.js         # Test template
├── scripts/
│   └── run-tests.sh        # Helper scripts
├── examples/
│   ├── unit-test.js
│   └── integration-test.js
└── references/
    └── testing-guide.md
```

### SKILL.md Format

```markdown
---
name: skill-name
description: What the skill does and when to use it (max 1024 chars)
---

# Skill Instructions

Detailed instructions, guidelines, and examples...

## Resources

- [Test Template](./test-template.js)
- [Run Script](./scripts/run-tests.sh)
- [Examples](./examples/)
```

### Example: Web Application Testing Skill

```markdown
---
name: webapp-testing
description: Generate and run tests for web applications using Jest and React Testing Library. Use when testing React components, API endpoints, or user workflows.
---

# Web Application Testing

Generate comprehensive tests for web applications following these patterns:

## Test Structure

Use the template from [test-template.js](./test-template.js):

```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import { ComponentName } from './ComponentName';

describe('ComponentName', () => {
  it('should render correctly', () => {
    // Test implementation
  });
});
```

## Testing Patterns

1. **Component Tests**
   - Render component with props
   - Assert DOM structure
   - Test user interactions
   - Verify state changes

2. **API Tests**
   - Mock API calls
   - Test success scenarios
   - Test error handling
   - Verify request parameters

3. **Integration Tests**
   - Test user workflows
   - Verify multi-step interactions
   - Test data persistence

## Running Tests

Use [scripts/run-tests.sh](./scripts/run-tests.sh) to execute tests:

```bash
./scripts/run-tests.sh --coverage --watch
```

## Examples

See [examples/](./examples/) for complete test examples:
- [Unit Test Example](./examples/unit-test.js)
- [Integration Test Example](./examples/integration-test.js)
```

### Example: GitHub Actions Debugging Skill

```markdown
---
name: github-actions-debug
description: Debug GitHub Actions workflow failures by analyzing logs, identifying issues, and suggesting fixes. Use when CI/CD pipelines fail or need optimization.
---

# GitHub Actions Debugging

Debug GitHub Actions workflows systematically:

## Debugging Process

1. **Analyze Workflow File**
   - Review .github/workflows/*.yml
   - Check job dependencies
   - Verify trigger conditions

2. **Examine Logs**
   - Identify failed steps
   - Look for error messages
   - Check environment variables

3. **Common Issues**
   - Missing secrets
   - Incorrect paths
   - Permission issues
   - Dependency problems
   - Timeout issues

4. **Generate Fixes**
   - Provide corrected workflow YAML
   - Explain what changed and why
   - Suggest best practices

## Workflow Template

See [workflow-template.yml](./workflow-template.yml) for a production-ready template with:
- Proper caching
- Matrix builds
- Error handling
- Notifications

## Debugging Scripts

Use [scripts/analyze-logs.sh](./scripts/analyze-logs.sh) to parse workflow logs and identify common patterns.
```

### Create an Agent Skill

1. **Enable skills:**
   - Open Settings (Ctrl+,)
   - Search for `chat.useAgentSkills`
   - Enable the setting

2. **Create skill directory:**
   ```
   .github/skills/my-skill/
   └── SKILL.md
   ```

3. **Author SKILL.md:**
   - Fill in YAML frontmatter (name, description)
   - Write detailed instructions
   - Reference any bundled resources

4. **Add resources (optional):**
   - Scripts in `scripts/`
   - Examples in `examples/`
   - Documentation in `references/`

5. **Test the skill:**
   - Create a prompt that matches skill description
   - Copilot auto-loads skill when relevant

---

## Speaker Instructions

### 1. Demo: Why Planning Matters (10 min)

**Show the problem:**
1. Open Chat view and generate code without any instructions
2. Show generic, non-project-specific output
3. Highlight inconsistencies across multiple generations

**Show the solution:**
1. Add a `.github/copilot-instructions.md` file with project standards
2. Generate similar code again
3. Highlight improved consistency and adherence to standards

**Key points to emphasize:**
- Context matters for quality
- Repetition wastes time
- Team collaboration benefits
- Version control for AI behavior

### 2. Demo: Custom Instructions (10 min)

**Create copilot-instructions.md:**
1. Create `.github/copilot-instructions.md`
2. Add C++ coding standards
3. Add embedded constraints
4. Add documentation requirements

**Test the instructions:**
1. Ask Copilot to generate a motor control function
2. Show it follows static allocation rules
3. Show it includes Doxygen comments
4. Show it avoids exceptions

**Example for ODrive project:**
```markdown
# ODrive Firmware Coding Standards

## C++ Standards
- Use C++17
- No exceptions
- No RTTI
- Static allocation only

## Motor Control
- All control loops at 8kHz
- Use fixed-point math where possible
- Document timing constraints

## HAL Patterns
- Abstract hardware access
- Use volatile for registers
- Document interrupt context
```

### 3. Demo: Prompt Files (10 min)

**Create reusable prompts:**

1. **Create state machine generator:**
   - File: `.github/prompts/generate-state-machine.prompt.md`
   - Demonstrates code generation workflow
   - Shows variable usage

2. **Create code review prompt:**
   - File: `.github/prompts/embedded-review.prompt.md`
   - Demonstrates analysis workflow
   - Shows tool selection

**Use the prompts:**
1. Type `/generate-state-machine` in chat
2. Provide state machine name
3. Show generated code follows standards

### 4. Demo: Custom Agents (12 min)

**Create specialized agents:**

1. **Planning Agent:**
   - Read-only tools
   - Generates implementation plans
   - Handoff to implementation agent

2. **Embedded Expert Agent:**
   - Editing tools enabled
   - Specialized embedded knowledge
   - MISRA compliance focus

3. **Code Reviewer Agent:**
   - Analysis tools only
   - Security focus
   - Handoff to fix issues

**Demo workflow:**
1. Switch to Planning agent
2. Generate plan for new feature
3. Use handoff to Implementation agent
4. Make code changes
5. Use handoff to Code Reviewer agent
6. Review and suggest improvements

### 5. Demo: Agent Skills (10 min)

**Create example skill:**
1. Create `.github/skills/misra-compliance/`
2. Add SKILL.md with MISRA rules
3. Include example scripts for checking
4. Add reference documentation

**Show progressive loading:**
1. Skill discovered by name/description
2. Instructions loaded when relevant
3. Resources accessed as needed

**Test the skill:**
1. Ask: "Check this code for MISRA compliance"
2. Copilot auto-loads the skill
3. Uses bundled resources for checks
4. Provides detailed compliance report

### 6. Demo: Hands-On Exercise (8 min)

Walk through creating a complete customization setup:
1. Create copilot-instructions.md for project
2. Create one prompt file
3. Create one custom agent
4. Create one skill folder

---

## Participant Instructions

### Exercise 1: Create Custom Instructions (10 min)

**Task:** Create a `.github/copilot-instructions.md` file for your project

1. Create the file in your workspace
2. Add coding standards for your primary language
3. Add project-specific constraints
4. Add documentation requirements

**Example template:**

```markdown
# Project Coding Standards

## [Language] Standards
- Version:
- Style guide:
- Key principles:

## Project Constraints
- Memory limits:
- Performance requirements:
- Dependencies:

## Documentation
- Comment style:
- Required documentation:
```

### Exercise 2: Create a Prompt File (10 min)

**Task:** Create a reusable prompt for a common task

1. In Chat view: Configure Chat > Prompt Files > New prompt file
2. Choose workspace location
3. Create a prompt for one of:
   - Generating unit tests
   - Creating API endpoints
   - Generating state machines
   - Code refactoring

**Test your prompt:**
- Type `/your-prompt-name` in chat
- Verify it works as expected

### Exercise 3: Create a Custom Agent (12 min)

**Task:** Create a specialized agent for your domain

1. From agents dropdown: Configure Custom Agents > Create new custom agent
2. Choose workspace location
3. Create an agent for one of:
   - Code reviewer
   - Testing specialist
   - Architecture advisor
   - Domain expert

**Test your agent:**
- Select it from agents dropdown
- Ask a relevant question
- Verify specialized behavior

### Exercise 4: Create an Agent Skill (10 min)

**Task:** Create a skill with bundled resources

1. Create `.github/skills/my-skill/` directory
2. Create SKILL.md with instructions
3. Add at least one resource file:
   - Example script
   - Template file
   - Reference documentation

**Test your skill:**
- Ask a question that matches the skill description
- Verify Copilot loads the skill
- Check that it uses bundled resources

---

## Quick Reference: Customization Options

### File Locations

| Type | Workspace Location | User Profile Location |
|------|-------------------|----------------------|
| Global Instructions | `.github/copilot-instructions.md` | N/A |
| Conditional Instructions | `.github/instructions/*.instructions.md` | Profile folder |
| Prompt Files | `.github/prompts/*.prompt.md` | Profile folder |
| Custom Agents | `.github/agents/*.agent.md` | Profile folder |
| Agent Skills | `.github/skills/*/SKILL.md` | `~/.copilot/skills/*/SKILL.md` |

### When to Use Each

| Use Case | Solution |
|----------|----------|
| Project coding standards | `.github/copilot-instructions.md` |
| Language-specific rules | `*.instructions.md` with `applyTo` glob pattern |
| Common development tasks | `.prompt.md` files |
| Specialized personas | `.agent.md` files |
| Complex workflows with resources | Skills with SKILL.md |
| Planning workflows | Custom agent with read-only tools + handoffs |
| Sequential workflows | Custom agents with handoffs |

### Variables in Prompt Files

| Variable | Description |
|----------|-------------|
| `${workspaceFolder}` | Workspace root path |
| `${file}` | Current file path |
| `${fileBasename}` | Current file name |
| `${fileDirname}` | Current file directory |
| `${selection}` | Selected text |
| `${selectedText}` | Selected text (alias) |
| `${input:name}` | User input variable |
| `${input:name:placeholder}` | User input with placeholder |

### Tool Selection

| Tool Category | Tools | Use Case |
|---------------|-------|----------|
| **Read-only** | search, fetch, githubRepo, codebase | Planning, research, analysis |
| **File operations** | create_file, edit_files, read_file | Implementation, refactoring |
| **Terminal** | run_in_terminal, get_terminal_output | Build, test, deployment |
| **Testing** | runTests, test_failure | Test generation, debugging |
| **Source control** | changes, get_changed_files | Code review, commit messages |

---

## Best Practices

### Custom Instructions

1. **Be specific and concise**
   - Clear, actionable guidelines
   - Avoid ambiguity
   - Use examples

2. **Organize by topic**
   - Language standards
   - Project constraints
   - Documentation
   - Testing

3. **Use multiple files for complex projects**
   - Language-specific instructions
   - Domain-specific instructions
   - Role-specific instructions

4. **Reference, don't duplicate**
   - Link to external style guides
   - Reference existing documentation
   - Avoid repeating project docs

5. **Version control**
   - Commit to source control
   - Review changes as code
   - Document updates

### Prompt Files

1. **Make prompts reusable**
   - Use variables for flexibility
   - Avoid hardcoded values
   - Support arguments

2. **Provide clear examples**
   - Show expected input
   - Show expected output
   - Include edge cases

3. **Select appropriate tools**
   - Match tools to task
   - Don't over-specify
   - Use tool sets when appropriate

4. **Test thoroughly**
   - Use editor play button
   - Test with different inputs
   - Refine based on results

### Custom Agents

1. **Single responsibility**
   - One clear purpose per agent
   - Focused tool set
   - Specialized instructions

2. **Use handoffs for workflows**
   - Plan → Implement → Review
   - Clear transition points
   - Context preservation

3. **Tool selection matters**
   - Planning: read-only tools
   - Implementation: editing tools
   - Review: analysis tools

4. **Reference existing instructions**
   - Link to instructions files
   - Don't duplicate guidelines
   - Keep agents focused

### Agent Skills

1. **Clear, specific descriptions**
   - What the skill does
   - When to use it
   - Key capabilities

2. **Bundle related resources**
   - Templates
   - Scripts
   - Examples
   - Documentation

3. **Progressive disclosure**
   - Keep SKILL.md focused
   - Reference resources as needed
   - Don't overload context

4. **Follow open standard**
   - Use standard structure
   - Compatible across tools
   - Community shareable

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Instructions not applying | Verify `github.copilot.chat.codeGeneration.useInstructionFiles` is enabled |
| Prompt file not found | Check file is in `.github/prompts/` or user profile prompts folder |
| Custom agent not showing | Verify file is in `.github/agents/` with `.agent.md` extension |
| Skill not loading | Enable `chat.useAgentSkills` setting and verify SKILL.md format |
| Glob pattern not matching | Test pattern syntax, ensure paths are relative to workspace root |
| Tool not available | Check tool name spelling, verify MCP server is running |
| Variables not resolving | Use correct syntax `${variableName}`, check variable is supported |
| Handoff button not appearing | Verify `handoffs` array in agent frontmatter, check target agent exists |
| Workspace customization not shared | Ensure files are committed to source control in `.github/` folder |
| User profile customization not syncing | Enable Settings Sync and include "Prompts and Instructions" |

### Debug Tips

1. **Check which instructions are loaded:**
   - Look at References section in chat response
   - Use Chat Debug view to see language model requests

2. **Verify tool availability:**
   - Use Tools picker in Chat view
   - Check MCP server status

3. **Test glob patterns:**
   - Use VS Code's file search with glob pattern
   - Verify pattern matches intended files

4. **Review agent configuration:**
   - Configure Custom Agents > hover over agent name
   - Tooltip shows source location

---

## Additional Resources

### Official Documentation

- [Custom Instructions Guide](https://code.visualstudio.com/docs/copilot/copilot-customization)
- [Prompt Files Documentation](https://code.visualstudio.com/docs/copilot/prompt-files)
- [Custom Agents Documentation](https://code.visualstudio.com/docs/copilot/custom-agents)
- [Agent Skills Standard](https://agentskills.io)

### Community Resources

- [Awesome Copilot Repository](https://github.com/github/awesome-copilot) - Community examples
- [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/copilot-settings)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)

### Example Repositories

Your workspace already has examples in:
- `.github/agents/` - Custom agent examples
- `.github/instructions/` - Instructions file examples
- `.github/prompts/` - Prompt file examples
- `.github/skills/` - Agent skill examples

---

## Next Steps

After completing this session:

1. **Create your base customization:**
   - Start with `.github/copilot-instructions.md`
   - Add language-specific instructions as needed
   - Test and refine based on results

2. **Build prompt library:**
   - Identify common tasks in your workflow
   - Create 3-5 prompt files for most frequent tasks
   - Share with team and iterate

3. **Develop specialized agents:**
   - Create agents for different development roles
   - Add handoffs for common workflows
   - Experiment with tool combinations

4. **Create domain skills:**
   - Identify specialized knowledge areas
   - Package instructions with resources
   - Share across tools (VS Code, CLI, GitHub.com)

5. **Team adoption:**
   - Commit customizations to source control
   - Document team workflows
   - Gather feedback and improve

---

*GitHub Copilot Planning & Steering Documents Guide*  
*Last Updated: January 2026*
