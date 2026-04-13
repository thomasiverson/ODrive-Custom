---
name: debug-firmware
description: 'Step-by-step firmware debugging workflow — fault analysis, OpenOCD/GDB, FreeRTOS thread inspection'
agent: ODrive Engineer
tools: ['execute/runInTerminal', 'read', 'search']
---
# Debug Firmware

Walk through a structured firmware debugging workflow for STM32-based ODrive.

## Instructions

### Step 1: Identify the Fault Type

Determine what kind of issue you're seeing:
- **Hard Fault** — CPU exception (null pointer, alignment, bus error)
- **Watchdog Reset** — control loop timeout or infinite loop
- **Assertion Failure** — `assert()` or `odrv.error` flag set
- **Functional Bug** — wrong behavior, incorrect motor control output

### Step 2: Read Fault Registers (Hard Faults)

For ARM Cortex-M4 hard faults, read these registers:
- `CFSR` (Configurable Fault Status Register) at `0xE000ED28`
- `HFSR` (Hard Fault Status Register) at `0xE000ED2C`
- `MMFAR` (MemManage Fault Address) at `0xE000ED34`
- `BFAR` (Bus Fault Address) at `0xE000ED38`

```
# With OpenOCD connected:
mdw 0xE000ED28   # CFSR
mdw 0xE000ED2C   # HFSR
```

### Step 3: Analyze the Stack Trace

Check the firmware's hard fault handler in `Firmware/Board/v3/Src/stm32f4xx_it.c`.
Look at the stacked registers (R0-R3, R12, LR, PC, xPSR) to find the faulting instruction.

### Step 4: Check ODrive Error Flags

```python
# Via odrivetool (if device is responsive)
odrv0.axis0.error
odrv0.axis0.motor.error
odrv0.axis0.encoder.error
odrv0.axis0.controller.error
```

### Step 5: Search Codebase for Error Sources

```powershell
python .github\skills\odrive-toolchain\list_errors.py --filter ${{ERROR_NAME}}
python .github\skills\odrive-toolchain\search_symbol.py "${{SYMBOL_NAME}}"
```

### Step 6: FreeRTOS Thread Inspection

If using GDB with OpenOCD, inspect FreeRTOS threads:
```
info threads
thread apply all bt
```

Check for stack overflows — FreeRTOS uses a canary pattern at the bottom of each stack.

## Safety

- **Read-only** — this prompt only analyzes, it does not modify firmware or flash devices
- If a fix is identified, present it for review before applying
