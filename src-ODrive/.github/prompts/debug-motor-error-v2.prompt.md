# Debug Motor Error

Analyze and debug motor errors using the ODrive error reporting system.

## Instructions

Use the **odrive-qa-assistant** skill to search for error definitions and analyze the error reporting mechanism.

### Input Required
- **Error Code or Message**: ${{ERROR_CODE}} (e.g., "ERROR_CONTROL_DEADLINE_MISSED", "ILLEGAL_HALL_STATE")

### What This Prompt Does

1. **Looks up error definition** in `odrive-interface.yaml`
2. **Searches error handling code** in firmware
3. **Traces error propagation** from driver to interface
4. **Identifies potential causes** based on error type
5. **Provides debugging steps** specific to the error

### Commands

```bash
# List all error codes from interface definition
grep -A 5 "error_code" Firmware/odrive-interface.yaml

# Search for error flag usage in code
grep -r "ERROR_CONTROL_DEADLINE_MISSED" Firmware/MotorControl/

# Find error handling in axis
grep -r "error_" Firmware/MotorControl/axis.cpp

# Use odrive-qa-assistant skill to search symbols
python .github/skills/odrive-qa-assistant/scripts/search_symbol.py "error_"
```

### Prerequisites

- ODrive firmware source code
- Basic understanding of motor control flow

### Example Usage

Debug specific error:
```
@odrive-engineer Debug ERROR_CONTROL_DEADLINE_MISSED - what causes this?
```

Analyze error handling:
```
@odrive-engineer How are motor errors reported from the encoder to the interface?
```

Find error definition:
```
@odrive-qa List all encoder-related error codes
```

### Output

- Error code definition and meaning
- File locations where error is set
- Propagation path through firmware
- Common causes and fixes
- Related error codes to check

### Error Analysis Flow

1. **Error Definition** → `Firmware/odrive-interface.yaml`
2. **Error Detection** → Driver code (encoder, motor, etc.)
3. **Error Propagation** → `axis.cpp`, `motor.cpp`
4. **Error Reporting** → Communication interface (USB, CAN, UART)
5. **Error Handling** → State machine transitions

### Skills Invoked

| Skill | Purpose |
|-------|---------|
| **odrive-qa-assistant** | Search error codes, find symbol definitions |
| **ODrive-Engineer** | Analyze error handling logic, trace propagation |

### Related Prompts

| Need | Use |
|------|-----|
| Check safety violations | `check-safety.prompt.md` |
| Optimize control loop | `optimize-critical.prompt.md` |
| Test motor control | `generate-doctest.prompt.md` |
| Explain FOC algorithm | `explain-foc.prompt.md` |
