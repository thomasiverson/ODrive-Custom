# ODrive QA Assistant Skill

> A GitHub Copilot Agent Skill for ODrive firmware development, testing, and workspace inspection.

## Overview

This skill provides safe, tested helper scripts that GitHub Copilot agents can use to assist with common ODrive repository tasks. The skill is designed for use with:

- GitHub Copilot coding agent
- GitHub Copilot CLI (`gh copilot`)
- VS Code Insiders (Agent Mode)

## What This Skill Does

The skill helps Copilot understand and execute common ODrive development workflows:

- 🔍 **Symbol Search** - Find where C++ functions, classes, and variables are defined
- 🔨 **Firmware Build** - Compile firmware for specific board variants
- ✅ **Test Execution** - Run the Python test suite
- 📋 **Error Flag Inspection** - List all error codes from the interface YAML

## Installation

This is a **project skill** - it's automatically available when you work in this repository with GitHub Copilot.

No additional installation is needed if you have:
- GitHub Copilot Pro, Pro+, Business, or Enterprise
- VS Code with the GitHub Copilot extension

## Usage

### As a Developer (Manual)

You can run any script directly from the command line:

```bash
# Search for a symbol
./.github/skills/odrive-qa-assistant/scripts/find_symbol.sh "Axis::step_cb"

# Build firmware
./.github/skills/odrive-qa-assistant/scripts/build_firmware.sh v3.6

# Run tests
./.github/skills/odrive-qa-assistant/scripts/run_tests.sh

# List error flags
./.github/skills/odrive-qa-assistant/scripts/list_errors_from_yaml.sh
```

**On Windows (PowerShell):**

```powershell
# Search for a symbol
.\\.github\\skills\\odrive-qa-assistant\\scripts\\find_symbol.ps1 -Symbol "Axis::step_cb"

# Build firmware
.\\.github\\skills\\odrive-qa-assistant\\scripts\\build_firmware.ps1 -Board v3.6

# Run tests
.\\.github\\skills\\odrive-qa-assistant\\scripts\\run_tests.ps1

# List error flags
.\\.github\\skills\\odrive-qa-assistant\\scripts\\list_errors_from_yaml.ps1
```

### With GitHub Copilot Agent

Simply ask Copilot in natural language:

```
@workspace Where is Axis::step_cb defined?
```

```
@workspace Build the firmware for board v3.6
```

```
@workspace Run the test suite and show me any failures
```

```
@workspace List all error flags from the interface YAML
```

Copilot will automatically use the appropriate scripts from this skill.

## Script Reference

| Script | Purpose | Requirements |
|--------|---------|--------------|
| `find_symbol.ps1` | Search for C++ symbols in the codebase | git (optional) |
| `build_firmware.ps1` | Compile firmware using tup | tup, gcc-arm-none-eabi |
| `run_tests.ps1` | Execute Python test suite | Python 3, pytest |
| `list_errors_from_yaml.ps1` | Parse and list error flags | Python 3, PyYAML |

## Safety Features

✅ All scripts are **read-only** or build locally - they never:
- Flash firmware to hardware
- Modify device configurations
- Execute destructive operations

⚠️ If you need to flash firmware or modify hardware, you must do so manually with explicit confirmation.

## Prerequisites

### Required Tools

- **Python 3.7+** - For test runner and YAML parsing
  ```bash
  # Ubuntu/Debian
  sudo apt-get install python3 python3-pip
  
  # macOS
  brew install python3
  ```

- **tup** - For firmware builds
  ```bash
  # Ubuntu/Debian
  sudo apt-get install tup
  
  # macOS
  brew install tup
  ```

- **ARM GCC Toolchain** - For firmware compilation
  ```bash
  # Ubuntu/Debian
  sudo apt-get install gcc-arm-none-eabi
  
  # macOS
  brew install --cask gcc-arm-embedded
  ```

### Python Dependencies

```bash
cd tools
pip install -r requirements.txt
```

## Troubleshooting

### Script Not Found

Ensure you're running scripts from the **repository root directory**:

```powershell
cd C:\src\GHCPC++
.\.github\skills\odrive-qa-assistant\scripts\find_symbol.ps1 -Symbol "symbol"
```

### Execution Policy Error (Windows)

If you get an execution policy error, run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python Module Not Found

Install the PyYAML dependency:

```bash
pip install PyYAML
```

### tup Not Found

Follow the [official tup installation guide](http://gittup.org/tup/) or use your package manager.

## Examples

### Example 1: Investigating an Error

**Task:** User reports `ERROR_PHASE_RESISTANCE_OUT_OF_RANGE`

```powershell
# 1. Find where it's defined
.\.github\skills\odrive-qa-assistant\scripts\list_errors_from_yaml.ps1 | Select-String "PHASE_RESISTANCE"

# 2. Find where it's used in code
.\.github\skills\odrive-qa-assistant\scripts\find_symbol.ps1 -Symbol "PHASE_RESISTANCE_OUT_OF_RANGE"

# 3. Open the relevant files and investigate
```

### Example 2: Pre-Commit Workflow

```powershell
# 1. Build firmware to check for compilation errors
.\.github\skills\odrive-qa-assistant\scripts\build_firmware.ps1

# 2. Run tests to check for regressions
.\.github\skills\odrive-qa-assistant\scripts\run_tests.ps1

# 3. If both pass, proceed with git commit
git add .
git commit -m "feat: Add new motor control parameter"
```

### Example 3: Finding All References

```powershell
# Find where a class is defined and used
.\.github\skills\odrive-qa-assistant\scripts\find_symbol.ps1 -Symbol "class Axis"

# Output shows:
# Firmware/MotorControl/axis.hpp:25: class Axis {
# Firmware/MotorControl/axis.cpp:10: Axis::Axis(...) {
# ...
```

## Contributing

To improve this skill:

1. Edit `SKILL.md` to update instructions for Copilot
2. Add or improve scripts in `scripts/`
3. Test your changes manually and with Copilot
4. Submit a PR with your improvements

## License

MIT License - Same as the ODrive firmware project

## Related Documentation

- [ODrive Documentation](https://docs.odriverobotics.com/)
- [GitHub Copilot Agent Skills](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [ODrive Repository](https://github.com/odriverobotics/ODrive)

---

**Note:** This skill is designed for development use only. Always test firmware changes thoroughly before deploying to production hardware.
