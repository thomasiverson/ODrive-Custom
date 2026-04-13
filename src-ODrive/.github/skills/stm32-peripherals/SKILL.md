---
name: stm32-peripherals
description: STM32 peripheral configuration — timers/PWM, ADC, DMA, GPIO modes, CubeMX .ioc interpretation, HAL vs register access for ODrive firmware
---

# STM32 Peripherals Skill

Knowledge base for STM32F405 peripheral configuration in ODrive firmware.

## When to Use

- Configuring timers for PWM generation or encoder capture
- Setting up ADC for current sensing or voltage measurement
- Configuring DMA transfers for ADC or SPI
- Interpreting or modifying the CubeMX `.ioc` project file
- Writing or reviewing HAL-based or register-level peripheral code

## Key Project Files

| File | Purpose |
|------|---------|
| `Firmware/Board/v3/Odrive.ioc` | STM32CubeMX project (peripheral config) |
| `Firmware/Drivers/STM32/stm32_gpio.cpp/hpp` | GPIO abstraction |
| `Firmware/Drivers/STM32/stm32_timer.hpp` | Timer management |
| `Firmware/Drivers/STM32/stm32_spi_arbiter.cpp/hpp` | SPI arbiter |
| `Firmware/Drivers/STM32/stm32_nvm.c/h` | Non-volatile memory (flash) |
| `Firmware/Drivers/DRV8301/` | Gate driver (SPI-controlled) |
| `Firmware/Board/v3/Inc/main.h` | Pin definitions and peripheral handles |
| `Firmware/Board/v3/Src/stm32f4xx_hal_msp.c` | HAL MSP init (clocks, pins) |

## STM32F405 Key Peripherals in ODrive

### Timers

| Timer | Function | Channels |
|-------|----------|----------|
| TIM1 | Motor 0 PWM (3-phase) | CH1, CH2, CH3 + complementary |
| TIM8 | Motor 1 PWM (3-phase) | CH1, CH2, CH3 + complementary |
| TIM2 | Encoder 0 input capture | CH1, CH2 |
| TIM3 | Encoder 1 input capture | CH1, CH2 |
| TIM5 | General timing / step-dir | Varies |

### ADC

| ADC | Function | Channels |
|-----|----------|----------|
| ADC1 | Current sense phase A/B (Motor 0) | Injected conversions |
| ADC2 | Current sense phase A/B (Motor 1) | Injected conversions |
| ADC3 | Vbus measurement, aux analog | Regular conversions |

### DMA

| DMA Stream | Peripheral | Direction |
|------------|-----------|-----------|
| DMA2_Stream0 | ADC1 | Periph→Memory |
| DMA2_Stream2 | ADC3 | Periph→Memory |
| DMA1_Stream3 | SPI2_TX | Memory→Periph |

### Communication Peripherals

| Peripheral | Protocol | Pins |
|-----------|----------|------|
| USB OTG FS | USB CDC | PA11, PA12 |
| CAN1 | CAN bus | PB8, PB9 |
| USART1/2 | UART | PA9/PA10, PA2/PA3 |
| SPI3 | DRV8301 gate driver | PC10, PC11, PC12 |

## CubeMX .ioc File

The `.ioc` file at `Firmware/Board/v3/Odrive.ioc` is the source of truth for pin assignments and peripheral initialization. When modifying peripherals:

1. Open in STM32CubeMX to visualize pin assignments
2. Regenerate code if peripheral config changes
3. Custom code goes between `USER CODE BEGIN` / `USER CODE END` markers

## HAL vs Direct Register Access

ODrive uses a mix:
- **HAL** for complex peripherals (USB, I2C, initial setup)
- **Direct registers** for performance-critical paths (PWM updates, ADC reads in ISR)

```cpp
// HAL — readable, portable
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_SET);

// Direct register — fast, used in control loops
GPIOA->BSRR = GPIO_PIN_5;  // Set
GPIOA->BSRR = GPIO_PIN_5 << 16;  // Reset
```

## Related

- [pinout.rst](../../docs/pinout.rst) — Board pinout documentation
- [developer-guide.rst](../../docs/developer-guide.rst) — Development setup
