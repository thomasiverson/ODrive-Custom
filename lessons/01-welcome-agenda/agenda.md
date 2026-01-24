# GitHub Copilot 2-Day Hackathon Agenda Proposal

**Audience:** 100 C++ Developers (Intermediate to Advanced) - Primarily embedded systems focus, some Ada developers  
**Location:** Phoenix, Arizona (In-Person)  
**Focus:** C++ Development with GitHub Copilot (General techniques + Embedded patterns)  
**Schedule:** 8:00 AM - 3:00 PM (Both Days)  
**Workshop Repo:** 🔴 GitHub repo with lessons, examples, and hands-on exercises  
**Instructor Guide:** See [.github/copilot-instructions.md](.github/copilot-instructions.md) for lesson-authoring constraints and checklist.

---

## Day 1: GitHub Copilot for Embedded C/C++ Development

### Morning Session (8:00 AM - 12:00 PM)

#### 1. Opening & Setup (8:00 - 8:40) — 40 min - TM
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Welcome & Objectives | Hackathon goals, Day 2 preview | 10 min |
| Workshop Materials Setup | Download ZIP from GitHub, extract, open in VS Code | 10 min |
| Workspace Validation | Verify VS Code + C/C++ extensions + Copilot enabled | 15 min |
| Copilot Architecture Quick Overview | Context windows, model basics | 5 min |

#### 2. Basic Feature Overview (8:40 - 9:25) — 45 min - TI
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Copilot Chat Modes | Ask, Edit, Agent mode - when to use each | 10 min |
| Chat Participants & Slash Commands | @workspace, @terminal, /fix, /explain, /tests, /doc | 10 min |
| Inline Chat & Copilot Edits | In-editor completions, multi-file editing | 10 min |
| **Hands-On:** Explore Features | Try each mode with simple walkthrough of VS Code | 15 min |

#### 3. Planning & Steering Documents (9:25 - 10:25) — 60 min - GB
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Why Planning Matters | Front-loading context improves output quality | 10 min |
| copilot-instructions.md | Repo-level coding standards, constraints, patterns | 10 min |
| Prompt Files (.prompt.md) | Reusable task templates for common workflows | 10 min |
| Custom Agents (.agent.md) | Specialized agent profiles for domain-specific tasks | 12 min |
| Agent Skills (SKILL.md folders) | Self-contained instruction folders with bundled resources | 10 min |
| **Hands-On:** Create Steering Docs | Build copilot-instructions.md, custom agent, and skill folder | 8 min |


**☕ Break (10:25 - 10:40) — 15 min**

#### 4. Agentic Development & Context Engineering (10:40 - 11:25) — 45 min - TI
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| What is an Agentic Developer? | Mindset: orchestrating AI vs. writing every line | 8 min |
| Context Engineering Best Practices | What to include, file references, @-mentions | 12 min |
| Decomposition Strategies | Breaking complex tasks into AI-friendly chunks | 8 min |
| Iterative Refinement Workflow | Review → Refine → Regenerate cycles | 5 min |
| **Hands-On:** Agentic Refactoring | Refactor a legacy module using custom agent + skill | 12 min |

#### 5. C++ Best Practices with Copilot (11:25 - 12:15) — 50 min - GB
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Modern C++ Patterns | RAII, smart pointers, templates, const correctness, move semantics | 12 min |
| Embedded C++ Specifics | Static allocation, no exceptions, ISR handlers, volatile correctness | 12 min |
| RTOS & Hardware Patterns | State machines, HAL abstractions, task synchronization, peripheral drivers | 10 min |
| **Hands-On:** Generate C++ Components | Create embedded patterns with Copilot (LED driver, state machine) | 16 min |

> **Includes:** Unit testing with `/tests` command, doctest framework, mocking, TDD workflow, `[[nodiscard]]`, `constexpr`, strong types

> **For Ada developers:** Examples translate to Ada tasking, package design, and contract programming

**🍽️ Lunch (12:15 - 1:00) — 45 min**

---

### Afternoon Session (1:00 PM - 3:00 PM)

#### 6. Debugging with Copilot (1:00 - 1:45) — 45 BG
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| @terminal for Build Errors | Interpreting compiler/linker errors | 10 min |
| /fix for Bug Resolution | Using Copilot to diagnose and fix defects | 10 min |
| Common C++ Debugging | Logic errors, memory issues, null pointers, off-by-one errors | 10 min |
| **Hands-On:** Debug Session | Fix bugs in example C++ code (general algorithms + one embedded example) | 15 min |

#### 7. GitHub Copilot CLI (1:45 - 2:30) — 45 min - TM
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| CLI Installation & Setup | ghcs (suggest) and ghce (explain) commands | 10 min |
| Command Generation | Build commands, test execution, deployment scripts | 10 min |
| Shell Script Generation | Automating development workflows via CLI | 10 min |
| **Hands-On:** CLI Exercises | Generate build/test commands for C++ projects | 15 min |

