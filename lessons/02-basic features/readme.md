# Basic Feature Overview: GitHub Copilot in VS Code

**Session Duration:** 45 minutes  
**Audience:** Embedded/C++ Developers/Project Managers/QA engineers/Firmware Engineers  
**Environment:** Windows, VS Code  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Get Started with Chat in VS Code](#get-started-with-chat-in-vs-code)
- [Essential Keyboard Shortcuts](#essential-keyboard-shortcuts)
- [Agenda](#agenda-basic-feature-overview-45-min)
- [Speaker Instructions](#speaker-instructions)
- [Participant Instructions](#participant-instructions)
- [Quick Reference](#quick-reference-github-copilot-chat)
- [Tips for Effective Prompts](#tips-for-effective-prompts)
- [Language Models](#explore-different-language-models)
- [Customization Options](#customize-your-chat-experience)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Prerequisites

Before starting this session, ensure you have:

- **Visual Studio Code** installed (latest version recommended)
- **GitHub Copilot subscription** (or Copilot Free plan with monthly limits)
- Active internet connection for AI model access
- A GitHub account for authentication

### Verify Your Setup

1. **Check VS Code installation:**
   - Open VS Code
   - Press `Ctrl+Shift+P` and type "About" to verify version

2. **Verify Copilot subscription:**
   - Visit https://github.com/settings/copilot
   - Ensure you have an active subscription or free plan

3. **Install GitHub Copilot extension:**
   - Open VS Code Extensions (Ctrl+Shift+X)
   - Search for "GitHub Copilot"
   - Install both "GitHub Copilot" and "GitHub Copilot Chat" extensions

---

## Get Started with Chat in VS Code

Chat in Visual Studio Code enables you to use natural language for AI-powered coding assistance. Ask questions about your code, get help understanding complex logic, generate new features, fix bugs, and more - all through a conversational interface.

### Access Chat in VS Code

VS Code provides three ways to start an AI chat conversation, each optimized for different workflows and tasks:

#### 1. Chat View
Press **Ctrl+Alt+I** to open the Chat view in a dedicated side panel. If you prefer a larger workspace for chat, you can open it as an editor tab by selecting **New Chat Editor** from the chat menu or as a separate window by selecting **New Chat Window**.

**Use the Chat view for:**
- Ongoing, multi-turn chat conversations
- Switching between different agents to ask questions, make code edits across files, or start autonomous coding workflows
- Working on features that span multiple files
- Planning and implementing complex changes

#### 2. Inline Chat
Press **Ctrl+I** to start a chat conversation directly in your editor or terminal.

**Use inline chat for:**
- Getting suggestions inline, right where you're working
- Understanding code in your current context
- Getting help with terminal commands and output

#### 3. Quick Chat
Press **Ctrl+Shift+Alt+L** to open a lightweight chat overlay.

**Use quick chat for:**
- Quick questions that don't require extended conversation
- Getting answers without changing your current view
- Looking up information while maintaining focus on your work

---

## Essential Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open the Chat view |
| `Ctrl+I` | Enter voice chat prompt in Chat view / Start inline chat in editor or terminal |
| `Ctrl+I` (hold) | Start inline voice chat |
| `Ctrl+N` | Start a new chat session in Chat view |
| `Ctrl+Shift+I` | Switch to using agents in Chat view |
| `Ctrl+Shift+Alt+L` | Open Quick Chat |
| `Ctrl+Alt+.` | Show the model picker to select a different AI model |
| `Tab` | Accept inline suggestion or navigate to next edit suggestion |
| `Escape` | Dismiss inline suggestion |
| `F2` | Get AI-powered suggestions when renaming symbols |

---

## Agenda: Basic Feature Overview (45 min)

| Sub-Topic                        | Focus                                               | Time   |
|----------------------------------|-----------------------------------------------------|--------|
| Copilot Chat Modes               | Ask, Edit, Agent mode - when to use each            | 10 min |
| Chat Participants & Slash Cmds   | @workspace, @terminal, /fix, /explain, /tests, /doc | 10 min |
| Inline Chat & Copilot Edits      | In-editor completions, multi-file editing           | 10 min |
| **Hands-On:** Explore Features   | Try each mode with walkthrough in VS Code           | 15 min |

---

## Speaker Instructions

### 1. Demo: Copilot Chat Modes

- **Ask Mode:**
  - Use the Chat panel to ask questions about the codebase, architecture, or debug issues.
  - Example prompts:
    1. "Explain this project in simple, layman's terms. What is the high-level functionality? Provide a tour of the folder structure and explain the key external dependencies."
    2. "Explain the high-level architecture of `Firmware/MotorControl`. How do the `Axis`, `Motor`, and `Encoder` classes interact during the control loop?"
    3. "How is the custom fibre protocol implemented in #file:fibre.cpp? Explain how an object method on the firmware side is exposed to the Python client."
    4. "I am seeing `ERROR_OVERSPEED` in my logs. Look at #file:axis.cpp and #file:motor.cpp. What specific conditions trigger this error and how can I disable it safely?"
    5. "What is the pin mapping for the SPI interface in #file:board.cpp? Can you list the GPIO pins used for the DRV8301?"
    6. "How does the build system work in this repo? Detailed check of #file:Tupfile.lua and explain how the firmware binary is generated from the source files."

- **Edit Mode:**
  - Use Inline Chat (Ctrl+I) to generate/refactor code, add documentation, or create scripts/tests.
  - Example prompts:
    1. "Add a new configuration variable `float soft_stop_rate` to the `ControllerConfig` struct. Then, update the `update()` method in `controller.cpp` to use this rate to decelerate the velocity setpoint to zero when the axis state changes to `IDLE`."
    2. "Create a new test case using the `doctest` framework that verifies the `SVM` utility function in #file:utils.cpp handles all six sextants correctly with edge-case inputs."
    3. "Add Doxygen-style comments to the `on_measurement` function in #file:foc.cpp, explaining the Clarke transform and the current measurement processing."
    4. "Write a Python script using `odrive.enums` that connects to a generic ODrive, configures the plotter, and graphs `axis0.motor.current_control.Iq_measured` and `axis0.motor.current_control.Iq_setpoint` in real-time."
    5. "Optimize the `SVM` function in #file:utils.cpp using SIMD intrinsics or faster math approximations if possible, while maintaining readability and accuracy."

- **Agent Mode:**
  - Use for multi-step, cross-file, or research tasks. Copilot can plan, research, and execute complex changes.
  - Example prompts:
    1. "Build the ODrive firmware by running the `tup` build command in the terminal. If there are compilation errors, analyze the error output, identify which files are causing issues, examine the problematic code, suggest fixes, apply them, and then rebuild to verify the fixes work."
    2. "Implement a 'Stall Detection' feature. Research how other motor controllers detect stalls. Modifications should likely involve #file:motor.cpp to monitor back-EMF vs current. Create a plan, then add the config flag and the detection logic."
    3. "Create a new test plan in `tools/integration_tests/` that uses the `odrivetool` library. It should sequence a full calibration, enter closed loop control, perform a sinusoidal position move, and verify the final position error is within tolerance."
    4. "I want to port the `Arduino/ArduinoI2C` library to work with an STM32-based Arduino core. Analyze #file:ArduinoI2C.ino and identify which hardware-specific AVR registers or libraries need to be abstracted."
    5. "Find all instances of raw `printf` debug statements across the `Firmware/` directory. Replace them with a new macro `ODRIVE_LOG()` that respects a compile-time log level defined in #file:freertos_vars.h."
    6. "Read #file:docs/error-codes.rst and compare it against the actual error enums defined in #file:odrive-interface.yaml. List any discrepancies where the documentation is missing new error codes added to the code."
    

### 2. Demo: Chat Participants & Slash Commands

#### Chat Participants (@-mentions)
Chat participants are prefixed with `@` and handle domain-specific requests. VS Code provides built-in participants like `@workspace`, `@terminal`, `@vscode`, and `@github`.

- **@workspace (Project-Wide Context):**
  - Use this to let Copilot scan the entire directory structure
  - "@workspace Trace where `ERROR_PHASE_RESISTANCE_OUT_OF_RANGE` is defined in #file:Firmware/odrive-interface.yaml and find all occurrences where it is raised in the C++ firmware files."
  - "@workspace Explain the `odrive_firmware_pkg` definition in #file:Firmware/Tupfile.lua. How does it gather the source files from `MotorControl/` and `communication/`?"
  - "@workspace how is authentication implemented?"

- **@terminal (Shell Integration):**
  - Ask questions about the integrated terminal or shell commands
  - "@terminal What is the specific `tup` command to build only the firmware for the v3.6 board variant? Explain the flags."
  - "@terminal scan `tools/setup.py` and generate the pip command to install all development dependencies for the Python tools."
  - "@terminal list the 5 largest files in this workspace"

- **@vscode (IDE Control):**
  - Ask about VS Code features, settings, and extension APIs
  - "@vscode How do I configure `launch.json` to attach the Cortex-Debug extension to an ST-Link OpenOCD server for this project?"
  - "@vscode Create a `tasks.json` entry to run the `tup` build command when I press Ctrl+Shift+B."
  - "@vscode how to enable word wrapping?"

- **@github (GitHub Integration):**
  - Ask about GitHub repositories, issues, and pull requests
  - "@github What are all of the open PRs assigned to me?"
  - "@github Show me the recent merged PRs from @dancing-mona"

#### Slash Commands (/-commands)
Slash commands are shortcuts to specific functionality within chat. Type `/` followed by the command name.

| Slash Command | Description |
|---------------|-------------|
| `/doc` | Generate code documentation comments |
| `/explain` | Explain a code block, file, or programming concept |
| `/fix` | Fix a code block or resolve compiler/linting errors |
| `/tests` | Generate tests for selected methods and functions |
| `/setupTests` | Get help setting up a testing framework |
| `/clear` | Start a new chat session in the Chat view |
| `/new` | Scaffold a new VS Code workspace or file |
| `/newNotebook` | Scaffold a new Jupyter notebook |
| `/search` | Generate a search query for the Search view |
| `/startDebugging` | Generate launch.json and start debugging |

#### Chat Tools (#-mentions)
Use tools in chat to accomplish specialized tasks. Type `#` followed by the tool name.

| Chat Tool | Description |
|-----------|-------------|
| `#file` | Reference a specific file as context |
| `#codebase` | Perform a code search in the current workspace |
| `#selection` | Get the current editor selection (when text is selected) |
| `#terminalSelection` | Get the current terminal selection |
| `#changes` | List of source control changes |
| `#fetch` | Fetch content from a web page |
| `#githubRepo` | Perform a code search in a GitHub repo |
| `#extensions` | Search for and ask about VS Code extensions |

---

## Participant Instructions

### 1. Try Each Copilot Mode

- **Ask Mode:**
  - Try: "Explain this project in simple, layman's terms. What is the high-level functionality? Provide a tour of the folder structure and explain the key external dependencies."

- **Edit Mode:**
  - Try: "Add a new configuration variable `float soft_stop_rate` to the `ControllerConfig` struct. Then, update the `update()` method in #controller.cpp to use this rate to decelerate the velocity setpoint to zero when the axis state changes to `IDLE`."

- **Agent Mode:**
  - Try: "Implement a 'Stall Detection' feature. Research how other motor controllers detect stalls. Modifications should likely involve #file:motor.cpp to monitor back-EMF vs current. Create a plan, then add the config flag and the detection logic."

### 2. Try Chat Participants & Slash Commands

#### Try Chat Participants:

- **@workspace:**
  - Try: "@workspace Trace where `ERROR_PHASE_RESISTANCE_OUT_OF_RANGE` is defined in #file:Firmware/odrive-interface.yaml and find all occurrences where it is raised in the C++ firmware files."

- **@terminal:**
  - Try: "@terminal What is the specific `tup` command to build only the firmware for the v3.6 board variant? Explain the flags."

- **@vscode:**
  - Try: "@vscode How do I configure `launch.json` to attach the Cortex-Debug extension to an ST-Link OpenOCD server for this project?"

#### Try Slash Commands:

- **Code documentation:**
  - Select a function in the editor
  - Press Ctrl+I and type: `/doc`

- **Fix code errors:**
  - Select code with errors
  - Press Ctrl+I and type: `/fix`

- **Generate tests:**
  - Select a function
  - Press Ctrl+I and type: `/tests`

#### Try Chat Tools:

- **Reference specific files:**
  - In Chat view: "Explain #file:motor.cpp"

- **Search codebase:**
  - In Chat view: "Find all error handling code #codebase"

---

## Quick Reference: GitHub Copilot Chat

### Essential Commands

| Command/Prompt | What It Does |
|----------------|-------------|
| `Ctrl+Alt+I` | Open the Chat view in the Secondary Side Bar |
| `Ctrl+I` | Start inline chat in editor or terminal |
| `Ctrl+Shift+Alt+L` | Open Quick Chat |
| `Ctrl+N` | Start a new chat session in Chat view |
| `Ctrl+Alt+.` | Show model picker to select different AI model |

### Chat Participants

| Participant | Description | Example |
|-------------|-------------|---------|
| `@workspace` | Project-wide context and code search | `@workspace how is authentication implemented?` |
| `@terminal` | Shell commands and terminal help | `@terminal list the 5 largest files` |
| `@vscode` | VS Code features and settings | `@vscode how to enable word wrapping?` |
| `@github` | GitHub repos, issues, and PRs | `@github What are all open PRs assigned to me?` |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/doc` | Generate code documentation |
| `/explain` | Explain code or concepts |
| `/fix` | Fix code errors |
| `/tests` | Generate unit tests |
| `/setupTests` | Setup testing framework |
| `/new` | Scaffold new workspace/file |
| `/newNotebook` | Create Jupyter notebook |
| `/startDebugging` | Generate debug config |

### Chat Tools (# commands)

| Tool | Description |
|------|-------------|
| `#file` | Reference a specific file |
| `#codebase` | Search the workspace |
| `#selection` | Current editor selection |
| `#terminalSelection` | Current terminal selection |
| `#changes` | Source control changes |
| `#fetch` | Fetch web page content |
| `#githubRepo` | Search GitHub repository |
| `#extensions` | Search VS Code extensions |

### Inline Suggestions

| Action | Description |
|--------|-------------|
| Start typing | Get inline suggestions as you code |
| `Tab` | Accept suggestion |
| `Escape` | Dismiss suggestion |
| Code comments | Provide prompt via comments (e.g., `# write a calculator class`) |

### Editor AI Features

| Action | Description |
|--------|-------------|
| `Ctrl+I` | Start inline chat in editor |
| `F2` | AI-powered symbol renaming |
| Right-click → Generate Code | Access common AI actions (explain, fix, test, review) |
| Lightbulb (Code Actions) | Fix linting/compiler errors |

### Source Control & Issues

| Feature | Description |
|---------|-------------|
| Generate commit message | AI-generated commit messages based on changes |
| PR description | Generate pull request titles and descriptions |
| `@github` participant | Query issues, PRs, and commits |

---

## Tips for Effective Prompts

1. **Add context with #-mentions:** Reference specific files (`#file`), your codebase (`#codebase`), or terminal output (`#terminalSelection`)

2. **Use / commands:** Type `/` to access common commands like `/new`, `/explain`, or create your own custom prompts

3. **Reference tools:** Type `#` followed by a tool name to extend chat capabilities

4. **Be specific and iterative:** 
   - Provide clear requirements
   - Ask follow-up questions to refine results
   - Keep prompts simple and focused

5. **Choose the right agent:**
   - **Ask**: Questions and exploration
   - **Edit**: Code modifications across files
   - **Agent**: Complex, multi-step autonomous tasks

---

## Explore Different Language Models

VS Code offers different language models optimized for different tasks:
- Some models are designed for fast coding tasks
- Others excel at complex reasoning and planning

**To change the language model:**
- Use the model picker in the chat input field (`Ctrl+Alt+.`)
- Select the model that best fits your needs

---

## Customize Your Chat Experience

Customize your chat experience to generate responses that match your coding style, tools, and developer workflow:

### Custom Instructions
Define common guidelines for tasks like generating code, performing code reviews, or generating commit messages. Custom instructions describe the conditions in which the AI should operate (how a task should be done).

### Reusable Prompt Files
Define reusable prompts for common tasks. Prompt files are standalone prompts that you can run directly in chat by typing `/prompt-name`.

### Custom Agents
Define how chat operates, which tools it can use, and how it interacts with the codebase. Each chat prompt runs within the boundaries of the agent.

### MCP Servers
Extend chat with custom capabilities by integrating external tools and services through the Model Context Protocol.

**Tips:**
- Define language-specific instructions to get more accurate generated code
- Store your instructions in your workspace to easily share them with your team
- Define reusable prompt files for common tasks to save time

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Copilot not responding | Restart VS Code; verify Copilot extension is installed and enabled |
| Chat view not opening | Verify GitHub Copilot Chat extension is installed and enabled |
| Authentication fails | Verify Copilot subscription at https://github.com/settings/copilot |
| "Not authenticated" error | Sign in to GitHub through VS Code (File → Preferences → Settings → GitHub) |
| Directory not trusted | Approve when prompted, or mark folder as trusted in workspace settings |
| Slow responses | Use `/compact` to reduce context size, or switch to a faster language model |
| Wrong file being modified | Review carefully before accepting; use full path with `#file:` |
| Inline suggestions not appearing | Check that GitHub Copilot extension is enabled and you're signed in |
| PowerShell version issues | Update to PowerShell 7+: `winget install Microsoft.PowerShell` |


### Getting Help

- **Official Documentation:** https://docs.github.com/en/copilot
- **VS Code Copilot Guide:** https://code.visualstudio.com/docs/copilot
- **Check Extension Status:** Open Extensions view (Ctrl+Shift+X) and search "GitHub Copilot"
- **View Output Logs:** Open Output panel (Ctrl+Shift+U) and select "GitHub Copilot" from dropdown

---

## Additional Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Copilot Guide](https://code.visualstudio.com/docs/copilot/overview)
- [Copilot Free Plan](https://github.com/features/copilot)
- [Effective Prompt Engineering](https://code.visualstudio.com/docs/copilot/prompt-crafting)

---

## Next Steps

After completing this session:

1. **Practice with your own projects** - Try using different modes on your actual codebase
2. **Experiment with custom instructions** - Define your coding standards and preferences
3. **Create reusable prompts** - Build a library of common tasks for your team
4. **Explore advanced features** - Try agents, custom tools, and MCP servers
5. **Share knowledge** - Help your team adopt best practices

---

*GitHub Copilot Basic Feature Overview Guide*  
*Last Updated: January 2026*
