# Copilot Instructions for Hackathon Planning

## Project Overview

This workspace contains planning materials for a **2-day GitHub Copilot hackathon**. The audience is 100 embedded C++ and or C# developers (intermediate to advanced) in Phoenix, Arizona.

**Overall Objective**: Migrate existing applications into an agentic pattern for developer acceleration.

## Instructors

| Initials | Name |
|----------|------|
| TM | Tammy McClellan |
| TI | Tom Iverson |
| GB | Gaurav Bhardwaj |

## Document Purpose & Structure

Working guide for instructors to design and deliver the planned lessons. Use this to align constraints, author lesson materials, and reference the agenda.

## How to Use This Doc
- Read the agenda for timing and owners: [lessons/01-welcome-agenda/agenda.md](lessons/01-welcome-agenda/agenda.md). Request agenda changes before editing.
- For each lesson, create/update README, examples, exercises, and solutions under the lesson folder (pattern below).
- Apply the Lesson Content Guidelines and Agent Focus Constraints to every prompt or exercise.
- Embed `#file:` context when asking Copilot to generate or refactor code; include acceptance criteria.
- Link one relevant Microsoft Learn page per lesson for deeper study (advanced-focused).

## Key Constraints (From Customer Requirements)

- **Language focus**: C++, C, Ada for embedded/RTOS development
- **Editor**: VS Code only (not Visual Studio)
- **Audience level**: Intermediate to advanced (skip basics)
- **Day 1**: Training on GitHub Copilot features, agentic development
- **Day 2**: Hands-on hack with their own projects
- **Reference repos**: [ODrive](https://github.com/odriverobotics/ODrive), [Marlin](https://github.com/MarlinFirmware/Marlin)
- **Recordable**: Day 1 sessions can be recorded for playback

## Lesson Content Guidelines

Each lesson should follow a **hands-on first** approach:
- **Focus on key concepts** - Bullet points, simple explanations for complex topics.
- **Prioritize examples** - Show, don't tell; use [ODrive repo](https://github.com/odriverobotics/ODrive) when applicable
- **Hands-on activity** - Some of lesson time is participant practice
- **Clear success criteria** - What should they accomplish by end of lesson?
- Always link a official Microsoft Learn site where appropriate for deeper study.

> **Note**: Instructors are not C++ developers. Keep C++ specifics to common patterns participants already know. Focus on Copilot techniques, not teaching C++.

## Agent Focus Constraints

When guiding participants to build agentic workflows, enforce these constraints to keep the agent productive:

1. **Scope to single responsibility** - Each agent task should do ONE thing well
2. **Provide explicit context** - Always include relevant files via `#file:` references
3. **Set language/framework boundaries** - Specify C++17/20, no exceptions, static allocation
4. **Define acceptance criteria** - Tell the agent what "done" looks like
5. **Use iterative refinement** - Small changes, frequent validation, not big-bang generation
6. **Constrain output format** - Request specific patterns (RAII wrappers, state machines, HAL interfaces) when possible.
7. **Include safety guardrails** - Require const correctness, bounds checking, volatile for hardware registers

**Example constraint prompt for embedded C++:**
```
Generate a RTOS task wrapper using:
- Static allocation only (no new/malloc)
- No exceptions (use error codes)
- MISRA C++ compliant naming
- Include volatile for hardware register access
```

## Day 2 Hack Success Criteria

Teams should demonstrate:
- **Before/After comparison** - Show original code vs. Copilot-assisted modernization
- **Agentic workflow used** - Which steering docs, prompts, or agent patterns applied
- **Quantifiable improvement** - Lines refactored, tests added, docs generated, bugs fixed
- **Lessons learned** - What worked, what didn't, tips for others

## Day 2 Evidence Capture
- Before/after: identify target files and capture git diff snippets or screenshots.
- Metrics: lines refactored, tests added, defects fixed, docs generated.
- Agent usage: note prompts/agents/skills invoked and context provided.
- Demo-ready summary: problem, approach, result, next steps (3-5 bullets).

## Content Conventions

When editing agenda documents:
- Use markdown tables for session breakdowns with `| Sub-Topic | Focus | Time |` format
- Include total time in section headers: `#### Topic Name (Start - End) — XX min`
- Add speaker initials (TM, TI, GB) after timing when assigned
- Mark action items with `- [ ]` checkbox format
- Use `**☕ Break**` and `**🍽️ Lunch**` markers for schedule breaks
- Identify any prerequisites for development setup in the agenda doc.
- Specify commands that can be copied directly to ease of use.

## Workshop Structure Pattern

Each lesson module in `lessons/` should follow:
```
lessons/XX-topic-name/
├── README.md          # Learning objectives (brief), key concepts, hands-on instructions
├── examples/          # C++ code samples to demonstrate concepts
├── exercises/         # Starter code for hands-on practice
└── solutions/         # Completed exercise solutions
```

**Lesson README.md template:**
```markdown
# Lesson Title

## Objectives (2-3 bullets max)
## Key Concepts (bullet points, not prose)
## Hands-On Activity
### Setup
### Steps
### Success Criteria
## Reference Links (optional)
```

## Authoring Checklist (per lesson)
- Set 2-3 objectives and 3-5 key concepts (no prose walls).
- Pick a concrete code sample from ODrive/Marlin; keep to C++17/20, static allocation, no exceptions.
- Write hands-on steps with commands attendees can copy; call out prerequisites.
- Define success criteria and how to validate (build/test output, diff, or runtime check).
- Add one Microsoft Learn link and any repo-specific references.
- Provide at least one agent-friendly prompt including `#file:` context and acceptance criteria.

## Ready-to-Use Prompt Patterns (embedded)
Drop these into exercises and adjust file names as needed.

```
// Generate bounds-checked SPI read helper
You are generating embedded C++17 code. Requirements:
- Static allocation only; no exceptions; return error codes.
- Mark hardware registers volatile; ensure const correctness.
- Add unit-testable pure functions where possible.
Context: #file:Firmware/Drivers/spi_driver.cpp
Acceptance: function returns status enum; buffers checked for length; no dynamic memory; MISRA-friendly naming.
```

```
// Refactor ISR-safe ring buffer
Goal: make ring buffer lock-free for ISR use.
Constraints: C++17, no exceptions, static storage, wrap indices safely, volatile head/tail, bounds check writes.
Context: #file:Firmware/MotorControl/ring_buffer.h
Acceptance: preserves existing public API; adds overflow handling; unit test sketch included.
```

```
// HAL state machine skeleton
Generate a state machine for motor startup → calibrate → run → fault.
Constraints: RAII guard for peripherals, no dynamic alloc, no exceptions, constexpr state table where possible.
Context: #file:Firmware/MotorControl/motor_controller.cpp
Acceptance: clearly separated states/events, fault-safe default, logging hook, compile without warnings.
```

## The agenda is built.

DO NOT modify the agenda without getting explicit approval from the author.

To request changes, annotate or comment in [lessons/01-welcome-agenda/agenda.md](lessons/01-welcome-agenda/agenda.md) and confirm with TM/TI/GB before editing.

## Time Budget

- Each day: 8:00 AM - 3:00 PM (7 hours)
- Morning sessions: ~4 hours
- Afternoon sessions: ~2.5 hours
- Include 15-min breaks and 45-min lunch

## Don't Include

- Azure web app development (excluded per customer request)
- Basic Copilot intro content (audience is intermediate+)
- Git/GitHub fundamentals (assumed knowledge)
- Long prose explanations (keep it concise and clear, hands-on focused)

## Ownership
Maintainers: TM, TI, GB. Submit updates via PR or tracked change with their approval.

## Quick Reference Links
- GitHub Copilot for VS Code: https://learn.microsoft.com/training/modules/get-started-github-copilot-visual-studio-code/
- GitHub Copilot Chat in VS Code: https://learn.microsoft.com/training/modules/use-github-copilot-chat-vs-code/
- C++ in VS Code: https://learn.microsoft.com/cpp/build/vscpp-step-0-installation
- GitHub Copilot CLI: https://learn.microsoft.com/training/modules/use-github-copilot-cli/