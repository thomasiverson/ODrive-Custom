# Lesson 7: GitHub Copilot CLI

**Session Duration:** 45 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows PowerShell 7+  
**Source Control:** Git (Bitbucket or GitHub remote)

---

## Overview

This lesson teaches you how to use GitHub Copilot CLI to interact with your codebase using natural language, explain code, generate files, and run shell commands—all from an interactive terminal session.

**What You'll Learn:**
- Install and authenticate GitHub Copilot CLI
- Use slash commands (`/help`, `/model`, `/compact`)
- Reference files with `@path\file` syntax
- Run shell commands with `!` prefix
- Generate and modify code with approval workflow

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **Interactive Session** | `copilot` starts a conversational CLI session |
| **File References** | `@path\file` focuses Copilot on specific files |
| **Shell Commands** | `!command` runs shell commands directly |
| **Programmatic Mode** | `copilot -p "prompt"` for single prompts |
| **Slash Commands** | `/help`, `/model`, `/login`, `/compact` |

---

## Agenda

| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Installation | Install Copilot CLI via winget | 5 min |
| Authentication | GitHub auth and directory trust | 3 min |
| Core Features Demo | Slash commands, file refs, shell | 12 min |
| Hands-On Exercises | Interactive CLI practice | 15 min |
| Wrap-up | Quick reference and Q&A | 10 min |

**Total Time:** 45 minutes

---

## Table of Contents