#### 8. Parallel Agents & Cloud Agents (2:30 - 2:50) — 20 min - TI
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Running Multiple Agents | Parallel workflows, different tasks simultaneously | 8 min |
| Cloud/Background Agents | Delegating async tasks, code review automation | 7 min |
| **Hands-On:** Multi-Agent Demo | Run parallel tasks on multi-module C++ project | 5 min |

#### 9. Foundry Local Demo (2:50 - 3:05) — 15 min - TM
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| What is Foundry Local? | Local model runtime for offline AI, air-gapped environments | 3 min |
| Quick Demo | Local code assistance without cloud connectivity | 10 min |
| Use Cases & Setup | Edge inference, data privacy - self-guided setup materials | 2 min |

**Foundry Local Key Points:**
- Runs small models locally (Phi, etc.) without cloud connection
- Ideal for air-gapped environments, edge inference, data privacy requirements
- Available small models suitable for C++ development

> 📘 **Self-Guided Setup:** Full installation instructions and examples available in `lessons/08-foundry-local/` for attendees to explore after the workshop.

#### 10. Wrap-Up & Day 2 Preview (3:05 - 3:15) — 10 min - TM
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Day 1 Recap | Key techniques summary | 4 min |
| Day 2 Hack Preview | What to bring, team formation, tracks | 4 min |
| Q&A | Quick questions | 2 min |

---

## Day 2: Hack Day - Modernize Your Projects

### Morning Session (8:00 AM - 12:00 PM)

#### 1. Hack Day Kickoff (8:00 - 8:30) — 30 min
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Day 2 Objectives & Rules | Hack format, judging criteria, prizes | 10 min |
| Project Selection Guidance | How to scope a half-day modernization effort | 10 min |
| Team Formation & Coach Intro | Self-organize into teams of 3-5, meet coaches | 10 min |

#### 2. Hack Sprint 1 (8:30 - 10:00) — 90 min
| Activity | Focus | Time |
|----------|-------|------|
| Project Setup | Teams configure workspace, create copilot-instructions.md, identify targets | 30 min |
| Active Hacking | Apply Day 1 techniques to real embedded projects | 60 min |

> Teams can choose general C++ modernization or embedded-specific challenges

**☕ Break (10:00 - 10:15) — 15 min**

#### 3. Hack Sprint 2 (10:15 - 11:45) — 90 min
| Activity | Focus | Time |
|----------|-------|------|
| Continued Hacking | Deep work on modernization tasks | 75 min |
| Mid-Sprint Check-In | Quick team status, blocker resolution with coaches | 15 min |

**🍽️ Lunch (11:45 - 12:30) — 45 min**

---

### Afternoon Session (12:30 PM - 3:00 PM)

#### 4. Hack Sprint 3 + Demo Prep (12:30 - 2:00) — 90 min
| Activity | Focus | Time |
|----------|-------|------|
| Final Hacking Push | Complete modernization, polish results | 60 min |
| Demo Preparation | Teams prepare 3-min presentations (before/after) | 30 min |

#### 5. Team Demonstrations (2:00 - 2:45) — 45 min
| Activity | Focus | Time |
|----------|-------|------|
| Team Demos | 3 min per team, showcase before/after | 35 min |
| Audience Q&A | Quick cross-team learning | 10 min |

> **Note:** With 100 developers in teams of 3-5, expect ~20-25 teams. Select top 10-12 for demos or run parallel demo tracks.

#### 6. Closing & Awards (2:45 - 3:00) — 15 min
| Sub-Topic | Focus | Time |
|-----------|-------|------|
| Judging & Awards | Best modernization, most creative, best use of Copilot | 5 min |
| Key Takeaways | Recap techniques, resources for continued learning | 5 min |
| Next Steps & Feedback | Support channels, quick feedback survey | 5 min |

---

### Recording
- ✅ Sessions can be recorded for playback (per customer request)
- Recommend recording Day 1 instructional content only
- Day 2 hack sessions typically not recorded (IP concerns)

### Materials Needed
- Pre-configured VS Code workspaces with C/C++ extensions
- Workshop repo with lessons, examples, and exercises
- GitHub Copilot licenses verified for all 100 attendees
- USB drives with ZIP backup for offline fallback

### Coaching Support
- Recommend 4-5 coaches for Day 2 hack sessions
- 1 coach per ~20-25 developers

---

## Open Questions for Customer

1. **Day 2 projects:** Will teams bring pre-selected projects or choose on-site?
2. **Demo format:** Select top 10-12 teams, or run parallel demo tracks?
3. **Judging panel:** Customer leadership involvement in hack judging?
4. **Copilot CLI:** Can attendees install CLI tools (may require admin rights)?
5. **Network capacity:** Can venue handle 100 simultaneous Copilot users?

