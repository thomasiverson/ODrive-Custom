---
name: can-protocol
description: CAN bus communication for ODrive — message formatting, DBC generation, protocol debugging, and CAN interface configuration
---

# CAN Protocol Skill

Guides CAN bus communication tasks for ODrive motor controllers.

## When to Use

- Implementing or debugging CAN message handlers
- Generating or modifying DBC files for CAN tools
- Configuring CAN endpoints and node IDs
- Troubleshooting CAN bus errors (bus-off, error frames, arbitration)

## Key Project Files

| File | Purpose |
|------|---------|
| `Firmware/communication/can/` | CAN protocol implementation |
| `Firmware/communication/can/can_simple.cpp` | Simple CAN protocol handler |
| `tools/create_can_dbc.py` | Generate CAN DBC database file |
| `odrive-interface.yaml` | Interface definitions (generates CAN endpoints) |
| `docs/can-protocol.rst` | CAN protocol documentation |
| `docs/can-guide.rst` | CAN setup guide |

## CAN Message Format

ODrive uses a simple CAN protocol:
- **Arbitration ID**: `(node_id << 5) | cmd_id`
- **Node ID**: 6 bits (0–63), configured per axis
- **Command ID**: 5 bits (0–31), defines message type

### Common Commands

| CMD ID | Name | Direction | DLC | Description |
|--------|------|-----------|-----|-------------|
| 0x001 | Heartbeat | ODrive→Host | 8 | State + error flags |
| 0x003 | Get Motor Error | Host→ODrive | 0 | Request motor error |
| 0x007 | Set Axis State | Host→ODrive | 4 | Change axis state |
| 0x009 | Get Encoder Estimates | ODrive→Host | 8 | Position + velocity |
| 0x00B | Set Controller Modes | Host→ODrive | 8 | Control + input mode |
| 0x00D | Set Input Pos | Host→ODrive | 8 | Position setpoint |
| 0x00E | Set Input Vel | Host→ODrive | 8 | Velocity setpoint |
| 0x00F | Set Input Torque | Host→ODrive | 4 | Torque setpoint |

## DBC Generation

```powershell
# Generate CAN DBC file from interface YAML
python tools/create_can_dbc.py

# The generated DBC can be used with:
# - Vector CANalyzer/CANoe
# - PCAN-View
# - python-can + cantools
```

## Debugging CAN Issues

### Common Problems

1. **No messages received**: Check baud rate (default 250kbps), termination resistors (120Ω at each end), wiring (CAN_H, CAN_L)
2. **Bus-off state**: Too many error frames — check for ground loops, signal integrity, or misconfigured nodes
3. **Wrong data**: Verify byte order (little-endian) and scaling factors in DBC

### Python CAN Debugging

```python
import can

bus = can.interface.Bus(channel='can0', bustype='socketcan', bitrate=250000)
for msg in bus:
    node_id = msg.arbitration_id >> 5
    cmd_id = msg.arbitration_id & 0x1F
    print(f"Node {node_id} CMD 0x{cmd_id:02X}: {msg.data.hex()}")
```

## Related

- [can-protocol.rst](../../docs/can-protocol.rst) — Full protocol reference
- [can-guide.rst](../../docs/can-guide.rst) — Setup guide
