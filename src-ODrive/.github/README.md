# ODrive Development System

**Agentic Workflow & Spec-Driven Development Framework**

This directory contains the intelligent agent system for ODrive firmware and tools development. It provides specialized AI assistants for firmware engineering, motor control, hardware design, and quality assurance.

---

## 🏗️ System Architecture

```
📋 copilot-instructions.md (Constitution)
        ↓
  🤖 [Primary Orchestrator - GitHub Copilot]
        ↓
  ┌────────────────┴────────────────┐
  ↓                                 ↓
ODrive-Engineer               ODrive-QA
(Development Orchestrator)    (Testing/DevOps Orchestrator)
  ↓                                 ↓
  │                                 │
Skills:                       Skills:
• odrive-qa-assistant (✅)    • odrive-qa-assistant (✅)
• devops-engineer (✅)        • test-automation (🚧)
• control-algorithms (🚧)    • devops-engineer (✅)
• foc-tuning (🚧)
• sensorless-control (🚧)
• pcb-review (🚧)
• signal-integrity (🚧)
```

---

## 📂 Directory Structure

```
.github/
├── copilot-instructions.md          # 📋 Constitution - Core rules & boundaries
│
├── agents/                           # 🤖 Orchestrator agents (2)
│   ├── ODrive-Engineer.agent.md        # Development orchestrator (all dev work)
│   └── ODrive-QA.agent.md              # Testing/CI/CD orchestrator
│
├── skills/                           # 🔧 Reusable operational skills
│   ├── odrive-qa-assistant/
│   │   └── SKILL.md                    # Build, test, symbol search
│   └── devops-engineer/
│       └── SKILL.md                    # CI/CD, releases, deployments
│
├── instructions/                     # 📖 Coding standards & guidelines
│   ├── cpp_coding_standards.instructions.md
│   ├── Header_File_Rules.instructions.md
│   ├── General_Codebase_Standards.instructions.md
│   └── Python_Coding_Standards.instructions.md
│
├── prompts/                          # 💡 Common development workflows
│   ├── refactor-modern-cpp.prompt.md
│   ├── generate-doctest.prompt.md
│   ├── debug-motor-error.prompt.md
│   └── ... (10 total prompts)
│
└── workflows/                        # ⚙️ GitHub Actions CI/CD
    └── firmware.yaml
```

---

## 🤖 Agents Hierarchy

### 1. ODrive-Engineer Agent (Development Orchestrator)
**File:** `agents/ODrive-Engineer.agent.md`  
**Domains:** Firmware, Motor Control, Hardware (All Development)

**Responsibilities:**
- Implement firmware features and drivers (STM32, FreeRTOS)
- Design and tune motor control algorithms (FOC, PID, observers)
- Analyze hardware interfaces (PCB, signal integrity, power electronics)
- Protocol implementation (USB, CAN, UART, SPI, I2C)
- Code optimization and refactoring
- Hardware abstraction layers

**Skills Invoked:**
- ✅ `odrive-qa-assistant` - Build, test, symbol search
- ✅ `devops-engineer` - CI/CD workflows, releases
- 🚧 `control-algorithms` - Control patterns (planned)
- 🚧 `foc-tuning` - Auto-tuning procedures (planned)
- 🚧 `sensorless-control` - Observer implementations (planned)
- 🚧 `pcb-review` - PCB design review (planned)
- 🚧 `signal-integrity` - Signal analysis (planned)

**When to Use:**
- "Implement USB protocol handler"
- "Tune velocity PI controller"
- "Review gate driver schematic"
- "Debug encoder signal noise"
- "Optimize motor control loop"
- "Add sensorless observer"

---

### 2. ODrive-QA Agent (Testing & DevOps Orchestrator)
**File:** `agents/ODrive-QA.agent.md`  
**Domains:** Testing, Validation, CI/CD, Deployment

**Responsibilities:**
- Build firmware for all board variants
- Run test suites (unit, integration, HIL)
- Manage CI/CD pipelines and releases
- Quality gate enforcement
- Test automation and coverage analysis
- Performance benchmarking

**Skills Invoked:**
- ✅ `odrive-qa-assistant` - Build, test, workspace inspection
- ✅ `devops-engineer` - Release automation, deployments
- 🚧 `test-automation` - HIL testing, test generation (planned)

**When to Use:**
- "Build firmware for board v3.6"
- "Run full test suite"
- "Generate unit tests"
- "Check CI pipeline status"
- "Create release v0.5.7"
- "Deploy documentation"

---

## 🔧 Skills Library

Skills are reusable modules that agents invoke for specific operational tasks.

### ✅ Production Skills

#### odrive-qa-assistant
**File:** `skills/odrive-qa-assistant/SKILL.md`  
**Purpose:** Build automation, testing, workspace inspection

**Capabilities:**
- Build firmware for specific board variants
- Run test suite (unit, integration, hardware-in-loop)
- Search for C++ symbols (functions, classes, variables)
- List error flags from interface YAML
- Workspace structure inspection

**Used By:** firmware-engineer, QA-engineer

**Example Usage:**
```bash
# Build for specific board
make CONFIG=board-v3.6-56V

# Run tests
python tools/run_tests.py

# Search for symbol
grep -r "Axis::step_cb" Firmware/
```

---

#### devops-engineer
**File:** `skills/devops-engineer/SKILL.md`  
**Purpose:** CI/CD workflows, release automation, deployment

**Capabilities:**
- GitHub Actions workflow management
- Firmware build matrix configuration
- Release channel management
- Documentation deployment
- Secret and credential management

**Used By:** firmware-engineer, QA-engineer

**Example Usage:**
- Trigger CI/CD pipeline
- Create release tags
- Deploy documentation
- Configure build variants

---

### 🚧 Planned Skills (Stubs)

