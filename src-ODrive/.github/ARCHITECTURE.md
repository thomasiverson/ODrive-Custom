# ODrive Agentic Workflow - System Architecture

**Version:** 1.0.0  
**Created:** January 22, 2026

This document provides a visual overview of the ODrive Development System's agentic workflow architecture.

---

## 🌐 Full System Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 copilot-instructions.md (CONSTITUTION)                      │
│  • Safety boundaries & hardware protection                      │
│  • Code quality standards enforcement                           │
│  • Security & repository integrity                              │
│  • Delegation rules & routing logic                             │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  🤖 PRIMARY ORCHESTRATOR (GitHub Copilot)                       │
│  • Routes requests to specialized agents                        │
│  • Coordinates multi-domain tasks                               │
│  • Enforces constitutional boundaries                           │
│  • Manages cross-skill workflows                                │
└─────────┬────────────┬────────────┬────────────┬────────────────┘
          │            │            │            │
    ┌─────▼─────┐ ┌───▼────┐  ┌────▼─────┐ ┌───▼──────┐
    │ firmware  │ │ motor  │  │ hardware │ │    QA    │
    │ engineer  │ │ control│  │ engineer │ │ engineer │
    │  .agent   │ │.agent  │  │  .agent  │ │  .agent  │
    └─────┬─────┘ └───┬────┘  └────┬─────┘ └───┬──────┘
          │           │             │           │
          │           │             │           │
    ┌─────┴─────┬─────┴─────┬───────┴─────┬─────┴──────┬─────────┐
    │           │           │             │            │         │
    ▼           ▼           ▼             ▼            ▼         ▼
┌─────────┐ ┌────────┐ ┌────────┐ ┌──────────┐ ┌────────┐ ┌────────┐
│ odrive- │ │devops- │ │control-│ │   foc-   │ │  pcb-  │ │ test-  │
│   qa-   │ │engineer│ │algorith│ │  tuning  │ │ review │ │automat-│
│assistant│ │  (✅)  │ │ms (🚧) │ │   (🚧)   │ │  (🚧)  │ │ion (🚧)│
│  (✅)   │ └────────┘ └────────┘ └──────────┘ └────────┘ └────────┘
└─────────┘      │           │          │            │         │
                 │           │          │            │         │
                 ▼           ▼          ▼            ▼         ▼
          Plus 2 more:  sensorless-control (🚧)  signal-integrity (🚧)
```

**Legend:**
- ✅ Production-ready skill
- 🚧 Planned/In-development skill

---

## 🎯 Agent Responsibility Matrix

| Domain | Agent | Primary Focus | Skills Used | Never Does |
|--------|-------|--------------|-------------|------------|
| **Embedded Systems** | firmware-engineer | STM32, FreeRTOS, protocols, drivers | odrive-qa-assistant, devops-engineer | Motor control algorithm design, PCB design |
| **Control Theory** | motor-control-engineer | FOC, PID tuning, observers, trajectory | control-algorithms, foc-tuning, sensorless | Protocol implementation, CI/CD, hardware |
| **Hardware** | hardware-engineer | PCB, power electronics, sensors, EMI | pcb-review, signal-integrity | Firmware coding, control tuning |
| **QA & Testing** | QA-engineer | Testing, validation, CI/CD, quality gates | odrive-qa-assistant, test-automation, devops | Core feature implementation |

---

## 📊 Request Routing Flow

```
User Request
     │
     ▼
Is it multi-domain (3+ areas)?
     │
     ├─── YES ──────────────┐
     │                      │
     NO                     ▼
     │              PRIMARY ORCHESTRATOR
     │              (coordinates workflow)
     │                      │
     ▼                      ▼
Analyze keywords:    Delegates to multiple agents
     │
     ├─ "USB", "UART", "driver", "STM32" ────────► firmware-engineer
     │
     ├─ "FOC", "controller", "tuning", "PID" ────► motor-control-engineer
     │
     ├─ "PCB", "schematic", "gate drive", "EMI" ─► hardware-engineer
     │
     └─ "test", "build", "CI/CD", "validate" ────► QA-engineer
