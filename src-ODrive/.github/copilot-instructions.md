# ODrive Firmware — Project Overview

**ODrive** is an open-source brushless motor controller for robotics. This repository contains the firmware, Python tools, and documentation.

## Tech Stack

| Component | Technology |
|-----------|-----------|
| **MCU** | STM32F405 (v3.x), STM32F7x5 (v4.x) — ARM Cortex-M4F/M7 |
| **RTOS** | FreeRTOS |
| **Language** | C++ (firmware), Python (tools), JavaScript/Vue (GUI) |
| **Build** | Tup + Make, ARM GCC cross-compiler (`arm-none-eabi-gcc`) |
| **Comms** | USB CDC, CAN, UART, SPI, I2C |
| **Power** | DRV8301 gate driver, Field-Oriented Control (FOC) |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `Firmware/MotorControl/` | Core control loops (FOC, PID, encoder, trajectory) |
| `Firmware/Drivers/STM32/` | Hardware abstraction (GPIO, timers, SPI) |
| `Firmware/communication/` | Protocol handlers (USB, CAN, UART) |
| `Firmware/Board/v3/` | Board-specific HAL, CubeMX config, linker scripts |
| `tools/odrive/` | Python package — CLI, DFU, tests |
| `docs/` | Sphinx documentation (RST format) |

## Build Quick Reference

```powershell
# Setup environment (Windows — once per session)
. .github\skills\odrive-toolchain\setup-env.ps1

# Build firmware for production board
python .github\skills\odrive-toolchain\build_firmware.py board-v3.6-56V
```

## Coding Standards

Detailed rules are in `.github/instructions/`:
- **C++ (all rules)** — `cpp_coding_standards.instructions.md` (naming, style, modern C++, headers, memory, ISR, real-time, safety)
- **Python** — `python_coding_standards.instructions.md` (PEP 8, type hints, testing)

## Safety Rules

- **NEVER** auto-execute: `make flash`, `odrivetool`, device configuration, or any hardware operation
- **ALWAYS** provide explicit warnings and wait for user confirmation before hardware operations
- **ALWAYS** read applicable instruction files before modifying code
