---
name: 'General Codebase Standards'
description: 'Universal cross-cutting standards for file handling, version control, documentation, security, and code quality that apply to ALL files regardless of programming language. For language-specific rules, see cpp_coding_standards, python_coding_standards, and header_file_rules.'
applyTo: '**'
---

# General Codebase Standards

> **Scope**: This file defines universal rules for the entire codebase. Language-specific conventions (C++, Python, headers) are defined in their respective instruction files.

---

## File Formatting & Encoding

| Aspect | Requirement |
|--------|-------------|
| **Encoding** | UTF-8 (no BOM) for all text files |
| **Line Endings** | Unix-style LF (`\n`) — configure `.gitattributes` to enforce |
| **Trailing Whitespace** | Remove from all lines before commit |
| **Final Newline** | Every file must end with exactly one newline character |
| **Indentation** | Use spaces (not tabs) — 4 spaces for Python, 4 for C/C++ |
| **Max Line Length** | 120 characters (soft limit), 140 absolute max |

```gitattributes
# .gitattributes - Enforce line endings
* text=auto eol=lf
*.{cmd,bat} text eol=crlf
```

---

## File & Directory Naming

- **Cross-Platform Safety**: Names must be case-insensitive unique (no `File.txt` + `file.txt`)
- **Valid Characters**: `[a-zA-Z0-9_-.]` only — no spaces, no special characters
- **Path Length**: Keep full paths under 200 characters for Windows compatibility
- **Descriptive Names**: Use meaningful names; avoid generic names like `temp`, `test`, `stuff`

```
✅ GOOD                        ❌ BAD
motor_controller.cpp           Motor Controller.cpp   (spaces)
spi_driver_v2.h                SPIDriver(new).h       (parentheses)
test_encoder_calibration.py    test.py                (non-descriptive)
```

---

## Version Control Best Practices

### Commit Messages
Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <short summary>

<optional body>

<optional footer>
```

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code restructure (no behavior change) |
| `test` | Adding/updating tests |
| `chore` | Build, CI, tooling changes |
| `perf` | Performance improvement |

**Examples:**
```
feat(motor): add velocity feedforward compensation
fix(encoder): resolve overflow in position tracking (#142)
docs(readme): update build instructions for ARM toolchain
refactor(communication): extract CAN message parsing to separate module
```

### Branch Naming
```
feature/<ticket>-<short-description>
bugfix/<ticket>-<short-description>
hotfix/<ticket>-<short-description>
chore/<description>

Example: feature/ODR-123-add-sensorless-mode
```

### What NOT to Commit
- Build artifacts (`*.o`, `*.elf`, `*.bin`, `*.hex`)
- IDE-specific files (`.vscode/settings.json` with personal paths)
- Dependency folders (`node_modules/`, `__pycache__/`, `.venv/`)
- OS files (`.DS_Store`, `Thumbs.db`)

---

## Comments & Documentation Standards

### General Rules
- **Language**: All comments and documentation in **English**
- **Accuracy**: Keep comments synchronized with code — outdated comments are worse than none
- **Purpose**: Explain *why*, not *what* (code shows what)

### TODO/FIXME Format
Use structured annotations for trackability:

```cpp
// TODO(username): Implement watchdog timer reset logic
// FIXME(ODR-456): Race condition in interrupt handler - needs mutex
// HACK(username): Temporary workaround until v2.0 refactor
// NOTE: This assumes little-endian byte order
```

### Commented-Out Code
- **Do NOT commit commented-out code** — use version control history instead
- If code must be disabled, use preprocessor guards with explanation:

```cpp
// ❌ BAD - Orphaned commented code
// old_function_call();
// for (int i = 0; i < 10; i++) { do_thing(); }

// ✅ OK - Explicit feature flag with reason
#ifdef ENABLE_EXPERIMENTAL_SENSORLESS
    runSensorlessMode();
#endif
```

---

## Security & Safety Requirements

### Secrets & Credentials
| Rule | Details |
|------|---------|
| **No Hardcoded Secrets** | Never commit API keys, tokens, passwords, or certificates |
| **Environment Variables** | Use `.env` files (gitignored) or secure vaults |
| **Example Files** | Provide `.env.example` with placeholder values |
| **Pre-commit Hooks** | Use tools like `git-secrets` or `gitleaks` to scan |

```cpp
// ❌ NEVER
const char* API_KEY = "sk-abc123secretkey";

// ✅ CORRECT
const char* API_KEY = std::getenv("ODRIVE_API_KEY");
```

### Personally Identifiable Information (PII)
- **No real PII** in test data, comments, logs, or examples
- Use synthetic/anonymized data: `user@example.com`, `John Doe`, `555-0100`

### Input Validation
- Validate all external inputs (serial, CAN, USB, file I/O)
- Assume all inputs are potentially malicious or malformed
- Bounds-check array indices and buffer sizes

---

## Code Quality & Maintainability

### DRY (Don't Repeat Yourself)
- Extract duplicated logic into functions/modules
- Use constants for magic numbers

```cpp
// ❌ BAD
if (voltage > 56.0f) { /* ... */ }
if (voltage > 56.0f) { /* ... */ }  // Duplicated magic number

// ✅ GOOD
constexpr float kMaxVoltage = 56.0f;
if (voltage > kMaxVoltage) { /* ... */ }
```

### Single Responsibility
- Each function/class should do ONE thing well
- If a function exceeds 50 lines, consider splitting it
- If a file exceeds 500 lines, consider modularizing

### Error Handling
- Handle errors explicitly — avoid silent failures
- Use appropriate mechanisms (return codes in C, exceptions in Python, `std::optional` in C++)
- Log errors with sufficient context for debugging

### Code Review Readiness
Before submitting code for review, verify:
- [ ] Code compiles without warnings (`-Wall -Wextra -Werror`)
- [ ] All tests pass locally
- [ ] No commented-out code or debug prints left behind
- [ ] TODOs reference a ticket or have a clear owner
- [ ] Documentation updated if public API changed

---

## Testing Standards

### Test File Naming
- Mirror source file structure: `motor_controller.cpp` → `test_motor_controller.cpp`
- Prefix with `test_` (Python) or suffix with `_test` (C++)

### Test Principles
- **Isolated**: Tests should not depend on each other's state
- **Deterministic**: Same input = same result (avoid random seeds without control)
- **Fast**: Unit tests should complete in milliseconds
- **Descriptive**: Test names should describe behavior being verified

```cpp
// ✅ GOOD test name
TEST(MotorController, ReturnsErrorWhenVoltageExceedsLimit)

// ❌ BAD test name  
TEST(MotorController, Test1)
```

---

## Build & CI Requirements

- All code must compile cleanly with **no warnings** on CI
- Static analysis tools (clang-tidy, cppcheck, pylint) must pass
- Code coverage targets: aim for >80% on critical paths
- CI must validate:
  - Build (Debug + Release)
  - Unit tests
  - Linting/formatting
  - Documentation generation (if applicable)

---

## Cross-References

| Topic | See File |
|-------|----------|
| C++ naming, formatting, modern practices | `cpp_coding_standards.instructions.md` |
| Header file includes, guards, structure | `header_file_rules.instructions.md` |
| Python PEP 8, docstrings, type hints | `python_coding_standards.instructions.md` |
