# Foundry Local Demo

**Session Duration:** 15 minutes  
**Audience:** Developers exploring offline/local AI  
**Environment:** Windows + VS Code (demo); optional WSL/macOS setup  
**Focus:** Show Foundry Local CLI capabilities and local AI inference

---

## Objectives

- See Foundry Local running locally without internet connectivity
- Learn the core CLI commands for model management and execution
- Understand how to integrate via OpenAI-compatible API from any environment

---

## Key Concepts

- **On-device inference**: Run AI models locally for privacy, reduced latency, and no cloud costs
- **OpenAI-compatible API**: Use familiar SDKs (Python, JavaScript, C#) to integrate
- **Hardware-aware execution**: Automatically selects best model variant (CPU/GPU/NPU) for your hardware
- **Execution providers**: Optimized runtime libraries (CUDA, OpenVINO, QNN, VitisAI) downloaded automatically
- **No Azure subscription required**: Fully local, no sign-up needed

---

## Agenda (15 min)

| Sub-Topic | Focus | Time |
|-----------|-------|------|
| What is Foundry Local? | Local runtime, privacy, hardware acceleration | 3 min |
| Live Demo | CLI installation, model operations, interactive chat | 10 min |
| Self-Setup Guide | Install steps, WSL/macOS, SDK integration | 2 min |

---

## Demo Script (10 min)

### Part 1: Verify Installation (1 min)
```powershell
foundry --help
foundry service status
```
- Show CLI is installed and service is running
- Note the local endpoint displayed (e.g., http://localhost:11434)

### Part 2: Explore Models (2 min)
```powershell
foundry model list
```
- Point out available models and hardware-specific variants
- Explain first run downloads execution providers (progress bar shown)

**Filter examples:**
```powershell
foundry model list --filter device=GPU
foundry model list --filter task=chat-completion
foundry model list --filter alias=phi*
```

### Part 3: Run a Model (3 min)
```powershell
foundry model run phi-3.5-mini
```
- **First run**: Downloads model and starts interactive chat
- **Subsequent runs**: Instant launch from cache
- Show the interactive prompt that appears

### Part 4: Interactive Prompts (3 min)
Try these in the interactive session:
- "Summarize this project README in 5 bullet points"
- "Write a PowerShell script to list the top 5 largest files"
- "Explain what causes ERROR_OVERSPEED in motor control firmware"

### Part 5: Advanced Commands (1 min)
```powershell
foundry model info phi-3.5-mini
foundry cache list
foundry service ps
```
- Show model details, cached models, and currently loaded models

---

## Installation Guide (Self-Guided)

### Windows Installation

**Option 1: Using winget (recommended)**
```powershell
winget install Microsoft.FoundryLocal
```

**Option 2: Manual installation**
1. Download the latest `.msix` package from [GitHub releases](https://github.com/microsoft/Foundry-Local/releases)
2. Download the dependency: [Microsoft.VCLibs.x64.14.00.Desktop.appx](https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx)
3. Install both packages:
```powershell
Add-AppxPackage .\FoundryLocal.msix -DependencyPath .\VcLibs.appx
```

**Verify installation:**
```powershell
foundry --help
foundry service status
```

### macOS Installation

**Using Homebrew:**
```bash
brew install microsoft/foundrylocal/foundrylocal
```

**Manual installation:**
1. Download the latest release from [GitHub releases](https://github.com/microsoft/Foundry-Local/releases)
2. Extract the downloaded file
3. Run the installer:
```bash
./install-foundry.command
```

**Verify installation:**
```bash
foundry --help
foundry service status
```

---

## Core CLI Commands Reference

### Model Commands

| Command | Description |
|---------|-------------|
| `foundry model list` | List all available models (downloads execution providers on first run) |
| `foundry model list --filter <key>=<value>` | Filter models by device, task, alias, or provider |
| `foundry model run <model>` | Download (if needed) and run a model interactively |
| `foundry model info <model>` | Display detailed model information |
| `foundry model info <model> --license` | Show model license information |
| `foundry model download <model>` | Download a model without running it |
| `foundry model load <model>` | Load a model into the service |
| `foundry model unload <model>` | Unload a model from the service |

**Filter examples:**
```powershell
foundry model list --filter device=GPU
foundry model list --filter device=!GPU
foundry model list --filter task=chat-completion
foundry model list --filter provider=CUDAExecutionProvider
foundry model list --filter alias=phi*
```

> **Note**: Use model **alias** (e.g., `phi-3.5-mini`) to auto-select the best variant for your hardware, or use the full **model ID** (e.g., `qwen2.5-0.5b-instruct-generic-cpu`) to run a specific variant.

### Service Commands

| Command | Description |
|---------|-------------|
| `foundry service status` | Display service status and endpoint URL |
| `foundry service start` | Start the Foundry Local service |
| `foundry service stop` | Stop the Foundry Local service |
| `foundry service restart` | Restart the Foundry Local service |
| `foundry service ps` | List currently loaded models |
| `foundry service diag` | Display service logs |
| `foundry service set <options>` | Configure service settings |

### Cache Commands

| Command | Description |
|---------|-------------|
| `foundry cache location` | Show current cache directory path |
| `foundry cache list` | List all cached models |
| `foundry cache cd <path>` | Change cache directory location |
| `foundry cache remove <model>` | Remove a model from cache |

---

## Execution Providers

Foundry Local automatically downloads and configures hardware-specific execution providers for optimal performance:

### Built-in Providers
- **CPU**: Microsoft Linear Algebra Subroutines (MLAS) - universal fallback
- **WebGPU**: Dawn implementation - works on any GPU
- **CUDA**: NVIDIA GPU acceleration (RTX 30 series+, driver 32.0.15.5585+, CUDA 12.5+)

### Plugin Providers (Auto-Downloaded)
- **NvTensorRTRTXExecutionProvider**: NVIDIA TensorRT (RTX 30XX+)
- **OpenVINOExecutionProvider**: Intel CPU/GPU/NPU (TigerLake 11th Gen+, AlderLake 12th Gen+, ArrowLake 15th Gen+)
- **QNNExecutionProvider**: Qualcomm NPU (Snapdragon X Elite/Plus)
- **VitisAIExecutionProvider**: AMD NPU (Adrenalin 25.6.3+)

> **For Intel NPU**: Install the [Intel NPU driver](https://www.intel.com/content/www/us/en/download/794734/intel-npu-driver-windows.html) for optimal acceleration.

---

## SDK Integration Examples

### Python SDK

**Install:**
```bash
pip install foundry-local-sdk openai
```

**Usage:**
```python
from foundry_local import FoundryLocalManager
import openai

manager = FoundryLocalManager("phi-3.5-mini")

client = openai.OpenAI(
    base_url=manager.endpoint,
    api_key=manager.api_key
)

response = client.chat.completions.create(
    model=manager.get_model_info("phi-3.5-mini").id,
    messages=[{"role": "user", "content": "Explain dependency injection"}],
    stream=True
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
```

### JavaScript SDK

**Install:**
```bash
npm install foundry-local-sdk openai
```

**Usage:**
```javascript
import { OpenAI } from "openai";
import { FoundryLocalManager } from "foundry-local-sdk";

const manager = new FoundryLocalManager();
const modelInfo = await manager.init("phi-3.5-mini");

const client = new OpenAI({
  baseURL: manager.endpoint,
  apiKey: manager.apiKey,
});

const stream = await client.chat.completions.create({
  model: modelInfo.id,
  messages: [{ role: "user", content: "Explain SOLID principles" }],
  stream: true,
});

for await (const chunk of stream) {
  if (chunk.choices[0]?.delta?.content) {
    process.stdout.write(chunk.choices[0].delta.content);
  }
}
```

### C# SDK

**Install:**
```bash
dotnet add package Microsoft.AI.Foundry.Local.WinML
```

**Usage:**
```csharp
using Microsoft.AI.Foundry.Local;
using Betalgo.Ranul.OpenAI.ObjectModels.RequestModels;

var config = new Configuration { AppName = "my-app" };
await FoundryLocalManager.CreateAsync(config);
var mgr = FoundryLocalManager.Instance;

var catalog = await mgr.GetCatalogAsync();
var model = await catalog.GetModelAsync("phi-3.5-mini");
await model.DownloadAsync();
await model.LoadAsync();

var chatClient = await model.GetChatClientAsync();
List<ChatMessage> messages = new()
{
    new ChatMessage { Role = "user", Content = "What is YAGNI?" }
};

var response = chatClient.CompleteChatStreamingAsync(messages);
await foreach (var chunk in response)
{
    Console.Write(chunk.Choices[0].Message.Content);
}

await model.UnloadAsync();
```

---

## WSL Integration (Calling Windows-Hosted Foundry Local)

If your development environment runs in WSL but Foundry Local is installed on Windows:

**Step 1: Start Foundry Local in Windows**
```powershell
foundry model run phi-3.5-mini
foundry service status
```
Note the endpoint URL (typically `http://localhost:11434`)

**Step 2: Install OpenAI client in WSL**
```bash
python -m venv .venv
source .venv/bin/activate
pip install openai
```

**Step 3: Call from WSL (WSL shares localhost with Windows)**
```bash
export FOUNDRY_BASE_URL=http://localhost:11434/v1
python - <<'PY'
import os, openai

client = openai.OpenAI(base_url=os.environ["FOUNDRY_BASE_URL"], api_key="")
response = client.chat.completions.create(
    model="phi-3.5-mini",
    messages=[{"role": "user", "content": "Explain the CAP theorem"}],
)
print(response.choices[0].message.content)
PY
```

> **Firewall Note**: If Windows Firewall blocks the connection, allow loopback traffic to the Foundry Local port.

---

## What to Emphasize in the Demo

- **No cloud**: Everything runs local; perfect for privacy-sensitive work
- **Hardware-aware**: Best model variant automatically selected for your hardware
- **OpenAI-compatible**: Reuse existing clients and SDKs
- **Fast start**: Three commands to install, list, and run a model
- **Works everywhere**: VS Code, terminals, WSL, any language with OpenAI SDK

---

## References

- **Official Documentation**: [Microsoft Learn - Foundry Local](https://learn.microsoft.com/azure/ai-foundry/foundry-local/?view=foundry-classic)
- **CLI Reference**: [Foundry Local CLI](https://learn.microsoft.com/azure/ai-foundry/foundry-local/reference/reference-cli?view=foundry-classic)
- **GitHub Repository**: [microsoft/Foundry-Local](https://github.com/microsoft/Foundry-Local)
- **Installer**: [Download Foundry Local](https://aka.ms/foundry-local-installer)
- **Troubleshooting Guide**: [Best Practices](https://learn.microsoft.com/azure/ai-foundry/foundry-local/reference/reference-best-practice?view=foundry-classic)

---

## Demo Tips

- Keep the demo offline to prove local capability
- Show hardware acceleration in action (check execution provider in model info)
- Use practical prompts that demonstrate quality and latency
- Encourage attendees to try WSL flow if their toolchain lives there
- Point out the comprehensive CLI help system (`foundry --help`)
