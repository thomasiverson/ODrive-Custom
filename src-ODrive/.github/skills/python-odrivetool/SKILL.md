---
name: python-odrivetool
description: ODrive Python tools — odrivetool CLI, DFU firmware updates, test orchestration, USB/UART/CAN transport layers, and odrive Python package
---

# Python ODrive Tools Skill

Knowledge base for the ODrive Python toolchain and CLI.

## When to Use

- Using `odrivetool` for device configuration, calibration, or monitoring
- Performing DFU firmware updates
- Running or writing integration tests
- Working with the `odrive` Python package (transport layers, enums, configuration)

## Key Project Files

| File | Purpose |
|------|---------|
| `tools/odrive/` | Main Python package |
| `tools/odrive/shell.py` | Interactive `odrivetool` REPL |
| `tools/odrive/configuration.py` | Device configuration management |
| `tools/odrive/dfu.py` | DFU firmware update protocol |
| `tools/odrive/dfuse/` | DFU state machine implementation |
| `tools/odrive/enums.py` | Generated enums from `odrive-interface.yaml` |
| `tools/run_tests.py` | Integration test orchestrator |
| `tools/setup.py` | PyPI package distribution |
| `tools/create_can_dbc.py` | CAN database file generator |

## odrivetool CLI

```bash
# Start interactive shell (connects to first available device)
odrivetool

# Common interactive commands
odrv0.axis0.requested_state = AXIS_STATE_FULL_CALIBRATION_SEQUENCE
odrv0.axis0.requested_state = AXIS_STATE_CLOSED_LOOP_CONTROL
odrv0.axis0.controller.input_vel = 2.0  # turns/s
odrv0.save_configuration()
odrv0.reboot()

# DFU firmware update
odrivetool dfu Firmware/build/ODriveFirmware.hex

# Backup/restore configuration
odrivetool backup-config backup.json
odrivetool restore-config backup.json
```

## Test Framework

```powershell
# Run all integration tests
python tools/run_tests.py

# Run specific test module
python tools/run_tests.py --filter can
python tools/run_tests.py --filter encoder
python tools/run_tests.py --filter calibration
```

### Test Categories

| Test Module | What it Tests |
|-------------|--------------|
| `tests/can_test.py` | CAN protocol messages and endpoints |
| `tests/uart_test.py` | UART/ASCII protocol |
| `tests/calibration_test.py` | Motor and encoder calibration sequence |
| `tests/closed_loop_test.py` | Closed-loop control modes |
| `tests/nvm_test.py` | Non-volatile memory save/restore |

## Transport Layers

The `odrive` package supports multiple transport layers:

| Transport | Module | Connection String |
|-----------|--------|-------------------|
| USB | `odrive.usb_transport` | Auto-detected via VID/PID |
| UART | `odrive.uart_transport` | Serial port (e.g., COM3, /dev/ttyACM0) |
| CAN | `odrive.can_transport` | CAN interface (e.g., can0) |

## Interface YAML

`odrive-interface.yaml` is the single source of truth for:
- All device properties and their types
- Error flag definitions
- Enum definitions (generated into `tools/odrive/enums.py`)
- CAN endpoint IDs

```powershell
# Regenerate enums after modifying interface YAML
python Firmware/interface_generator_stub.py
```

## Safety Reminders

- **odrivetool** connects to real hardware — never auto-execute motor commands
- **DFU** flashes firmware — always confirm before running
- **Tests** may move motors — ensure safe mechanical setup

## Related

- [odrivetool.rst](../../docs/odrivetool.rst) — CLI documentation
- [getting-started.rst](../../docs/getting-started.rst) — First-time setup
- [testing.rst](../../docs/testing.rst) — Test documentation