```

### Example Routing Scenarios

| User Request | Routed To | Reason |
|--------------|-----------|--------|
| "Implement CAN protocol handler" | firmware-engineer | Communication protocol implementation |
| "Tune velocity controller gains" | motor-control-engineer | Control theory & tuning |
| "Review motor driver PCB layout" | hardware-engineer | PCB design review |
| "Generate unit tests for encoder" | QA-engineer | Test generation |
| "Build firmware for v3.6 board" | QA-engineer → odrive-qa-assistant | Build automation |
| "Debug FOC current loop instability" | motor-control-engineer + firmware-engineer | Multi-domain (orchestrator) |
| "Flash firmware to device" | QA-engineer (⚠️ confirmation) | Hardware operation safety check |

---

## 🔧 Skills Dependency Graph

```
┌────────────────────┐
│  odrive-qa-       │  ◄─────┬─────────────┬─────────────┐
│  assistant (✅)   │        │             │             │
└────────────────────┘        │             │             │
         ▲                    │             │             │
         │                    │             │             │
         │              firmware-eng   QA-engineer        │
         │                    │                           │
┌────────────────────┐        │                           │
│  devops-engineer  │  ◄─────┴───────────────────────────┘
│       (✅)        │
└────────────────────┘
         ▲
         │
         └────── firmware-eng, QA-engineer
         
┌────────────────────┐
│  control-         │  ◄───── motor-control-engineer
│  algorithms (🚧)  │
└────────────────────┘

┌────────────────────┐
│  foc-tuning (🚧)  │  ◄───── motor-control-engineer
└────────────────────┘

┌────────────────────┐
│  sensorless-      │  ◄───── motor-control-engineer
│  control (🚧)     │
└────────────────────┘

┌────────────────────┐
│  pcb-review (🚧)  │  ◄───── hardware-engineer
└────────────────────┘

┌────────────────────┐
│  signal-          │  ◄───── hardware-engineer
│  integrity (🚧)   │
└────────────────────┘

┌────────────────────┐
│  test-automation  │  ◄───── QA-engineer
│       (🚧)        │
└────────────────────┘
```

---

## 📖 Instruction Files Application

```
All Code Changes
     │
     ├─── C++ Files (.cpp, .hpp, .c, .h)
     │         │
     │         ├─► General_Codebase_Standards.instructions.md
     │         ├─► cpp_coding_standards.instructions.md
     │         └─► Header_File_Rules.instructions.md (headers only)
     │
     ├─── Python Files (.py)
     │         │
     │         ├─► General_Codebase_Standards.instructions.md
     │         └─► Python_Coding_Standards.instructions.md
     │
     └─── All Other Files
               │
               └─► General_Codebase_Standards.instructions.md
```

### Mandatory Pre-Change Checklist

Before ANY code modification, agent MUST:
1. ✅ Read applicable instruction files
2. ✅ Verify naming conventions
3. ✅ Check encoding/line endings
4. ✅ Review safety implications
5. ✅ Plan test coverage

---

## 🚀 Workflow Patterns

### Pattern 1: Simple Single-Agent Task
```
User Request → Agent → Skill → Result → User
     │           │       │        │
     └───────────┴───────┴────────┘
         (direct execution)
```

**Example:**  
"Build firmware for v3.6" → QA-engineer → odrive-qa-assistant → make CONFIG=board-v3.6-56V

---

### Pattern 2: Multi-Step Single-Domain
```
User Request → Agent → Multiple Skills → Result
     │           │           │              │
     └───────────┴───────────┴──────────────┘
         (agent coordinates skills)
```

**Example:**  
"Refactor USB code to modern C++" → firmware-engineer → {odrive-qa-assistant (build), devops (test)}

---

### Pattern 3: Cross-Domain Collaboration
```
User Request → Orchestrator
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
       Agent1    Agent2    Agent3
          │         │         │
          ▼         ▼         ▼
       Skills    Skills    Skills
          │         │         │
          └─────────┴─────────┘
                    │
                    ▼
                 Result
```

**Example:**  
"Debug motor vibration at 5Hz" → Orchestrator → {motor-control (analysis), hardware (measurement), firmware (logging)}

---

## 🛡️ Safety Gate System

```
                    User Request
                         │
                         ▼
                  ┌──────────────┐
                  │  Parse Intent│
                  └──────┬───────┘
                         │
                         ▼
               Hardware Operation? ────► NO ────► Execute
                         │
                        YES
                         │
                         ▼
                  ┌──────────────────┐
                  │ Safety Validation│
                  │  • Voltage check │
                  │  • Current limit │
                  │  • Speed bounds  │
                  └──────┬───────────┘
                         │
                         ▼
                    Safe? ────► NO ────► Reject + Explain
                         │
                        YES
                         │
                         ▼
              ┌─────────────────────┐
              │ User Confirmation   │
              │ Type "CONFIRM"      │
              └──────┬──────────────┘
                     │
                     ▼
               Confirmed? ────► NO ────► Cancel
                     │
                    YES
                     │
                     ▼
                  Execute