- [Overview](#overview)
- [Agenda](#agenda)
- [Prerequisites](#prerequisites)
- [Why Copilot CLI Matters](#why-copilot-cli-matters)
- [Learning Path](#learning-path)
- [Section 1: Installation](#section-1-installation-5-min)
- [Section 2: Presenter Demo Script](#section-2-presenter-demo-script-20-min)
- [Section 3: Installation Guide (Participants)](#section-3-installation-guide-for-participants)
- [Section 4: Authentication & First Launch](#section-4-authentication--first-launch)
- [Section 5: Command Reference](#section-5-command-reference)
- [Section 6: Participant Exercises](#section-6-participant-exercises-15-min)
- [Section 7: Quick Reference Card](#section-7-quick-reference-card)
- [Section 8: Troubleshooting](#section-8-troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)
- [Next Steps](#next-steps)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **PowerShell 7+** installed (not Windows PowerShell 5.1)
- ✅ **GitHub Copilot subscription** - Active Copilot license
- ✅ **GitHub account** - For authentication
- ✅ **Git installed** - For repository operations
- ✅ **VS Code** with integrated terminal (optional, but recommended)

### Important Note

Copilot CLI authenticates with **GitHub.com** to access the AI service. This works regardless of where your code is hosted (Bitbucket, GitLab, local git). You need a GitHub account with an active Copilot subscription.

### Verify Your Setup

1. **Check PowerShell version:**
   ```powershell
   $PSVersionTable.PSVersion
   # Expected: Major version 7 or higher
   ```

2. **If version < 7, upgrade:**
   ```powershell
   winget install Microsoft.PowerShell
   ```

3. **Open PowerShell 7:**
   ```powershell
   pwsh
   ```

---

## Why Copilot CLI Matters

Copilot CLI provides an interactive AI assistant directly in your terminal, enabling natural language interactions with your codebase.

### Common Pain Points Solved

| Challenge | Without Copilot CLI | With Copilot CLI |
|-----------|---------------------|------------------|
| Understand unfamiliar code | Read files manually, trace calls | `Explain @src\motor_control.cpp` |
| Find patterns in codebase | grep with complex regex | `Find all ISR handlers in Firmware` |
| Generate boilerplate | Copy from templates | `Create @src\logger.c with debug/info/error functions` |
| Run shell commands | Remember exact syntax | `Show me the last 5 commits` → proposes command |

### Benefits for Embedded Development

1. **Code Understanding**
   - Explain complex firmware modules
   - Trace function calls across files
   - Summarize what a codebase does

2. **Code Generation**
   - Create new source files with boilerplate
   - Add functions to existing files
   - Generate Makefiles and build scripts

3. **Shell Integration**
   - Run git commands with `!` prefix
   - Get command suggestions with approval
   - Analyze build outputs and logs

---

## Learning Path

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Installation | Install Copilot CLI via winget | 5 min |
| Authentication | Login and trust directories | 3 min |
| Core Features | Slash commands, @files, !shell | 12 min |
| Hands-On | Interactive exercises | 15 min |

---

## Section 1: Installation (5 min)

### Step 1: Open PowerShell 7

```powershell
pwsh
```

> **Note:** Must be PowerShell 7+, not Windows PowerShell 5.1

### Step 2: Install Copilot CLI

```powershell
winget install GitHub.Copilot
```

### Step 3: Restart PowerShell

Close and reopen PowerShell 7 after installation.

### Step 4: Verify Installation

```powershell
copilot --version
```

> If not found, restart PowerShell or check PATH

### Fallback: Direct Download

If winget fails, download directly from:  
https://github.com/github/copilot-cli/releases

1. Download the Windows executable
2. Extract to a folder (e.g., `C:\Tools\copilot`)
3. Add folder to PATH

---

## Section 2: Presenter Demo Script (20 min)

### Installation Demo (5 min)

1. **Open PowerShell 7** (not Windows PowerShell 5.1)
   ```powershell
   pwsh
   ```

2. **Install Copilot CLI**
   ```powershell
   winget install GitHub.Copilot
   ```

3. **Verify installation**
   ```powershell
   copilot --version
   ```
   > If not found, restart PowerShell

### Authentication Demo (3 min)

1. **Navigate to workshop repo**
   ```powershell
   cd C:\path\to\workshop-repo
   ```

2. **Launch Copilot CLI**
   ```powershell
   copilot
   ```

3. **Authenticate**
   ```
   /login
   ```
   - Copy the device code displayed
   - Open browser to https://github.com/login/device
   - Enter the code
   - Authorize the application
   - Return to terminal — should see "Successfully authenticated!"

4. **Trust the directory**
   - When prompted, choose "Yes, always trust this folder"

### Core Features Demo (12 min)

**Slash Commands (2 min):**
```
/help
```
> Show available commands

```
/model
```
> Show model options, explain Claude Sonnet 4.5 is default

**Basic Prompts (2 min):**
```
What files are in this project?
```

```
Summarize what this codebase does in 3 sentences.
```

**File References (3 min):**
```
Explain @src\main.c
```

```
What functions are defined in @src\utils.c?
```

```
Compare @src\config.h and @src\defaults.h - what's different?
```
> Key point: `@` lets you focus Copilot on specific files

**Shell Commands (3 min):**
```
!git status
```

```
!git log --oneline -5
```
> The `!` prefix runs shell commands directly

```
Show me the last 5 commits
```
> Copilot proposes the command and asks for approval

**Code Generation (2 min):**
```
Create a simple hello world in @src\hello.c
```
> Show approval prompt before file changes
> Demonstrate reviewing the proposed change

---

## Section 3: Installation Guide (For Participants)

### Step 1: Verify PowerShell Version

```powershell
$PSVersionTable.PSVersion
```

If version is less than 6, upgrade:
```powershell
winget install Microsoft.PowerShell
```

Then open PowerShell 7:
```powershell
pwsh
```

### Step 2: Install Copilot CLI

```powershell
winget install GitHub.Copilot
```

Restart PowerShell after installation.

### Step 3: Verify Installation

```powershell
copilot --version
```

### Fallback: Direct Download

If winget fails, download directly from:  
https://github.com/github/copilot-cli/releases

1. Download the Windows executable
2. Extract to a folder (e.g., `C:\Tools\copilot`)
3. Add folder to PATH

---

## Section 4: Authentication & First Launch

### Step 1: Clone the Workshop Repository

```powershell
cd C:\Users\YourName\repos
git clone <workshop-repo-url>
cd workshop-repo
```

### Step 2: Launch Copilot CLI

```powershell
copilot
```

### Step 3: Authenticate

When prompted, run:
```
/login
```

Follow the browser authentication flow:
1. Copy the one-time code
2. Open https://github.com/login/device
3. Enter the code
4. Authorize GitHub Copilot CLI
5. Return to terminal

### Step 4: Trust the Directory

When prompted "Do you trust the files in this folder?":
- **Option 1:** Yes, for this session only
- **Option 2:** Yes, always trust this folder ← Recommended for your projects
- **Option 3:** No

---

## Section 5: Command Reference

| Command | Purpose |
|---------|---------|
| `copilot` | Start interactive session |
| `copilot -p "prompt"` | Single prompt, then exit |
| `/help` | List available slash commands |
| `/model` | Change AI model |
| `/compact` | Compress conversation context |
| `/login` | Authenticate with GitHub |
| `@path\file` | Reference specific file in prompt |
| `!command` | Run shell command directly |
| `--allow-tool 'shell(git)'` | Pre-approve a tool (programmatic mode) |
| `--deny-tool 'shell(rm)'` | Block a tool (programmatic mode) |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/help` | Show all available commands |
| `/model` | View or change AI model |
| `/compact` | Compress conversation to reduce context |
| `/login` | Authenticate with GitHub |
| `/clear` | Clear conversation history |

### File References with @ Syntax

Reference specific files in your prompts:

```
Explain @src\main.c
```

```
What functions are defined in @src\utils.c?
```

```
Compare @src\config.h and @src\defaults.h - what's different?
```

> **Key point:** The `@` prefix lets you focus Copilot on specific files

### Shell Commands with ! Prefix

Run shell commands directly:

```
!git status
```

```
!git log --oneline -5
```

> **Key point:** The `!` prefix runs shell commands directly

### Programmatic Mode

Run a single prompt without interactive session:

```powershell
copilot -p "How many lines of code are in src\?" --allow-tool 'shell(find)'
```

```powershell
copilot -p "List all TODO comments in this project" --allow-tool 'shell(grep)'
```

**Tool Control Flags:**
- `--allow-tool 'shell(git)'` — Pre-approve git commands
- `--deny-tool 'shell(rm)'` — Block dangerous commands

---

## Section 6: Participant Exercises (15 min)

### Exercise 1: Get Oriented (3 min)

**Goal:** Familiarize yourself with the CLI interface

1. Launch Copilot in the workshop repo:
   ```powershell
   cd C:\path\to\workshop-repo
   copilot
   ```

2. Explore available commands:
   ```
   /help
   ```

3. Check available models:
   ```
   /model
   ```

4. Ask about the project:
   ```
   What is this project and what does it do?
   ```

5. Get a summary:
   ```
   Summarize what this codebase does in 3 sentences.
   ```

**What to observe:** Copilot analyzes the codebase and provides a summary.

---

### Exercise 2: Explore Files (4 min)

**Goal:** Use file references to analyze code

1. Get an explanation of a file:
   ```
   Explain @src\main.c
   ```

2. Find functions in a file:
   ```
   What functions are defined in @src\utils.c?
   ```

3. Compare two files:
   ```
   Compare @src\config.h and @src\defaults.h - what are the differences?
   ```

**What to observe:** Copilot reads the files and provides detailed analysis.

---

### Exercise 3: Generate Code (4 min)

**Goal:** Have Copilot create and modify code

1. Add a function to an existing file:
   ```
   Add a function to @src\utils.c that calculates factorial of an integer
   ```
   - Review the proposed change
   - Approve or reject

2. Create a new file:
   ```
   Create @src\logger.c with functions for debug, info, and error logging
   ```
   - Review the generated code
   - Approve to create the file

**What to observe:** Copilot always asks for approval before modifying files.

---

### Exercise 4: Git & Shell Integration (4 min)

**Goal:** Use Copilot to run commands and analyze git history

1. Run a git command directly:
   ```
   !git log --oneline -5
   ```

2. Ask Copilot to analyze git history:
   ```
   Show me what files changed in the last commit
   ```

3. Get code statistics:
   ```
   How many lines of code are in the src\ directory?
   ```

**What to observe:** Copilot proposes shell commands and asks for approval before running them.

---

## Section 7: Quick Reference Card

### Essential Commands

| You Type | What Happens |
|----------|--------------|
| `copilot` | Start interactive session |
| `/help` | List commands |
| `/model` | Change AI model |
| `/compact` | Reduce context size |
| `/login` | Authenticate |
| `@file.c` | Reference a file |
| `!git status` | Run shell command |

### Common Prompts

```
Explain @filename
```
```
Summarize what this codebase does in 3 sentences.
```
```
Fix bugs in @filename
```
```
Create @path\newfile.c with...
```
```
Add a function to @filename that...
```
```
Compare @file1 and @file2
```
```
Show me the git history
```
```
What changed in the last commit?
```
```
Generate a Makefile for this project
```

### Programmatic Mode

```powershell
copilot -p "your prompt here" --allow-tool 'shell(git)'
```

---

## Section 8: Troubleshooting

| Issue | Solution |
|-------|----------|
| `copilot` not recognized | Restart PowerShell; check if install completed |
| PowerShell version < 6 | Run: `winget install Microsoft.PowerShell` |
| winget not found | Install "App Installer" from Microsoft Store |
| Authentication fails | Verify Copilot subscription at github.com/settings/copilot |
| "Not authenticated" error | Run `/login` and complete browser flow |
| Directory not trusted | Approve when prompted, or restart session in trusted folder |
| Slow responses | Use `/compact` to reduce context size |
| Wrong file being modified | Review carefully before approving; use full path with `@` |

### Getting Help

- Official docs: https://docs.github.com/en/copilot/github-copilot-in-the-cli
- Check version: `copilot --version`
- Submit feedback: `/feedback` in the CLI

---

## Additional Resources

### Microsoft Learn
- [GitHub Copilot CLI Tutorial](https://learn.microsoft.com/training/modules/use-github-copilot-cli/)

### GitHub Documentation
- [Copilot in the CLI Docs](https://docs.github.com/en/copilot/github-copilot-in-the-cli) — Official documentation
- [Copilot CLI Releases](https://github.com/github/copilot-cli/releases)

### Video Tutorials
- [GitHub Copilot CLI in Action](https://www.youtube.com/watch?v=fHwtrOcLAnI)

---

## Frequently Asked Questions

### Q: Does Copilot CLI work offline?

**Short Answer:** No, it requires an internet connection.

**Detailed Explanation:**
Copilot CLI sends your natural language query to GitHub's servers for processing. The AI model runs in the cloud and returns responses. For offline work, you'll need to use traditional command references or save commonly used commands in scripts.

---

### Q: Can Copilot CLI execute commands automatically?

**Short Answer:** Shell commands with `!` run directly. Other commands require approval.

**Detailed Explanation:**
- Commands prefixed with `!` (like `!git status`) run immediately
- When Copilot suggests a command based on your natural language query, it asks for approval first
- File modifications always require approval before being applied

This prevents accidental execution of dangerous commands.

---

### Q: How do I get better responses?

**Short Answer:** Be specific and use file references.

**Detailed Explanation:**
- **Vague:** `Explain the code`
- **Better:** `Explain @src\motor_control.cpp`
- **Best:** `Explain the calibration function in @src\motor_control.cpp`

Include:
- File paths with `@` prefix
- Specific function or class names
- What you want to understand or generate

---

### Q: Can I use Copilot CLI in VS Code's terminal?

**Short Answer:** Yes, it works in VS Code's integrated terminal.

**Detailed Explanation:**
Copilot CLI works in any PowerShell 7+ terminal:
- VS Code integrated terminal
- Windows Terminal
- PowerShell 7 standalone

Launch with `copilot` from any of these terminals.

---

### Q: What's the difference between Copilot CLI and Copilot Chat in VS Code?

**Short Answer:** CLI is terminal-based and interactive; Chat is editor-integrated.

**Detailed Explanation:**

| Feature | Copilot CLI | Copilot Chat in VS Code |
|---------|-------------|-------------------------|
| Interface | Terminal | Editor sidebar |
| File References | `@path\file` | `#file:path` |
| Shell Commands | `!command` or natural language | `@terminal` agent |
| Code Edits | Approval workflow | Inline suggestions |
| Best For | Terminal workflows, shell commands | Code editing, refactoring |

Use Copilot CLI when working in the terminal; use Copilot Chat when editing code in VS Code.

---

## Summary: Key Takeaways

### 1. Interactive Session
- Start with `copilot` command
- Use slash commands: `/help`, `/model`, `/compact`, `/login`
- Exit with `exit` or Ctrl+C

### 2. File References
- Use `@path\file` to focus on specific files
- Copilot reads the file content for context
- Works with explain, compare, and generate operations

### 3. Shell Integration
- `!command` runs shell commands directly
- Natural language queries suggest commands with approval
- Great for git operations and build commands

### 4. Code Generation
- Create new files: `Create @path\newfile.c with...`
- Modify existing: `Add a function to @filename that...`
- Always review before approving changes

### 5. Safety First
- File modifications require approval
- Use `--deny-tool` flags for dangerous commands
- Review suggested commands before executing

---

## Next Steps

After completing this lesson:

1. **Practice daily** - Use Copilot CLI for exploring unfamiliar code

2. **Learn the shortcuts** - Master `@` for files and `!` for shell commands

3. **Try programmatic mode** - Use `copilot -p "prompt"` in scripts

4. **Combine with VS Code Copilot** - Use CLI for terminal tasks, VS Code Copilot for code editing

5. **Create aliases** - Consider PowerShell aliases for common workflows:
   ```powershell
   function cpl { copilot }
   ```

6. **Share with team** - Show colleagues how to use Copilot CLI for code exploration

---

*Lesson 7: GitHub Copilot CLI*  
*Last Updated: January 2026*
