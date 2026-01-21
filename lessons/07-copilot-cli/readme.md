# GitHub Copilot CLI Reference Guide

**Session Duration:** 45 minutes  
**Audience:** C++ Embedded Systems Developers  
**Environment:** Windows PowerShell 7+  
**Source Control:** Git (Bitbucket or GitHub remote)

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

### Important Note

Copilot CLI authenticates with **GitHub.com** to access the AI service. This works regardless of where your code is hosted (Bitbucket, GitLab, local git). You need a GitHub account with an active Copilot subscription.

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

### Programmatic Mode

Run a single prompt without interactive session:

```powershell
copilot -p "How many lines of code are in src\?" --allow-tool 'shell(find)'
```

```powershell
copilot -p "List all TODO comments in this project" --allow-tool 'shell(grep)'
```

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

*GitHub Copilot CLI Reference Guide*