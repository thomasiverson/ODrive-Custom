# Lesson 2: Basic Feature Overview - GitHub Copilot in VS Code

**Session Duration:** 45 minutes  
**Audience:** Embedded/C++ Developers/Project Managers/QA engineers/Firmware Engineers  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Overview

This lesson introduces the core features of GitHub Copilot in VS Code. You'll learn the three primary interaction modes, how to leverage chat participants and slash commands, and how to maximize productivity with inline suggestions and multi-file editing.

**What You'll Learn:**
- The three Copilot modes (Ask, Edit, Agent) and when to use each
- Chat participants (`@workspace`, `@terminal`, `@vscode`, `@github`) for domain-specific assistance
- Slash commands (`/fix`, `/explain`, `/tests`, `/doc`) for common tasks
- Inline suggestions and multi-file editing workflows

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **Ask Mode** | Question-and-answer about code, architecture, debugging |
| **Edit Mode** | Code generation, refactoring, documentation via Inline Chat |
| **Agent Mode** | Autonomous multi-step tasks across files with planning |
| **Chat Participants** | `@`-prefixed helpers for project, terminal, IDE, and GitHub |
| **Slash Commands** | `/`-prefixed shortcuts for common operations |

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Why Copilot Features Matter](#why-copilot-features-matter)
- [Learning Path](#learning-path)
- [Get Started with Chat in VS Code](#1-get-started-with-chat-in-vs-code)
- [Copilot Chat Modes](#2-copilot-chat-modes)
- [Chat Participants & Slash Commands](#3-chat-participants--slash-commands)
- [Inline Chat & Copilot Edits](#4-inline-chat--copilot-edits)
- [Guided Hands-On: Explore Features](#5-guided-hands-on-explore-features)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference-github-copilot-chat)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **Visual Studio Code** installed (latest version recommended)
- ✅ **GitHub Copilot subscription** (or Copilot Free plan with monthly limits)
- ✅ Active internet connection for AI model access
- ✅ A GitHub account for authentication

### Verify Your Setup

1. **Check VS Code installation:**
   - Open VS Code
   - Press `Ctrl+Shift+P` and type "About" to verify version

2. **Verify Copilot subscription:**
   - Visit https://github.com/settings/copilot
   - Ensure you have an active subscription or free plan

3. **Install GitHub Copilot extension:**
   - Open VS Code Extensions (Ctrl+Shift+X)
   - Search for "GitHub Copilot"
   - Install both "GitHub Copilot" and "GitHub Copilot Chat" extensions

---

## Why Copilot Features Matter

Understanding the full range of Copilot features enables you to:

### Benefits of Mastering Copilot Features

1. **Right Tool for the Job**
   - Ask Mode for exploration and understanding
   - Edit Mode for targeted code changes
   - Agent Mode for complex multi-file tasks

2. **Faster Code Comprehension**
   - Use `@workspace` to understand project architecture
   - Use `/explain` to decode unfamiliar code
   - Use `#file:` references for context-aware answers

3. **Accelerated Development**
   - Generate tests with `/tests`
   - Fix bugs with `/fix`
   - Document code with `/doc`

4. **Seamless IDE Integration**
   - Terminal assistance with `@terminal`
   - VS Code settings help with `@vscode`
   - GitHub integration with `@github`

---

## Learning Path

This lesson covers five key areas. Work through them sequentially for the best learning experience.

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Get Started with Chat | Three ways to access Copilot Chat | 5 min |
| Copilot Chat Modes | Ask, Edit, Agent - when to use each | 10 min |
| Chat Participants & Slash Commands | `@workspace`, `@terminal`, `/fix`, `/explain` | 10 min |
| Inline Chat & Copilot Edits | In-editor completions, multi-file editing | 10 min |
| Guided Hands-On | Try each mode with walkthrough | 10 min |

---

## 1. Get Started with Chat in VS Code

### Access Chat in VS Code
**🎯 Copilot Mode: All Modes**

VS Code provides three ways to start an AI chat conversation, each optimized for different workflows:

#### Chat View
Press **Ctrl+Alt+I** to open the Chat view in a dedicated side panel.

**Use the Chat view for:**
- Ongoing, multi-turn chat conversations
- Switching between different agents
- Working on features that span multiple files
- Planning and implementing complex changes

#### Inline Chat
Press **Ctrl+I** to start a chat conversation directly in your editor or terminal.

**Use inline chat for:**
- Getting suggestions inline, right where you're working
- Understanding code in your current context
- Getting help with terminal commands and output

#### Quick Chat
Press **Ctrl+Shift+Alt+L** to open a lightweight chat overlay.

**Use quick chat for:**
- Quick questions that don't require extended conversation
- Getting answers without changing your current view
- Looking up information while maintaining focus

### Essential Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open the Chat view |
| `Ctrl+I` | Start inline chat in editor or terminal |
| `Ctrl+Shift+Alt+L` | Open Quick Chat |
| `Ctrl+N` | Start a new chat session |
| `Ctrl+Shift+I` | Switch to using agents in Chat view |
| `Ctrl+Alt+.` | Show model picker |
| `Tab` | Accept inline suggestion |
| `Escape` | Dismiss inline suggestion |
| `F2` | AI-powered symbol renaming |

---

## 2. Copilot Chat Modes

### Ask Mode
**🎯 Purpose: Questions, exploration, understanding**

Use the Chat panel to ask questions about the codebase, architecture, or debug issues.

**Example Prompts:**
```
Explain this project in simple, layman's terms. What is the high-level 
functionality? Provide a tour of the folder structure.
```

```
How is the custom fibre protocol implemented in #file:fibre.cpp? 
Explain how an object method on the firmware side is exposed to the Python client.
```

```
I am seeing ERROR_OVERSPEED in my logs. Look at #file:axis.cpp and 
#file:motor.cpp. What specific conditions trigger this error?
```

### Edit Mode
**🎯 Purpose: Code generation, refactoring, documentation**

Use Inline Chat (Ctrl+I) to generate/refactor code, add documentation, or create scripts/tests.

**Example Prompts:**
```
Add a new configuration variable `float soft_stop_rate` to the 
ControllerConfig struct. Then, update the update() method in 
controller.cpp to use this rate.
```

```
Create a new test case using the doctest framework that verifies 
the SVM utility function handles all six sextants correctly.
```

```
Add Doxygen-style comments to the on_measurement function in 
#file:foc.cpp, explaining the Clarke transform.
```

### Agent Mode
**🎯 Purpose: Multi-step, cross-file, autonomous tasks**

Use for complex tasks where Copilot can plan, research, and execute changes.

**Example Prompts:**
```
Build the ODrive firmware by running the tup build command. If there 
are compilation errors, analyze the error output, identify which files 
are causing issues, suggest fixes, apply them, and rebuild.
```

```
Implement a 'Stall Detection' feature. Research how other motor 
controllers detect stalls. Create a plan, then add the config flag 
and the detection logic.
```

```
Find all instances of raw printf debug statements across the Firmware/ 
directory. Replace them with a new macro ODRIVE_LOG() that respects 
a compile-time log level.
```

---

## 3. Chat Participants & Slash Commands

### Chat Participants (@-mentions)
Chat participants handle domain-specific requests. VS Code provides built-in participants:

| Participant | Description | Example |
|-------------|-------------|---------|
| `@workspace` | Project-wide context and code search | `@workspace how is authentication implemented?` |
| `@terminal` | Shell commands and terminal help | `@terminal list the 5 largest files` |
| `@vscode` | VS Code features and settings | `@vscode how to enable word wrapping?` |
| `@github` | GitHub repos, issues, and PRs | `@github What are all open PRs assigned to me?` |

**@workspace Examples:**
```
@workspace Trace where ERROR_PHASE_RESISTANCE_OUT_OF_RANGE is defined 
and find all occurrences where it is raised.
```

**@terminal Examples:**
```
@terminal What is the specific tup command to build only the firmware 
for the v3.6 board variant?
```

### Slash Commands (/-commands)
Slash commands are shortcuts to specific functionality:

| Slash Command | Description |
|---------------|-------------|
| `/doc` | Generate code documentation comments |
| `/explain` | Explain a code block, file, or concept |
| `/fix` | Fix a code block or resolve errors |
| `/tests` | Generate tests for selected methods |
| `/setupTests` | Get help setting up a testing framework |
| `/clear` | Start a new chat session |
| `/new` | Scaffold a new workspace or file |
| `/newNotebook` | Scaffold a new Jupyter notebook |
| `/search` | Generate a search query for the Search view |
| `/startDebugging` | Generate launch.json and start debugging |

### Chat Tools (#-mentions)
Use tools in chat to accomplish specialized tasks:

| Chat Tool | Description |
|-----------|-------------|
| `#file` | Reference a specific file as context |
| `#codebase` | Perform a code search in the workspace |
| `#selection` | Get the current editor selection |
| `#terminalSelection` | Get the current terminal selection |
| `#changes` | List of source control changes |
| `#fetch` | Fetch content from a web page |
| `#githubRepo` | Perform a code search in a GitHub repo |
| `#extensions` | Search for and ask about VS Code extensions |

---

## 4. Inline Chat & Copilot Edits

### Inline Suggestions
Start typing and Copilot provides inline suggestions. Press `Tab` to accept.

**Tips for better inline suggestions:**
- Write descriptive comments before the code
- Use meaningful variable and function names
- Provide context with comments like `// Generate SPI driver for...`

### Inline Chat (Ctrl+I)
Select code and press Ctrl+I to open inline chat for:
- Adding documentation
- Refactoring code
- Fixing errors
- Generating tests

### Multi-File Editing (Agent Mode)
Agent Mode can make coordinated changes across multiple files:
- Header and source file updates
- Interface changes with all implementations
- Refactoring with test updates

---

## 5. Guided Hands-On: Explore Features

### Step 1: Try Ask Mode (3 min)
1. Open Chat view (Ctrl+Alt+I)
2. Ask: "Explain this project in simple terms. What is the folder structure?"
3. Observe how Copilot analyzes the workspace

### Step 2: Try Edit Mode (4 min)
1. Open any C++ file
2. Select a function
3. Press Ctrl+I and type: `/doc`
4. Review and accept the generated documentation

### Step 3: Try Chat Participants (4 min)
1. In Chat: `@workspace how is error handling implemented?`
2. In Chat: `@terminal show me how to build this project`
3. In Chat: `@vscode how do I configure launch.json for debugging?`

### Step 4: Try Slash Commands (4 min)
1. Select code with a bug
2. In Chat or Inline: `/fix`
3. Select a function without tests
4. In Chat: `/tests`

---

## Practice Exercises

### Exercise 1: Explore the Codebase
**Goal:** Use Ask Mode to understand an unfamiliar codebase

<details>
<summary>📋 Instructions</summary>

1. Open Chat view (Ctrl+Alt+I)
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

### Exercise 2: Generate Documentation
**Goal:** Use Edit Mode to document a function

<details>
<summary>📋 Instructions</summary>

1. Open a C++ source file (e.g., `motor.cpp`)
2. Find a function without documentation
3. Select the function signature
4. Press Ctrl+I and type: `/doc`
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

### Exercise 3: Fix a Bug with /fix
**Goal:** Use slash commands to diagnose and fix issues

<details>
<summary>📋 Instructions</summary>

1. Find code with a known issue or warning
2. Select the problematic code
3. Press Ctrl+I and type: `/fix`
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

### Exercise 4: Generate Unit Tests
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

### Exercise 5: Use @workspace for Architecture
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

## Quick Reference: GitHub Copilot Chat

### Modes at a Glance

| Mode | Shortcut | Best For |
|------|----------|----------|
| Ask | Chat view | Questions, exploration, understanding |
| Edit | Ctrl+I | Code changes, refactoring, documentation |
| Agent | Chat with complex task | Multi-file, autonomous, planning |

### Chat Participants

| Participant | Use For |
|-------------|---------|
| `@workspace` | Project-wide questions, architecture |
| `@terminal` | Shell commands, build help |
| `@vscode` | IDE settings, debugging config |
| `@github` | PRs, issues, commits |

### Most Useful Slash Commands

| Command | Action |
|---------|--------|
| `/doc` | Generate documentation |
| `/explain` | Explain code |
| `/fix` | Fix bugs/errors |
| `/tests` | Generate unit tests |
| `/new` | Create new file |

### Prompt Tips

1. **Add context with #file:** - Reference specific files
2. **Be specific** - Clear requirements get better results
3. **Iterate** - Refine responses with follow-up questions
4. **Use constraints** - Specify patterns, standards, limitations

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Copilot not responding | Restart VS Code; verify Copilot extension is installed and enabled |
| Chat view not opening | Verify GitHub Copilot Chat extension is installed |
| Authentication fails | Verify Copilot subscription at https://github.com/settings/copilot |
| "Not authenticated" error | Sign in to GitHub through VS Code |
| Slow responses | Use `/compact` to reduce context size; try a faster model |
| Wrong file being modified | Review carefully before accepting; use full path with `#file:` |
| Inline suggestions not appearing | Check GitHub Copilot extension is enabled and you're signed in |

### Getting Help

- **Official Documentation:** https://docs.github.com/en/copilot
- **VS Code Copilot Guide:** https://code.visualstudio.com/docs/copilot
- **Check Extension Status:** Extensions view (Ctrl+Shift+X) → "GitHub Copilot"
- **View Output Logs:** Output panel (Ctrl+Shift+U) → "GitHub Copilot"

---

## Additional Resources

### Microsoft Learn
- [Get Started with GitHub Copilot in VS Code](https://learn.microsoft.com/training/modules/get-started-github-copilot-visual-studio-code/)
- [Use GitHub Copilot Chat in VS Code](https://learn.microsoft.com/training/modules/use-github-copilot-chat-vs-code/)
- [Effective Prompt Engineering](https://code.visualstudio.com/docs/copilot/prompt-crafting)

### Official Documentation
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Copilot Guide](https://code.visualstudio.com/docs/copilot/overview)
- [Copilot Free Plan](https://github.com/features/copilot)

---

## Frequently Asked Questions

### Q: When should I use Ask Mode vs Edit Mode vs Agent Mode?

**Short Answer:** Ask for questions, Edit for changes, Agent for complex multi-step tasks.

**Detailed Explanation:**
- **Ask Mode:** Use when you need to understand code, explore architecture, or get explanations. The AI reads but doesn't modify files.
- **Edit Mode:** Use when you know exactly what file/function to change. Select code, press Ctrl+I, describe the change.
- **Agent Mode:** Use when the task requires research, planning, and changes across multiple files. The AI can autonomously explore, plan, and execute.

---

### Q: What's the difference between @workspace and #codebase?

**Short Answer:** `@workspace` is a chat participant; `#codebase` is a tool for search.

**Detailed Explanation:**
- **@workspace:** Invokes a specialized participant that understands your project structure. Good for architectural questions.
- **#codebase:** Performs semantic search across your code. Good for finding specific patterns or implementations.

Use `@workspace` for "how does X work?" questions. Use `#codebase` for "find all instances of X" queries.

---

### Q: How do I get better inline suggestions?

**Short Answer:** Provide more context through comments and meaningful names.

**Detailed Explanation:**
1. Write a descriptive comment before the code you want generated
2. Use meaningful function and variable names
3. Have relevant files open in the editor
4. Start typing the function signature to guide Copilot
5. If suggestions are wrong, add more specific comments

Example:
```cpp
// Calculate motor torque from current using Kt constant
// Input: phase_current_amps (float)
// Output: torque in Nm (float)
// Constraint: Must handle division by zero
float calculate_torque(
```

---

### Q: Can Copilot work with my company's private code?

**Short Answer:** Yes, Copilot can work with any code in your VS Code workspace.

**Detailed Explanation:**
- Copilot analyzes code in your current workspace to provide context-aware suggestions
- For business/enterprise plans, code is not used to train models
- You can configure what data is sent to GitHub via VS Code settings
- Check your organization's Copilot policy for specific guidelines

---

### Q: How do I control which AI model Copilot uses?

**Short Answer:** Use `Ctrl+Alt+.` to open the model picker.

**Detailed Explanation:**
Different models have different strengths:
- **Claude Sonnet 4:** Great for complex reasoning and planning
- **GPT-4o:** Strong general-purpose model
- **Faster models:** Lower latency for quick suggestions

You can change models per-conversation or set a default in VS Code settings.

---

### Q: What if Copilot generates incorrect or insecure code?

**Short Answer:** Always review generated code; use `/fix` or ask for improvements.

**Detailed Explanation:**
1. **Review before accepting:** Never blindly accept suggestions
2. **Request improvements:** "Make this thread-safe" or "Add error handling"
3. **Specify constraints:** Include security requirements in your prompts
4. **Use validation:** Ask Copilot to review its own output for issues
5. **Test thoroughly:** Generated code should go through normal testing

Example prompt for secure code:
```
Generate this function with:
- Input validation for all parameters
- Bounds checking on buffer access
- No dynamic allocation
- Error codes for failure cases
```

---

## Summary: Key Takeaways

### 1. Three Modes for Three Purposes
- **Ask Mode:** Questions and exploration (Chat view)
- **Edit Mode:** Targeted code changes (Ctrl+I)
- **Agent Mode:** Complex autonomous tasks

### 2. Chat Participants Extend Capabilities
- `@workspace` for project-wide context
- `@terminal` for shell and build help
- `@vscode` for IDE configuration
- `@github` for repository integration

### 3. Slash Commands Accelerate Common Tasks
- `/doc` - Generate documentation
- `/explain` - Understand code
- `/fix` - Resolve errors
- `/tests` - Create unit tests

### 4. Context is King
- Use `#file:` to reference specific files
- Provide constraints and requirements
- Iterate with follow-up questions

### 5. Practice Makes Perfect
- Start with Ask Mode to explore
- Progress to Edit Mode for changes
- Graduate to Agent Mode for complex tasks

---

*Lesson 2: Basic Feature Overview - GitHub Copilot in VS Code*  
*Last Updated: January 2026*
