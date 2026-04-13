---
name: firmware-debugging
description: STM32 firmware debugging — OpenOCD/GDB setup, hard fault analysis, FreeRTOS thread inspection, fault register decoding for ARM Cortex-M4
---

# Firmware Debugging Skill

Knowledge base for debugging ODrive STM32 firmware issues.

## When to Use

- Diagnosing hard faults, watchdog resets, or assertion failures
- Setting up OpenOCD + GDB for live debugging
- Inspecting FreeRTOS thread states and stack usage
- Decoding ARM Cortex-M fault registers

## Key Project Files

| File | Purpose |
|------|---------|
| `Firmware/Board/v3/Src/stm32f4xx_it.c` | Interrupt & fault handlers |
| `Firmware/Board/v3/Src/freertos.c` | FreeRTOS task setup |
| `Firmware/Board/v3/STM32F405RGTx_FLASH.ld` | Memory layout (flash/RAM) |
| `Firmware/freertos_vars.h` | FreeRTOS configuration |
| `Firmware/FreeRTOS-openocd.c` | OpenOCD FreeRTOS awareness |

## ARM Cortex-M4 Fault Registers

| Register | Address | Purpose |
|----------|---------|---------|
| CFSR | `0xE000ED28` | Configurable Fault Status (usage, bus, memory) |
| HFSR | `0xE000ED2C` | Hard Fault Status |
| MMFAR | `0xE000ED34` | MemManage Fault Address |
| BFAR | `0xE000ED38` | Bus Fault Address |
| DFSR | `0xE000ED30` | Debug Fault Status |
| AFSR | `0xE000ED3C` | Auxiliary Fault Status |

### CFSR Bit Decode

**UsageFault (bits 16–25)**:
- Bit 25: DIVBYZERO — divide by zero
- Bit 24: UNALIGNED — unaligned access
- Bit 18: INVPC — invalid PC on exception return
- Bit 17: INVSTATE — invalid EPSR state
- Bit 16: UNDEFINSTR — undefined instruction

**BusFault (bits 8–15)**:
- Bit 15: BFARVALID — BFAR holds valid address
- Bit 12: STKERR — bus fault on stacking
- Bit 11: UNSTKERR — bus fault on unstacking
- Bit 9: PRECISERR — precise data bus error
- Bit 8: IBUSERR — instruction bus error

**MemManage (bits 0–7)**:
- Bit 7: MMARVALID — MMFAR holds valid address
- Bit 4: MSTKERR — MemManage on stacking
- Bit 1: DACCVIOL — data access violation
- Bit 0: IACCVIOL — instruction access violation

## OpenOCD + GDB Setup

```bash
# Start OpenOCD (ST-Link V2)
openocd -f interface/stlink-v2.cfg -f target/stm32f4x.cfg

# Connect GDB
arm-none-eabi-gdb build/ODriveFirmware.elf
(gdb) target remote localhost:3333
(gdb) monitor reset halt
(gdb) load
```

### Useful GDB Commands

```
info threads              # List FreeRTOS tasks
thread apply all bt       # Backtrace all threads
print odrv.axis0.error    # Read error flags
x/x 0xE000ED28            # Read CFSR
monitor reset halt        # Reset and halt
```

## ODrive Error Flag Hierarchy

```
odrv0.error
├── axis0.error
│   ├── motor.error (MOTOR_ERROR_*)
│   ├── encoder.error (ENCODER_ERROR_*)
│   ├── controller.error (CONTROLLER_ERROR_*)
│   └── sensorless_estimator.error
└── axis1.error
    └── (same structure)
```

## FreeRTOS Stack Analysis

Check `configMINIMAL_STACK_SIZE` and individual task stack sizes in `freertos_vars.h`. Stack overflow manifests as:
- Hard fault with DACCVIOL or STKERR
- Corrupted local variables
- Random jumps to invalid addresses

Use `uxTaskGetStackHighWaterMark()` to check remaining stack at runtime.

## Related

- [developer-guide.rst](../../docs/developer-guide.rst) — Development setup
- [troubleshooting.rst](../../docs/troubleshooting.rst) — Common issues
