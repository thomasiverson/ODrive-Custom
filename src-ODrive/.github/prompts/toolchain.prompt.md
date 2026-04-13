# Toolchain Operations

Build, test, search, and error inspection for ODrive firmware.

## Agent: ODrive-Toolchain

### Build Firmware
```powershell
# Setup (once per session)
. .github\skills\odrive-toolchain\setup-env.ps1

# Build for specific board
python .github\skills\odrive-toolchain\build_firmware.py board-v3.6-56V

# Build options
python .github\skills\odrive-toolchain\build_firmware.py --list-configs
python .github\skills\odrive-toolchain\build_firmware.py board-v3.6-56V --clean
python .github\skills\odrive-toolchain\build_firmware.py --check-tools
```

### Available Board Variants

| Board | Config String | Voltage | Notes |
|-------|--------------|---------|-------|
| **v3.6** | `board-v3.6-56V` | 56V | Current production |
| **v3.5** | `board-v3.5-24V` `board-v3.5-48V` | 24V/48V | Legacy |
| **v4.2** | `board-v4.2` | 56V | Future |

### Search Symbols
```powershell
python .github\skills\odrive-toolchain\search_symbol.py Controller
python .github\skills\odrive-toolchain\search_symbol.py "ERROR_" --regex
python .github\skills\odrive-toolchain\search_symbol.py Encoder --type class
```

### List Errors
```powershell
python .github\skills\odrive-toolchain\list_errors.py
python .github\skills\odrive-toolchain\list_errors.py --filter encoder
python .github\skills\odrive-toolchain\list_errors.py --format table
```

### Run Tests
```powershell
python tools/run_tests.py
python tools/run_tests.py --filter encoder
```

---

## Post-Build Checks

- [ ] Binary fits in flash
- [ ] No new warnings introduced
- [ ] **DO NOT** auto-flash firmware

## Safety

- Safe: Build, search, errors, software tests
- Confirm: Flash firmware, HIL tests
