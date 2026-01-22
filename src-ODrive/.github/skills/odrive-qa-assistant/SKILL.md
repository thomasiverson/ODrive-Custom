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
**Requires:** 
- `tup` build tool installed
- ARM GCC toolchain (arm-none-eabi-gcc)
- Python virtual environment (optional but recommended)

**Features:**
- Automatically detects ARM GCC and tup in PATH
- Updates `tup.config` with correct board version
- Generates required `version.c` file
- Displays binary size information
- Lists output files (.elf, .bin, .hex)
- Supports Windows, Linux, macOS

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

### Using Python Scripts (Preferred)

All helper scripts are located in `.github/skills/odrive-qa-assistant/scripts/`:

**1. Build Firmware**
```bash
# Check build environment
python .github/skills/odrive-qa-assistant/scripts/build_firmware.py --check-tools

# List available board configurations
python .github/skills/odrive-qa-assistant/scripts/build_firmware.py --list-configs

# Build firmware for specific board
python .github/skills/odrive-qa-assistant/scripts/build_firmware.py board-v3.6-56V

# Clean build (removes build/ and autogen/ directories first)
python .github/skills/odrive-qa-assistant/scripts/build_firmware.py board-v3.5-24V --clean
```

**Windows with Virtual Environment:**
```powershell
# Activate venv and set PATH for tools
& venv\Scripts\Activate.ps1
$env:PATH = "C:\path\to\tup;C:\path\to\arm-gcc\bin;$env:PATH"
python .github\skills\odrive-qa-assistant\scripts\build_firmware.py board-v3.6-56V
```

**2. Search for Symbols**
```bash
python .github/skills/odrive-qa-assistant/scripts/search_symbol.py Motor::update
python .github/skills/odrive-qa-assistant/scripts/search_symbol.py "ERROR_*" --regex
python .github/skills/odrive-qa-assistant/scripts/search_symbol.py Encoder --type class
```

**3. List Error Codes**
```bash
python .github/skills/odrive-qa-assistant/scripts/list_errors.py
python .github/skills/odrive-qa-assistant/scripts/list_errors.py --filter encoder
python .github/skills/odrive-qa-assistant/scripts/list_errors.py --format table
```

**4. Run Tests**
```bash
python tools/run_tests.py
python tools/run_tests.py --test encoder_test
```

### Manual Commands (Alternative)

```bash
# Build firmware directly
cd Firmware && make CONFIG=board-v3.6-56V

# Search symbols with grep
grep -rn "Axis::step_cb" Firmware/

# List error codes
grep -A 5 "error_code" Firmware/odrive-interface.yaml
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
