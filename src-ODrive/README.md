## Important Note

The firmware in this repository is compatible with the ODrive v3.x (NRND) and is no longer under active development.

Firmware for the new generation of ODrives ([ODrive Pro](https://odriverobotics.com/shop/odrive-pro), [S1](https://odriverobotics.com/shop/odrive-s1), [Micro](https://odriverobotics.com/shop/odrive-micro), etc.) is currently being actively maintained and developed, however its source code is currently not publicly available. Access may be available under NDA, please [reach out to us](mailto:info@odriverobotics.com) for inquiries.

## Overview

![ODrive Logo](https://static1.squarespace.com/static/58aff26de4fcb53b5efd2f02/t/59bf2a7959cc6872bd68be7e/1505700483663/Odrive+logo+plus+text+black.png?format=1000w)

This project is all about accurately driving brushless motors, for cheap. The aim is to make it possible to use inexpensive brushless motors in high performance robotics projects, like [this](https://www.youtube.com/watch?v=WT4E5nb3KtY).

| Branch | Build Status |
|--------|--------------|
| master | [![Build Status](https://travis-ci.org/madcowswe/ODrive.png?branch=master)](https://travis-ci.org/madcowswe/ODrive) |
| devel  | [![Build Status](https://travis-ci.org/madcowswe/ODrive.png?branch=devel)](https://travis-ci.org/madcowswe/ODrive) |

[![pip install odrive (nightly)](https://github.com/madcowswe/ODrive/workflows/pip%20install%20odrive%20(nightly)/badge.svg)](https://github.com/madcowswe/ODrive/actions?query=workflow%3A%22pip+install+odrive+%28nightly%29%22)

Please refer to the [Developer Guide](https://docs.odriverobotics.com/v/latest/developer-guide.html#) to get started with ODrive firmware development.

---

### Repository Structure

| Directory | Purpose |
|-----------|---------|
| `Firmware/MotorControl/` | Core control loops — FOC, PID, encoder, trajectory |
| `Firmware/Drivers/STM32/` | Hardware abstraction — GPIO, timers, SPI |
| `Firmware/communication/` | Protocol handlers — USB, CAN, UART |
| `Firmware/Board/v3/` | Board-specific HAL, CubeMX config, linker scripts |
| `tools/odrive/` | Python package — CLI, DFU, integration tests |
| `docs/` | Sphinx documentation (RST format) |
| `.github/` | GitHub Copilot customization (see below) |

---

### GitHub Copilot Customization

This project includes a comprehensive set of [VS Code Copilot customization files](https://code.visualstudio.com/docs/copilot/copilot-customization) under `.github/` for AI-assisted embedded development.

#### Always-On Instructions
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — Project overview, tech stack, build reference, safety rules (loaded on every chat)

#### Coding Standards (`.github/instructions/`)
| File | Applies To | Purpose |
|------|-----------|---------|
| `cpp_coding_standards.instructions.md` | `*.cpp, *.c, *.h, *.hpp` | Naming, style, modern C++, headers, memory, ISR safety, real-time, hardware patterns |
| `python_coding_standards.instructions.md` | `*.py` | PEP 8, type hints, testing conventions |

#### Agents (`.github/agents/`)
| Agent | Purpose |
|-------|---------|
| **ODrive Engineer** | Primary orchestrator — firmware development, motor control, hardware tasks |
| **ODrive Toolchain** | Build, compile, test, and code navigation |
| **ODrive Code Reviewer** | Code review for style, safety, and embedded best practices |
| **ODrive Ops** | CI/CD workflows, releases, deployments |
| **ODrive QA** | Quality assurance and testing |
| **Ada to C++ Migrator** | Specialized Ada → Modern C++ migration with safety preservation |

#### Skills (`.github/skills/`)
| Skill | Purpose |
|-------|---------|
| **odrive-toolchain** | Build firmware, run tests, search code, inspect errors |
| **can-protocol** | CAN bus communication — message formatting, DBC generation, protocol debugging |
| **firmware-debugging** | STM32 debugging — OpenOCD/GDB, hard fault analysis, FreeRTOS thread inspection |
| **stm32-peripherals** | Timer/PWM, ADC, DMA, GPIO, CubeMX `.ioc` interpretation |
| **python-odrivetool** | odrivetool CLI, DFU firmware updates, test orchestration |
| **cpp-testing** | Test-driven development with doctest framework |
| **ada-cpp-migration** | Ada to Modern C++ (C++20/23) migration patterns |
| **odrive-ops** | CI/CD, releases, and deployment operations |

#### Reusable Prompts (`.github/prompts/`)
Run these in Chat with `/prompt-name`:

| Prompt | Purpose |
|--------|---------|
| `toolchain` | Build firmware for a specific board variant |
| `debug-firmware` | Firmware debugging workflow (fault registers, OpenOCD/GDB) |
| `review-code` | Structured code review with checklist |
| `generate-tests` | Generate doctest unit tests |
| `check-safety` | Analyze code for embedded safety issues |
| `refactor-modern-cpp-v2` | Modernize C++ code (C++17/20 features) |
| `add-doxygen` | Add Doxygen documentation to functions |
| `explain-foc` | Explain Field-Oriented Control algorithms |
| `optimize-critical` | Optimize performance-critical code paths |

#### Hooks (`.github/hooks/`)
| Hook | Trigger | Purpose |
|------|---------|---------|
| `embedded-safety.json` | PreToolUse | Warns when editing ISR/interrupt handler files |
| `format-check.json` | PostToolUse | Reminds about clang-format after C++ edits |

---

### Other Resources

 * [Main Website](https://www.odriverobotics.com/)
 * [User Guide](https://docs.odriverobotics.com/)
 * [Forum](https://discourse.odriverobotics.com/)
 * [Chat](https://discourse.odriverobotics.com/t/come-chat-with-us/281)
