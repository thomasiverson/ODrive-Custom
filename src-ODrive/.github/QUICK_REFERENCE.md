# ODrive Agentic System - Quick Reference

**Last Updated:** January 22, 2026

This is a quick reference for developers working with the ODrive agentic workflow system.

---

## 🚀 Quick Start Commands

### Activate Specific Agent

```markdown
@odrive-engineer [your request]  # All development work
@odrive [your request]           # Alias for odrive-engineer
@odrive-qa [your request]        # Testing and CI/CD
@qa [your request]               # Alias for odrive-qa
```

### Common Tasks

| Task | Command | Agent Used |
|------|---------|------------|
| Build firmware | `@odrive-qa Build firmware for board v3.6` | ODrive-QA → odrive-qa-assistant |
| Run tests | `@odrive-qa Run the test suite` | ODrive-QA → odrive-qa-assistant |
| Implement protocol | `@odrive-engineer Add UART telemetry` | ODrive-Engineer |
| Tune controller | `@odrive-engineer Optimize velocity PI loop` | ODrive-Engineer |
| Review PCB | `@odrive-engineer Review gate driver schematic` | ODrive-Engineer |
| Generate tests | `@odrive-qa Generate unit tests for encoder` | ODrive-QA |

---

## 📋 Decision Tree: Which Agent?

```
What are you working on?
│
├─ Development (Code/Algorithms/Hardware)?
│  └─► @odrive-engineer
│     │
│     ├─ Firmware/Driver Code → odrive-engineer
│     ├─ Control Algorithms/Tuning → odrive-engineer
│     └─ PCB/Hardware Design → odrive-engineer
│
├─ Testing/Building/CI/CD?
│  └─► @odrive-qa
│     │
│     ├─ Build firmware → odrive-qa
│     ├─ Run tests → odrive-qa
│     ├─ CI/CD workflows → odrive-qa
│     └─ Releases → odrive-qa
│
└─ Multi-domain (complex)?
   └─► Let primary orchestrator handle it
```

---

## 🛑 Safety Checklist

**Before Hardware Operations:**

- [ ] Will this flash firmware to a device? → ⚠️ Confirm
- [ ] Will this change motor parameters? → ⚠️ Confirm
- [ ] Will this spin a motor? → ⚠️ Confirm
- [ ] Could this damage hardware? → ⚠️ Confirm

**Commands Requiring Confirmation:**
- `make flash`
- `make erase`
- `odrivetool` (device config)
- Motor calibration procedures
- High voltage/current tests

---

## 📖 Must-Read Before Coding

**For C++ code:**
1. `.github/instructions/general_codebase_standards.instructions.md`
2. `.github/instructions/cpp_coding_standards.instructions.md`
3. `.github/instructions/header_file_rules.instructions.md` (headers only)

**For Python code:**
1. `.github/instructions/general_codebase_standards.instructions.md`
2. `.github/instructions/python_coding_standards.instructions.md`

---

## ✅ Code Quality Checklist

Every code change must verify:

### Naming
- [ ] PascalCase for classes/structs
- [ ] camelCase for functions/variables
- [ ] camelCase_ for private members
- [ ] kPascalCase for constants

### Modern C++17
- [ ] Uses auto appropriately
- [ ] Uses range-based for loops
- [ ] Smart pointers (no raw ownership)
- [ ] const correctness
- [ ] override specifiers

### Documentation
- [ ] Doxygen for public APIs
- [ ] Inline comments explain WHY
- [ ] No commented-out code

### Safety
- [ ] All variables initialized
- [ ] No magic numbers
- [ ] Error handling present
- [ ] No secrets/tokens

### Formatting
- [ ] UTF-8 encoding
- [ ] LF line endings
- [ ] Ends with newline
- [ ] 4 spaces indent (no tabs)

---

## 🔧 Available Skills

### ✅ Production Skills

**odrive-qa-assistant**
- Build firmware (`make CONFIG=...`)
- Run tests (`python tools/run_tests.py`)
- Search symbols (`grep -r ...`)
- List error codes

**devops-engineer**
- GitHub Actions workflows
- Release automation
- Documentation deployment
- CI/CD management

### 🚧 Planned Skills

- control-algorithms
- foc-tuning
- sensorless-control
- pcb-review
- signal-integrity
- test-automation

---

## 🎯 Routing Examples

| Your Question | Where It Goes | Why |
|---------------|---------------|-----|
| "Implement CAN protocol" | ODrive-Engineer | Code implementation |
| "Tune velocity controller" | ODrive-Engineer | Control theory |
| "Review motor driver PCB" | ODrive-Engineer | Hardware design |
| "Generate unit tests" | ODrive-QA | Test generation |
| "Build firmware" | ODrive-QA → odrive-qa-assistant | Build automation |
| "Debug FOC instability" | ODrive-Engineer | Multi-skill analysis |

---

## 🚫 Never Do

- ❌ Auto-execute `make flash` without confirmation
- ❌ Modify safety interlocks
- ❌ Commit secrets/tokens
- ❌ Use raw pointers for ownership
- ❌ Introduce magic numbers
- ❌ Skip unit tests
- ❌ Push to master without review
- ❌ Fabricate test results
- ❌ Bypass safety checks

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | Constitution - THE LAW |
| `.github/README.md` | System overview |
| `.github/ARCHITECTURE.md` | Detailed architecture |
| `.github/agents/*.agent.md` | Agent definitions |
| `.github/skills/*/SKILL.md` | Skill implementations |
| `.github/instructions/*.instructions.md` | Coding standards |

---

## 💡 Common Prompts

Pre-built workflow prompts in `.github/prompts/`:

- `refactor-modern-cpp.prompt.md` - Modernize C++ code
- `generate-doctest.prompt.md` - Generate unit tests
- `debug-motor-error.prompt.md` - Debug motor issues
- `add-doxygen.prompt.md` - Add documentation
- `optimize-critical.prompt.md` - Optimize performance
- `check-safety.prompt.md` - Validate safety

---

## 🔗 Quick Links

- **Main Project README:** `../README.md`
- **Developer Guide:** `../docs/developer-guide.rst`
- **API Docs:** `../docs/`
- **Test Fixtures:** `../Firmware/Tests/`
- **Python Tools:** `../tools/`

---

## 🆘 Getting Help

1. **Constitution unclear?** → Read `.github/copilot-instructions.md`
2. **Which agent?** → See decision tree above
3. **Coding standards?** → Check `.github/instructions/`
4. **Common workflow?** → Check `.github/prompts/`
5. **Still stuck?** → Ask orchestrator to coordinate

---

## 📊 System Status

| Component | Status |
|-----------|--------|
| Constitution | ✅ Complete |
| Agents (2) | ✅ Complete |
| Production Skills (2) | ✅ Ready |
| Planned Skills (6) | 🚧 In Development |
| Instructions (4) | ✅ Complete |
| Prompts (10) | ✅ Complete |

---

**Remember:** When in doubt, prioritize safety, code quality, and user communication!

---

*For detailed information, see `.github/README.md` and `.github/ARCHITECTURE.md`*