```

### Hardware Operations Requiring Confirmation
- `make flash` - Flash firmware to device
- `odrivetool` - Device configuration changes
- `make erase` - Erase device flash
- Motor parameter changes (voltage/current/speed limits)
- Calibration procedures
- Hardware tests that spin motors

---

## 📂 File Organization

```
.github/
├── 📋 copilot-instructions.md        ← Constitution (THIS IS THE LAW)
├── 📄 README.md                      ← System documentation
├── 📊 ARCHITECTURE.md                ← This file
│
├── 🤖 agents/                        ← Specialized AI agents
│   ├── firmware-engineer.agent.md
│   ├── motor-control-engineer.agent.md
│   ├── hardware-engineer.agent.md
│   └── QA-engineer.agent.md
│
├── 🔧 skills/                        ← Reusable operational modules
│   ├── odrive-qa-assistant/ (✅)
│   ├── devops-engineer/ (✅)
│   ├── control-algorithms/ (🚧)
│   ├── foc-tuning/ (🚧)
│   ├── sensorless-control/ (🚧)
│   ├── pcb-review/ (🚧)
│   ├── signal-integrity/ (🚧)
│   └── test-automation/ (🚧)
│
├── 📖 instructions/                  ← Coding standards
│   ├── cpp_coding_standards.instructions.md
│   ├── Header_File_Rules.instructions.md
│   ├── General_Codebase_Standards.instructions.md
│   └── Python_Coding_Standards.instructions.md
│
├── 💡 prompts/                       ← Reusable workflows
│   ├── refactor-modern-cpp.prompt.md
│   ├── generate-doctest.prompt.md
│   ├── debug-motor-error.prompt.md
│   └── ... (10 total)
│
└── ⚙️ workflows/                     ← CI/CD pipelines
    └── firmware.yaml
```

---

## 🎓 Development Workflow Example

### Scenario: Implement New Encoder Support

```
1. User: "Add support for BiSS-C absolute encoder"
            │
            ▼
2. Orchestrator analyzes:
   - Hardware interface (hardware-engineer)
   - Firmware driver (firmware-engineer)
   - Position feedback (motor-control-engineer)
   - Testing (QA-engineer)
            │
            ▼
3. Delegation:
   ┌─────────────────────────────────┐
   │ hardware-engineer               │
   │ → Review BiSS-C timing specs    │
   │ → Validate GPIO/SPI interface   │
   └─────────────────────────────────┘
            │
            ▼
   ┌─────────────────────────────────┐
   │ firmware-engineer               │
   │ → Implement SPI driver          │
   │ → Add BiSS-C protocol handler   │
   │ → Follow cpp_coding_standards   │
   │ → Use odrive-qa-assistant       │
   └─────────────────────────────────┘
            │
            ▼
   ┌─────────────────────────────────┐
   │ motor-control-engineer          │
   │ → Integrate position feedback   │
   │ → Update control loop timing    │
   └─────────────────────────────────┘
            │
            ▼
   ┌─────────────────────────────────┐
   │ QA-engineer                     │
   │ → Generate unit tests           │
   │ → Run build for all variants    │
   │ → Create HIL test plan          │
   │ → Use devops-engineer skill     │
   └─────────────────────────────────┘
            │
            ▼
4. Result: Complete BiSS-C encoder support
   - Driver code (C++17 compliant)
   - Unit tests (doctest)
   - Documentation (Doxygen)
   - CI/CD integration
   - Hardware validation plan
```

---

## 🔄 Feedback & Evolution

This agentic system evolves based on:
- Developer feedback
- New hardware platforms
- Additional motor control algorithms
- Expanded testing capabilities
- CI/CD improvements

**To propose changes:**
1. Review constitution first
2. Identify affected agents/skills
3. Document compatibility impacts
4. Update hierarchy diagrams
5. Version the changes

---

**Version History:**

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-22 | Initial architecture document |

---

*For implementation details, see individual agent and skill files.*
