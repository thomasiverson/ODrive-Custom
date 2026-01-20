---
name: odrive-qa-assistant
description: Helper skill for QA, testing, and workspace inspection for the ODrive firmware repository. Use this when asked to run or explain common project tasks (build, tests, symbol search, interface inspection).
license: MIT
---

# ODrive QA Assistant Skill

This skill provides safe, tested helper scripts for common ODrive repository tasks. Use this skill when users ask to:
- Build firmware for specific board variants
- Run the test suite
- Search for C++ symbols (functions, classes, variables)
- List error flags defined in the interface YAML

## 🔒 Safety First

**NEVER automatically:**
- Flash firmware to hardware
- Modify device configurations
- Execute commands that could damage hardware

If the user requests hardware operations, provide exact commands but ask for explicit confirmation before running.

## 📋 When to Use This Skill

Activate this skill when the user asks questions like:
- "Build the firmware for board v3.6"
- "Where is `Axis::step_cb` defined?"
- "Run the test suite"
- "List all error codes from the YAML interface"
- "Check if the firmware compiles"

## 🛠️ Available Tools

### 1. Symbol Search (`find_symbol`)
**Purpose:** Locate C++ symbols (functions, classes, methods) in the codebase  
**When to use:** Before making changes, to understand where code is defined/used  
**Safe:** ✅ Read-only operation

### 2. Firmware Build (`build_firmware`)
**Purpose:** Compile firmware for a specific board variant using `tup`  
**When to use:** To verify code changes compile without errors  
**Safe:** ✅ Does not flash hardware, only builds locally  
**Requires:** `tup` build tool installed

### 3. Test Runner (`run_tests`)
**Purpose:** Execute the Python-based test harness  
**When to use:** Before submitting PRs, to verify no regressions  
**Safe:** ✅ Runs software tests only  
**Requires:** Python 3 with dependencies installed

### 4. Error Flag Inspector (`list_errors_from_yaml`)
**Purpose:** Parse and list all error flags from `odrive-interface.yaml`  
**When to use:** To understand error codes, ensure docs are up-to-date  
**Safe:** ✅ Read-only YAML parsing

## 📖 Usage Instructions

All scripts are PowerShell-based and run from the repository root:

### 1. Find Symbol
```powershell
.\\.github\\skills\\odrive-qa-assistant\\scripts\\find_symbol.ps1 -Symbol "Axis::step_cb"
```

### 2. Build Firmware
```powershell
.\\.github\\skills\\odrive-qa-assistant\\scripts\\build_firmware.ps1 -Board v3.6
```

### 3. Run Tests
```powershell
.\\.github\\skills\\odrive-qa-assistant\\scripts\\run_tests.ps1
```

### 4. List Error Flags
```powershell
.\\.github\\skills\\odrive-qa-assistant\\scripts\\list_errors_from_yaml.ps1
```

## 🔒 Security & Safety

- Never call scripts that flash or manipulate hardware automatically
- If the user requests flashing, prompt for explicit confirmation
- If Python or tup is missing, provide helpful install instructions

## 🎯 Example Copilot Prompts

- "Use the repository tools to build the firmware for board `v3.6`."
- "Search the workspace for where `Axis::step_cb` is defined and open that file." 
- "List all error flags defined in `Firmware/odrive-interface.yaml`."
- "Run the test suite and show me any failures."
