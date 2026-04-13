---
name: review-code
description: 'Structured code review using the ODrive Reviewer agent with a checklist'
agent: ODrive Code Reviewer
tools: ['read', 'search']
---
# Review Code

Perform a structured code review of the specified file or changes.

## Instructions

Review the target file against all applicable coding standards. Fill in the checklist below with findings.

### Input Required
- **Target**: ${{FILE_OR_DIFF}} (file path, or "changed files" for git diff)

### Review Checklist

#### Safety & Correctness
- [ ] No memory leaks or buffer overflows
- [ ] No null pointer dereferences
- [ ] Integer overflow/underflow handled
- [ ] All error paths handled

#### Interrupt & Thread Safety
- [ ] `volatile` used for ISR-shared variables
- [ ] Atomics or critical sections for shared data
- [ ] No blocking in ISR context
- [ ] ISRs are short — heavy work deferred to main loop

#### Embedded Constraints
- [ ] No dynamic allocation in real-time code paths
- [ ] Bounded execution time on all paths
- [ ] Hardware access abstracted properly
- [ ] DMA/peripheral state managed with RAII

#### Style & Standards
- [ ] Naming follows conventions (PascalCase classes, camelCase functions)
- [ ] Comments explain WHY, not WHAT
- [ ] Functions under 50 lines
- [ ] No magic numbers
- [ ] `const` correctness applied
- [ ] `[[nodiscard]]` on important return values

#### Motor Control Specific
- [ ] Units are consistent and documented
- [ ] Control loop timing is deterministic
- [ ] Safe state handling on fault

### Output Format

For each issue found, report:
```
**[SEVERITY]** file.cpp:LINE — Description
  Suggestion: How to fix
```

Severity levels: `CRITICAL` (must fix), `WARNING` (should fix), `INFO` (suggestion)
