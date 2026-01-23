# Lesson 7: GitHub Copilot CLI

**Session Duration:** 30 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows, VS Code, Terminal  
**Extensions:** GitHub Copilot, GitHub Copilot CLI  
**Source Control:** GitHub/Bitbucket

---

## Overview

This lesson teaches you how to use GitHub Copilot CLI to transform natural language into shell commands, explain complex commands, and streamline development workflows. You'll practice generating build commands, Git operations, and navigation tasks directly from the terminal.

**What You'll Learn:**
- Install and authenticate GitHub Copilot CLI
- Use `gh copilot suggest` to generate commands from natural language
- Use `gh copilot explain` to understand complex commands
- Create shell aliases for quick access to Copilot CLI

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **gh copilot suggest** | Generate shell commands from natural language |
| **gh copilot explain** | Explain what a command does in plain English |
| **-t flag** | Target shell type: shell, gh, git |
| **Shell Aliases** | Shortcuts like `??` and `git?` for faster access |

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Why Copilot CLI Matters](#why-copilot-cli-matters)
- [Learning Path](#learning-path)
- [Installation](#1-installation-5-min)
- [Authentication](#2-authentication-3-min)
- [Command Reference](#3-command-reference-7-min)
- [Hands-On Exercises](#4-hands-on-exercises-15-min)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **GitHub CLI installed** - `gh` command available in terminal
- ✅ **GitHub Copilot subscription** - Active Copilot license
- ✅ **Terminal access** - PowerShell, CMD, or Git Bash on Windows
- ✅ **VS Code** with integrated terminal

### Verify Your Setup

1. **Check GitHub CLI is installed:**
   ```powershell
   gh --version
   # Expected: gh version 2.x.x
   ```

2. **Check GitHub CLI authentication:**
   ```powershell
   gh auth status
   # Expected: Logged in to github.com as [username]
   ```

3. **Check Copilot CLI is available:**
   ```powershell
   gh copilot --help
   # If not found, see Installation section
   ```

---

## Why Copilot CLI Matters

Copilot CLI bridges natural language and shell commands, reducing friction for complex operations.

### Common Pain Points Solved

| Challenge | Without Copilot CLI | With Copilot CLI |
|-----------|---------------------|------------------|
| Complex git commands | Google → Stack Overflow → copy/paste | `gh copilot suggest "squash last 3 commits"` |
| Build system flags | Read documentation | `gh copilot suggest "build with debug symbols"` |
| Find files | Remember `find` syntax | `gh copilot suggest "find all .cpp files modified today"` |
| Explain inherited scripts | Decode manually | `gh copilot explain "tar -xzvf"` |

### Benefits for Embedded Development

1. **Build Commands**
   - Generate CMake/Make commands with correct flags
   - Cross-compilation toolchain setup
   - Firmware flashing commands

2. **Git Workflows**
   - Branch management for feature development
   - Cherry-pick and rebase operations
   - Submodule management

3. **Navigation & Search**
   - Find symbol definitions across codebase
   - Search for patterns in firmware files
   - List files by type, date, or size

---

## Learning Path

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Installation | Install Copilot CLI extension | 5 min |
| Authentication | Authorize Copilot CLI | 3 min |
| Command Reference | suggest, explain, aliases | 7 min |
| Hands-On Exercises | Generate real commands | 15 min |

---

## 1. Installation (5 min)

### Install GitHub CLI (if needed)

**Windows (winget):**
```powershell
winget install GitHub.cli
```

**Windows (Chocolatey):**
```powershell
choco install gh
```

**Verify installation:**
```powershell
gh --version
```

### Install Copilot CLI Extension

```powershell
gh extension install github/gh-copilot
```

**Verify installation:**
```powershell
gh copilot --help
```

### Update Copilot CLI

```powershell
gh extension upgrade gh-copilot
```

---

## 2. Authentication (3 min)

### Authenticate GitHub CLI

If not already authenticated:

```powershell
gh auth login
```

Follow the prompts:
1. Select `GitHub.com`
2. Select `HTTPS`
3. Select `Login with a web browser`
4. Copy the one-time code
5. Press Enter to open browser
6. Paste code and authorize

### Verify Copilot Access

```powershell
gh copilot suggest "list files"
```

If you see a command suggestion, authentication is working.

---

## 3. Command Reference (7 min)

### gh copilot suggest

Generate shell commands from natural language.

**Syntax:**
```
gh copilot suggest "<natural language query>"
```

**Target Types (-t flag):**

| Flag | Description | Example |
|------|-------------|---------|
| `-t shell` | General shell commands | `find`, `grep`, `ls` |
| `-t git` | Git commands | `git checkout`, `git rebase` |
| `-t gh` | GitHub CLI commands | `gh pr create`, `gh issue list` |

**Examples:**
```powershell
# Shell command
gh copilot suggest "find all .cpp files larger than 100KB"

# Git command
gh copilot suggest -t git "undo last commit but keep changes"

# GitHub CLI command
gh copilot suggest -t gh "create a pull request to main"
```

### gh copilot explain

Explain what a command does in plain English.

**Syntax:**
```
gh copilot explain "<command to explain>"
```

**Examples:**
```powershell
# Explain complex command
gh copilot explain "git rebase -i HEAD~5"

# Explain piped commands
gh copilot explain "find . -name '*.cpp' | xargs grep -l 'volatile'"

# Explain build command
gh copilot explain "arm-none-eabi-gcc -mcpu=cortex-m4 -mfloat-abi=hard"
```

### Shell Aliases (Recommended)

Set up aliases for faster access.

**PowerShell (add to $PROFILE):**
```powershell
function ?? { gh copilot suggest $args }
function git? { gh copilot suggest -t git $args }
function gh? { gh copilot suggest -t gh $args }
function explain { gh copilot explain $args }
```

**Bash/Zsh (add to .bashrc or .zshrc):**
```bash
alias '??'='gh copilot suggest'
alias 'git?'='gh copilot suggest -t git'
alias 'gh?'='gh copilot suggest -t gh'
alias 'explain'='gh copilot explain'
```

**Usage after aliases:**
```powershell
?? "list all running processes"
git? "show commits from last week"
explain "tar -xzvf archive.tar.gz"
```

---

## 4. Hands-On Exercises (15 min)

### Exercise 1: Navigation Commands (3 min)

Generate commands to navigate the ODrive codebase.

**Tasks:**
```powershell
# Find all header files in Firmware
gh copilot suggest "find all .hpp files in src-ODrive/Firmware"

# Find large files
gh copilot suggest "find files larger than 500KB in current directory"

# List recently modified files
gh copilot suggest "list files modified in last 24 hours"
```

### Exercise 2: Search Commands (3 min)

Generate commands to search for code patterns.

**Tasks:**
```powershell
# Find volatile usage
gh copilot suggest "search for 'volatile' in all .cpp files"

# Find TODO comments
gh copilot suggest "find all TODO comments in src-ODrive"

# Find function definitions
gh copilot suggest "search for 'void run_' function definitions in .cpp files"
```

### Exercise 3: Git Commands (4 min)

Generate Git commands for common workflows.

**Tasks:**
```powershell
# Interactive rebase
gh copilot suggest -t git "squash last 3 commits into one"

# Branch comparison
gh copilot suggest -t git "show commits in current branch not in main"

# Find commit by message
gh copilot suggest -t git "find commit that added 'calibration'"

# Undo changes
gh copilot suggest -t git "discard all changes in Firmware folder"
```

### Exercise 4: Build Commands (3 min)

Generate build and toolchain commands.

**Tasks:**
```powershell
# CMake configuration
gh copilot suggest "configure cmake with debug build type"

# Clean build
gh copilot suggest "delete all build artifacts and rebuild"

# Parallel make
gh copilot suggest "run make with maximum parallel jobs"
```

### Exercise 5: Explain Complex Commands (2 min)

Explain commands you encounter in the codebase.

**Tasks:**
```powershell
# Explain make command
gh copilot explain "make -j$(nproc) BOARD=v3.6"

# Explain linker flags
gh copilot explain "-Wl,--gc-sections -Wl,-Map=output.map"

# Explain git command
gh copilot explain "git log --oneline --graph --all --decorate"
```

---

## Practice Exercises

### Exercise 1: Daily Workflow Commands
**Goal:** Generate commands for your typical workflow

<details>
<summary>📋 Instructions</summary>

1. Generate a command to check your Git status with short format
2. Generate a command to show branch history graphically
3. Generate a command to find all files you modified today

**Prompts to use:**
```powershell
gh copilot suggest -t git "show status in short format"
gh copilot suggest -t git "show branch history as graph with one line per commit"
gh copilot suggest "find files modified by me today"
```

**Success Criteria:**
- ✅ Commands execute correctly
- ✅ Output matches expectations
</details>

<details>
<summary>💡 Solution</summary>

```powershell
# Short status
git status -s

# Graph history
git log --oneline --graph --all

# Files modified today (PowerShell)
Get-ChildItem -Recurse | Where-Object { $_.LastWriteTime -gt (Get-Date).Date }

# Files modified today (Bash)
find . -mtime 0 -type f
```
</details>

---

### Exercise 2: Build System Commands
**Goal:** Generate embedded build commands

<details>
<summary>📋 Instructions</summary>

1. Generate a command to build with GCC with all warnings as errors
2. Generate a command to show the size of each section in an ELF file
3. Generate a command to flash firmware using OpenOCD

**Prompts to use:**
```powershell
gh copilot suggest "compile with gcc and treat all warnings as errors"
gh copilot suggest "show section sizes of ELF binary"
gh copilot suggest "flash STM32 firmware using openocd"
```

**Success Criteria:**
- ✅ Correct flags generated
- ✅ Commands are valid syntax
</details>

<details>
<summary>💡 Solution</summary>

```bash
# GCC with warnings as errors
gcc -Wall -Werror -o output input.c

# Show ELF section sizes
arm-none-eabi-size -A firmware.elf

# Flash with OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program firmware.elf verify reset exit"
```
</details>

---

### Exercise 3: Code Search Commands
**Goal:** Find code patterns in the ODrive codebase

<details>
<summary>📋 Instructions</summary>

1. Find all uses of `set_error` function
2. Find all ISR handlers (functions ending in `_IRQHandler`)
3. Find all static_assert statements

**Prompts to use:**
```powershell
gh copilot suggest "search for 'set_error' in all cpp files under src-ODrive"
gh copilot suggest "find functions ending with _IRQHandler in .cpp files"
gh copilot suggest "search for static_assert in header files"
```

**Success Criteria:**
- ✅ Correct grep/find syntax
- ✅ Results found in ODrive codebase
</details>

<details>
<summary>💡 Solution</summary>

```bash
# Find set_error usage
grep -rn "set_error" src-ODrive --include="*.cpp"

# Find IRQ handlers
grep -rn "_IRQHandler" src-ODrive --include="*.cpp"

# Find static_assert
grep -rn "static_assert" src-ODrive --include="*.hpp" --include="*.h"
```
</details>

---

## Quick Reference

### Command Syntax

| Command | Purpose | Example |
|---------|---------|---------|
| `gh copilot suggest "<query>"` | Generate command | `gh copilot suggest "list files"` |
| `gh copilot suggest -t git` | Git commands | `gh copilot suggest -t git "undo commit"` |
| `gh copilot suggest -t gh` | GitHub CLI | `gh copilot suggest -t gh "create PR"` |
| `gh copilot explain "<cmd>"` | Explain command | `gh copilot explain "git rebase -i"` |

### Recommended Aliases

| Alias | Expands To | Purpose |
|-------|------------|---------|
| `??` | `gh copilot suggest` | Quick suggest |
| `git?` | `gh copilot suggest -t git` | Git commands |
| `gh?` | `gh copilot suggest -t gh` | GitHub CLI |
| `explain` | `gh copilot explain` | Explain commands |

### Common Queries by Category

**Navigation:**
- "list files by size"
- "find files modified in last week"
- "show directory tree"

**Search:**
- "search for pattern in files"
- "find all occurrences of function"
- "count lines matching pattern"

**Git:**
- "undo last commit"
- "show diff between branches"
- "create branch from tag"

**Build:**
- "compile with debug symbols"
- "run make in parallel"
- "clean build directory"

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `gh copilot: command not found` | Extension not installed | `gh extension install github/gh-copilot` |
| `authentication required` | Not logged in | `gh auth login` |
| `no Copilot access` | License issue | Check Copilot subscription status |
| Alias not working | Not in profile | Add to `$PROFILE` (PowerShell) or `.bashrc` |
| Wrong command type | Need -t flag | Use `-t git` or `-t gh` for specific commands |

### PowerShell Profile Location

```powershell
# Find profile path
echo $PROFILE

# Create profile if it doesn't exist
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }

# Edit profile
notepad $PROFILE
```

### Verify Extension Installation

```powershell
# List installed extensions
gh extension list

# Should show: github/gh-copilot
```

---

## Additional Resources

### Microsoft Learn
- [GitHub Copilot CLI Tutorial](https://learn.microsoft.com/training/modules/use-github-copilot-cli/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

### GitHub Documentation
- [Copilot CLI Extension](https://github.com/github/gh-copilot)
- [GitHub CLI Quickstart](https://docs.github.com/en/github-cli/github-cli/quickstart)

### Video Tutorials
- [GitHub Copilot CLI in Action](https://www.youtube.com/watch?v=fHwtrOcLAnI)

---

## Frequently Asked Questions

### Q: Does Copilot CLI work offline?

**Short Answer:** No, it requires an internet connection.

**Detailed Explanation:**
Copilot CLI sends your natural language query to GitHub's servers for processing. The AI model runs in the cloud and returns command suggestions. For offline work, you'll need to use traditional command references or save commonly used commands in scripts.

---

### Q: Can Copilot CLI execute commands automatically?

**Short Answer:** No, it only suggests commands. You must confirm execution.

**Detailed Explanation:**
Copilot CLI is designed for safety. After suggesting a command, it presents options:
- **Copy to clipboard** - Paste and review before running
- **Execute** - Run in current shell (requires confirmation)
- **Revise** - Modify the query and try again

This prevents accidental execution of dangerous commands.

---

### Q: How do I get better suggestions?

**Short Answer:** Be specific and include context.

**Detailed Explanation:**
- **Bad:** `gh copilot suggest "delete files"`
- **Better:** `gh copilot suggest "delete all .o object files in build directory"`
- **Best:** `gh copilot suggest "recursively delete all .o files in src-ODrive/Firmware/build"`

Include:
- File types or extensions
- Directory paths
- Specific tool preferences (grep vs ripgrep)
- Desired output format

---

### Q: Can I use Copilot CLI in my IDE terminal?

**Short Answer:** Yes, it works in VS Code's integrated terminal.

**Detailed Explanation:**
Copilot CLI works in any terminal where `gh` is available:
- VS Code integrated terminal
- Windows Terminal
- PowerShell
- Git Bash
- WSL

The suggest and explain commands work the same regardless of where you run them.

---

### Q: What's the difference between Copilot CLI and Copilot in VS Code?

**Short Answer:** CLI is for shell commands; VS Code Copilot is for code.

**Detailed Explanation:**

| Feature | Copilot CLI | Copilot in VS Code |
|---------|-------------|-------------------|
| Primary Use | Generate shell commands | Generate/edit code |
| Interface | Terminal | Editor |
| Output | Commands to run | Code to insert |
| Languages | Bash, PowerShell, etc. | Any programming language |
| Explain | Explains commands | Explains code |

Use Copilot CLI when working in the terminal; use VS Code Copilot when editing code.

---

## Summary: Key Takeaways

### 1. Two Core Commands
- **`gh copilot suggest`** - Generate commands from natural language
- **`gh copilot explain`** - Understand complex commands

### 2. Target Types
- **-t shell** - General shell commands (default)
- **-t git** - Git-specific commands
- **-t gh** - GitHub CLI commands

### 3. Productivity Aliases
- Set up `??`, `git?`, `gh?`, `explain` for faster access
- Add to shell profile for persistence

### 4. Effective Queries
- Be specific about file types and paths
- Include tool preferences
- Describe desired output format

### 5. Safety First
- Commands are suggested, not auto-executed
- Review before running
- Use explain for unfamiliar commands

---

*Lesson 7: GitHub Copilot CLI*  
*Last Updated: January 2026*