#### control-algorithms
**Status:** Stub - In Development  
**Purpose:** Common control algorithm implementations  
**Used By:** motor-control-engineer

#### foc-tuning
**Status:** Stub - In Development  
**Purpose:** Automated FOC parameter tuning procedures  
**Used By:** motor-control-engineer

#### sensorless-control
**Status:** Stub - In Development  
**Purpose:** Observer and estimation implementations  
**Used By:** motor-control-engineer

#### pcb-review
**Status:** Stub - In Development  
**Purpose:** Automated PCB schematic and layout review  
**Used By:** hardware-engineer

#### signal-integrity
**Status:** Stub - In Development  
**Purpose:** Signal integrity and EMI analysis  
**Used By:** hardware-engineer

#### test-automation
**Status:** Stub - In Development  
**Purpose:** Automated test framework and execution  
**Used By:** QA-engineer

---

## 📖 Instructions Library

Foundational coding standards and guidelines that all agents must follow.

| Instruction File | Applies To | Purpose |
|-----------------|------------|---------|
| `cpp_coding_standards.instructions.md` | `**/*.{cpp,c,hpp,h,cc}` | C++ style, naming, modern practices |
| `Header_File_Rules.instructions.md` | `**/*.{h,hpp}` | Header structure, includes, pragmas |
| `General_Codebase_Standards.instructions.md` | `**` | Encoding, comments, security, naming |
| `Python_Coding_Standards.instructions.md` | `**/*.py` | Python style, PEP 8, testing |

**Mandatory:** Agents MUST read applicable instruction files before generating or modifying code.

---

## 💡 Prompts Library

Reusable workflow prompts for common development tasks.

| Prompt | Purpose |
|--------|---------|
| `refactor-modern-cpp.prompt.md` | Modernize legacy C++ code to C++17 |
| `generate-doctest.prompt.md` | Generate doctest unit tests |
| `debug-motor-error.prompt.md` | Systematic motor error debugging |
| `add-doxygen.prompt.md` | Add Doxygen documentation |
| `optimize-critical.prompt.md` | Optimize performance-critical code |
| `modernize-cpp.prompt.md` | Apply modern C++ patterns |
| `check-safety.prompt.md` | Safety validation for motor control |
| `explain-foc.prompt.md` | Explain FOC algorithm concepts |
| `doc-arduino-interface.prompt.md` | Document Arduino interface |
| `audit-todos.prompt.md` | Audit and prioritize TODO comments |

---

## 🚀 Quick Start

### For Firmware Development
```bash
# Activate ODrive Engineer agent
@odrive-engineer Implement CAN bus message handler for velocity commands

# Build firmware
@odrive-qa Build firmware for board v3.6
```

### For Motor Control Work
```bash
# Activate ODrive Engineer for motor control
@odrive-engineer Tune the velocity PI controller for better response

# Analyze control performance
@odrive-engineer Explain why I'm seeing oscillations at 5 Hz
```

### For Testing & Validation
```bash
# Run full test suite
@odrive-qa Generate unit tests for the encoder module

# Check CI/CD status
@odrive-qa Check firmware CI pipeline status
```

---

## 📋 Usage Rules

### Agent Selection
1. **Single-domain tasks:** Direct to specialized agent
2. **Cross-domain tasks:** Route through primary orchestrator
3. **Unclear scope:** Start with QA agent for assessment

### Safety First
- ⚠️ **Hardware operations require explicit confirmation**
- Never auto-execute: `make flash`, `odrivetool`, device configuration
- Always provide warnings for voltage/current/speed changes

### Code Quality
- All code changes must follow instruction files
- Review checklist before any commit
- Tests required for new functionality

---

## 🔗 Related Documentation

- **Main README:** `../README.md` - Project overview
- **Developer Guide:** `../docs/developer-guide.rst` - Setup and architecture
- **API Documentation:** `../docs/` - Public API reference
- **Change Log:** `../CHANGELOG.md` - Version history

---

## 🛠️ Contributing to the Agent System

### Adding a New Agent

1. Create agent file: `.github/agents/{name}.agent.md`
2. Follow existing agent template structure
3. Update this README's hierarchy diagram
4. Update `copilot-instructions.md` routing table
5. Document responsibilities and skills used

### Adding a New Skill

1. Create skill directory: `.github/skills/{name}/`
2. Create skill file: `.github/skills/{name}/SKILL.md`
3. Update this README's skills table
4. Update `copilot-instructions.md` hierarchy
5. Tag with status: ✅ (production) or 🚧 (development)

### Adding a New Instruction

1. Create instruction file: `.github/instructions/{name}.instructions.md`
2. Add frontmatter with `applyTo` glob pattern
3. Update this README's instructions table
4. Update agent files to reference new instruction

---

## 📊 Status Dashboard

| Component | Status | Last Updated |
|-----------|--------|--------------|
| Constitution | ✅ Complete | 2026-01-22 |
| **Agents (2 Orchestrators)** | | |
| ODrive-Engineer.agent | ✅ Complete | 2026-01-22 |
| ODrive-QA.agent | ✅ Complete | 2026-01-22 |
| **Production Skills (2)** | | |
| odrive-qa-assistant | ✅ Production | 2026-01-22 |
| devops-engineer | ✅ Production | 2026-01-22 |
| **Planned Skills (6)** | | |
| control-algorithms | 🚧 Planned | - |
| foc-tuning | 🚧 Planned | - |
| sensorless-control | 🚧 Planned | - |
| pcb-review | 🚧 Planned | - |
| signal-integrity | 🚧 Planned | - |
| test-automation | 🚧 Planned | - |

---

**Version:** 1.0.0  
**Last Updated:** January 22, 2026  
**Maintained By:** ODrive Robotics Team
