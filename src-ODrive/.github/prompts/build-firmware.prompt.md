# Build Firmware

Build ODrive firmware for specific board variants and configurations.

## Instructions

Use the **odrive-qa-assistant** skill to build firmware with proper board configuration.

### Input Required
- **Board Variant**: ${{BOARD_CONFIG}} (e.g., "board-v3.6-56V", "board-v3.5-24V", "board-v4.2")
- **Build Type**: ${{BUILD_TYPE}} (optional: "release", "debug", default: "release")

### What This Prompt Does

1. **Validates board configuration** exists in Makefile
2. **Builds firmware** for specified board variant
3. **Reports build status** (success/failure)
4. **Lists output files** (firmware binary location)
5. **Checks for warnings** and reports issues

### Commands

```bash
# Build for specific board variant
cd Firmware && make CONFIG=board-v3.6-56V

# Clean build
cd Firmware && make clean

# Build all variants (CI mode)
cd Firmware && make all-boards

# Check available configurations
grep "CONFIG.*board" Firmware/Makefile

# Build with verbose output
cd Firmware && make CONFIG=board-v3.6-56V V=1
```

### Available Board Variants

| Board | Config String | Voltage | Notes |
|-------|--------------|---------|-------|
| **v3.6** | `board-v3.6-56V` | 56V | Current production |
| **v3.5** | `board-v3.5-24V` `board-v3.5-48V` | 24V/48V | Legacy |
| **v4.2** | `board-v4.2` | 56V | Future |

### Prerequisites

- Firmware build toolchain installed (ARM GCC)
- Make build system
- Firmware source code

### Example Usage

Build for v3.6 board:
```
@odrive-qa Build firmware for board v3.6
```

Build multiple variants:
```
@odrive-qa Build firmware for both v3.5-24V and v3.6-56V boards
```

Clean and rebuild:
```
@odrive-qa Clean build directory and rebuild firmware for board v3.6
```

Check build system:
```
@odrive-qa List all available board configurations
```

### Output

**On Success:**
- ✅ Build completed successfully
- 📦 Binary location: `Firmware/build/{config}/ODriveFirmware.elf`
- 📊 Build statistics (size, warnings)
- 🎯 Ready to flash or test

**On Failure:**
- ❌ Build errors with file/line numbers
- 💡 Suggested fixes
- 🔍 Common causes of build failures

### Build Workflow

```
1. Navigate to Firmware directory
        ↓
2. Invoke make with CONFIG
        ↓
3. Toolchain compiles source
        ↓
4. Linker creates binary
        ↓
5. Post-build size report
        ↓
6. Output: ODriveFirmware.elf
```

### Skills Invoked

| Skill | Purpose |
|-------|---------|
| **odrive-qa-assistant** | Execute build commands, report results |
| **ODrive-Engineer** | Fix build errors if needed |

### Common Build Issues

| Error | Cause | Fix |
|-------|-------|-----|
| `arm-none-eabi-gcc: not found` | Toolchain not installed | Install ARM GCC toolchain |
| `fatal error: *.h: No such file` | Missing header/include path | Check include directories |
| `undefined reference to...` | Missing implementation | Check linker settings |
| `region 'FLASH' overflowed` | Binary too large | Optimize code size |

### Post-Build Actions

After successful build:
- [ ] Check binary size fits in flash
- [ ] Verify no new warnings introduced
- [ ] Run unit tests: `python tools/run_tests.py`
- [ ] **DO NOT** auto-flash to hardware (requires confirmation)

### Related Prompts

| Need | Use |
|------|-----|
| Run tests | `generate-doctest.prompt.md` |
| Deploy firmware | Use devops-engineer skill |
| Debug build errors | `debug-motor-error-v2.prompt.md` |
| Optimize binary size | `optimize-critical.prompt.md` |

### Safety Note

⚠️ **Building firmware is SAFE** - it compiles locally and does not affect hardware.  
⚠️ **Flashing firmware requires confirmation** - see constitution safety rules.
