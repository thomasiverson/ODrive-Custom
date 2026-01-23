# Lesson 9: Foundry Local Demo

**Session Duration:** 15 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows + VS Code (demo); optional WSL/macOS setup  
**Focus:** Show Foundry Local CLI capabilities and local AI inference

---

## Overview

This lesson demonstrates Microsoft's Foundry Local—an on-device AI runtime that enables local language model execution. You'll learn how to install the CLI tools, run models locally, explore execution providers (CPU/GPU), and understand integration patterns for embedded development scenarios.

**What You'll Learn:**
- Install and configure Foundry Local CLI
- Download and run local language models
- Understand execution providers (CPU, DirectML, CUDA)
- Explore SDK integration patterns for local AI
- Connect Foundry Local with VS Code workflows

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **Foundry Local** | Microsoft's on-device AI runtime for local inference |
| **On-device inference** | Run AI models locally for privacy, reduced latency, and no cloud costs |
| **OpenAI-compatible API** | Use familiar SDKs (Python, JavaScript, C#) to integrate |
| **Hardware-aware execution** | Automatically selects best model variant (CPU/GPU/NPU) for your hardware |
| **Execution Provider** | Optimized runtime libraries (CUDA, OpenVINO, QNN, VitisAI) downloaded automatically |
| **Model Cache** | Local storage for downloaded models |
| **No Azure subscription required** | Fully local, no sign-up needed |

---

## Agenda (15 min)

| Sub-Topic | Focus | Time |
|-----------|-------|------|
| What is Foundry Local? | Local runtime, privacy, hardware acceleration | 3 min |
| Live Demo | CLI installation, model operations, interactive chat | 10 min |
| Self-Setup Guide | Install steps, WSL/macOS, SDK integration | 2 min |

---

## Table of Contents

- [Overview](#overview)
- [Agenda](#agenda)
- [Prerequisites](#prerequisites)
- [Why Foundry Local Matters](#why-foundry-local-matters)
- [Learning Path](#learning-path)
- [Installation](#1-installation-8-min)
- [CLI Commands](#2-cli-commands-7-min)
- [Execution Providers](#3-execution-providers-5-min)
- [SDK Integration](#4-sdk-integration-10-min)
- [WSL Integration](#5-wsl-integration-5-min)
- [Speaker Instructions](#speaker-instructions)
- [Participant Instructions](#participant-instructions)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)
- [Next Steps](#next-steps)

---

## Prerequisites

Before starting this session, ensure you have:

- ✅ **Windows 10/11** or WSL with Ubuntu
- ✅ **Visual Studio Code** with GitHub Copilot extensions
- ✅ **PowerShell 7+** or Bash terminal
- ✅ **Sufficient disk space** - At least 10GB free for model downloads
- ✅ **Internet connection** - For initial model downloads

### Optional for GPU Acceleration

- ✅ **NVIDIA GPU** with CUDA support (for CUDA provider)
- ✅ **DirectX 12 compatible GPU** (for DirectML provider)
- ✅ **Latest GPU drivers** installed

### Verify Your Environment

```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Check available disk space
Get-PSDrive C | Select-Object Used, Free
```

---

## Why Foundry Local Matters

Foundry Local enables AI-powered development workflows without cloud dependencies. This is particularly relevant for embedded development where:

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Offline Operation** | No internet required after model download |
| **Data Privacy** | Sensitive code never leaves your machine |
| **Low Latency** | No network round-trip for inference |
| **Cost Control** | No per-query API charges |
| **Air-Gapped Dev** | Works in secure/isolated environments |

### Use Cases for Embedded Developers

1. **Code Review Assistance**
   - Local code analysis without uploading proprietary code
   - Pattern recognition in firmware codebases

2. **Documentation Generation**
   - Generate comments and docs locally
   - Summarize complex embedded algorithms

3. **Test Case Generation**
   - Create unit tests for embedded functions
   - Generate edge case scenarios

4. **Learning & Exploration**
   - Ask questions about unfamiliar code
   - Explain complex embedded patterns

---

## Learning Path

| Topic | What You'll Learn | Estimated Time |
|-------|-------------------|----------------|
| Installation | Install Foundry CLI | 8 min |
| CLI Commands | Model management and inference | 7 min |
| Execution Providers | CPU vs GPU options | 5 min |
| SDK Integration | Programmatic access | 10 min |
| WSL Integration | Linux environment setup | 5 min |

---

## 1. Installation (8 min)

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

## 2. CLI Commands (7 min)

### Model Discovery

```powershell
# List available models
foundry model list

# Search for specific model types
foundry model list --filter "code"

# Show model details
foundry model info <model-name>
```

### Model Download

```powershell
# Download a model (example: small code model)
foundry model download phi-3.5-mini

# List cached models
foundry cache list
```

### Running Inference

**Interactive Chat:**
```powershell
# Download (if needed) and run a model interactively
foundry model run phi-3.5-mini
```

- **First run**: Downloads model and starts interactive chat
- **Subsequent runs**: Instant launch from cache
- Show the interactive prompt that appears

### Model Management

```powershell
# Remove a model from cache
foundry cache remove phi-3.5-mini

# List cached models
foundry cache list

# Show cache directory path
foundry cache location
```

### Complete CLI Command Reference

#### Model Commands

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

#### Service Commands

| Command | Description |
|---------|-------------|
| `foundry service status` | Display service status and endpoint URL |
| `foundry service start` | Start the Foundry Local service |
| `foundry service stop` | Stop the Foundry Local service |
| `foundry service restart` | Restart the Foundry Local service |
| `foundry service ps` | List currently loaded models |
| `foundry service diag` | Display service logs |
| `foundry service set <options>` | Configure service settings |

#### Cache Commands

| Command | Description |
|---------|-------------|
| `foundry cache location` | Show current cache directory path |
| `foundry cache list` | List all cached models |
| `foundry cache cd <path>` | Change cache directory location |
| `foundry cache remove <model>` | Remove a model from cache |

---

## 3. Execution Providers (5 min)

### Available Providers

| Provider | Hardware | Performance | Memory |
|----------|----------|-------------|--------|
| **CPU** | Any x64/ARM64 | Baseline | System RAM |
| **DirectML** | DirectX 12 GPU | 2-5x faster | GPU VRAM |
| **CUDA** | NVIDIA GPU | 3-10x faster | GPU VRAM |

### Provider Recommendations

| Scenario | Recommended Provider |
|----------|---------------------|
| No dedicated GPU | CPU |
| AMD GPU / Intel GPU | DirectML |
| NVIDIA GPU | CUDA |
| Low VRAM (< 4GB) | CPU |
| Maximum performance | CUDA or DirectML |

### Execution Provider Details

Foundry Local automatically downloads and configures hardware-specific execution providers for optimal performance:

#### Built-in Providers
- **CPU**: Microsoft Linear Algebra Subroutines (MLAS) - universal fallback
- **WebGPU**: Dawn implementation - works on any GPU
- **CUDA**: NVIDIA GPU acceleration (RTX 30 series+, driver 32.0.15.5585+, CUDA 12.5+)

#### Plugin Providers (Auto-Downloaded)
- **NvTensorRTRTXExecutionProvider**: NVIDIA TensorRT (RTX 30XX+)
- **OpenVINOExecutionProvider**: Intel CPU/GPU/NPU (TigerLake 11th Gen+, AlderLake 12th Gen+, ArrowLake 15th Gen+)
- **QNNExecutionProvider**: Qualcomm NPU (Snapdragon X Elite/Plus)
- **VitisAIExecutionProvider**: AMD NPU (Adrenalin 25.6.3+)

> **For Intel NPU**: Install the [Intel NPU driver](https://www.intel.com/content/www/us/en/download/794734/intel-npu-driver-windows.html) for optimal acceleration.

---

## 4. SDK Integration (10 min)

### Python SDK

**Installation:**
```powershell
pip install foundry-local-sdk openai
```

**Basic Usage:**
```python
from foundry_local import FoundryClient

# Initialize client
client = FoundryClient()

# Load model
model = client.load_model("phi-3-mini")

# Run inference
response = model.generate(
    prompt="Explain RAII in embedded C++",
    max_tokens=500
)

print(response.text)
```

**OpenAI-Compatible Usage:**
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

**With Execution Provider:**
```python
from foundry_local import FoundryClient, Provider

client = FoundryClient(provider=Provider.DIRECTML)

model = client.load_model("phi-3-mini")
response = model.generate(prompt="What is volatile?")
```

### C# SDK

**Installation (NuGet):**
```powershell
dotnet add package Microsoft.FoundryLocal
dotnet add package Microsoft.AI.Foundry.Local.WinML
```

**Basic Usage:**
```csharp
using Microsoft.FoundryLocal;

var client = new FoundryClient();
var model = await client.LoadModelAsync("phi-3-mini");

var response = await model.GenerateAsync(
    prompt: "Explain state machines in embedded systems",
    maxTokens: 500
);

Console.WriteLine(response.Text);
```

**OpenAI-Compatible Usage:**
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

### JavaScript SDK

**Installation:**
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

---

## 5. WSL Integration (5 min)

### Installing Foundry in WSL

**Step 1: Enter WSL:**
```powershell
wsl
```

**Step 2: Install Foundry (Linux):**
```bash
# Download and install
curl -fsSL https://aka.ms/foundry-install | bash

# Add to PATH
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify
foundry --version
```

### Sharing Models Between Windows and WSL

**Option 1: Mount Windows Model Cache:**
```bash
# In WSL, create symlink to Windows cache
ln -s /mnt/c/Users/$USER/.foundry/models ~/.foundry/models
```

**Option 2: Call Windows Foundry Service from WSL:**
```bash
# Access Windows Foundry service from WSL (WSL shares localhost with Windows)
curl http://localhost:11434/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "phi-3.5-mini", "prompt": "Hello"}'
```

### GPU Passthrough in WSL

For CUDA support in WSL2:
1. Install latest NVIDIA Windows driver
2. CUDA support is automatic in WSL2
3. Verify: `nvidia-smi` in WSL

### Calling Windows-Hosted Foundry Local from WSL

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

## Speaker Instructions

### Demo 1: Verify Installation (2 min)

**Show participants the installation status:**

1. **Check CLI is available:**
   ```powershell
   foundry --help
   foundry service status
   ```
   > Point out: Service running and endpoint URL displayed

2. **Show service status:**
   ```powershell
   foundry service status
   ```
   > Point out: Local endpoint (e.g., http://localhost:11434)

### Demo 2: Explore Available Models (3 min)

**Demonstrate model discovery:**

1. **List all available models:**
   ```powershell
   foundry model list
   ```
   > Point out: Hardware-specific variants available

2. **Filter by capability:**
   ```powershell
   foundry model list --filter device=GPU
   foundry model list --filter task=chat-completion
   foundry model list --filter alias=phi*
   ```
   > Explain: Filter syntax for finding specific models

3. **Show model details:**
   ```powershell
   foundry model info phi-3.5-mini
   ```
   > Show: Model size, requirements, capabilities

### Demo 3: Run Interactive Chat (4 min)

**Show live inference:**

1. **Start interactive mode:**
   ```powershell
   foundry model run phi-3.5-mini
   ```
   > Point out: First run downloads model (progress bar)

2. **Try example prompts:**
   - "Summarize this project README in 5 bullet points"
   - "Write a PowerShell script to list the top 5 largest files"
   - "Explain what causes ERROR_OVERSPEED in motor control firmware"

3. **Exit the chat:**
   > Type `exit` or press Ctrl+C

### Demo 4: Advanced Commands (2 min)

**Show management commands:**

1. **Check cached models:**
   ```powershell
   foundry cache list
   ```

2. **View running models:**
   ```powershell
   foundry service ps
   ```

3. **Show model license:**
   ```powershell
   foundry model info phi-3.5-mini --license
   ```

### Demo Tips

- Keep the demo offline to prove local capability
- Show hardware acceleration in action (check execution provider in model info)
- Use practical prompts that demonstrate quality and latency
- Encourage attendees to try WSL flow if their toolchain lives there
- Point out the comprehensive CLI help system (`foundry --help`)

### What to Emphasize

- **No cloud**: Everything runs local; perfect for privacy-sensitive work
- **Hardware-aware**: Best model variant automatically selected for your hardware
- **OpenAI-compatible**: Reuse existing clients and SDKs
- **Fast start**: Three commands to install, list, and run a model
- **Works everywhere**: VS Code, terminals, WSL, any language with OpenAI SDK

---

## Participant Instructions

### Task 1: Verify Installation (3 min)

**Goal:** Confirm Foundry Local is working

1. Open PowerShell or VS Code terminal

2. Check Foundry CLI:
   ```powershell
   foundry --help
   ```
   Expected: List of available commands

3. Check service status:
   ```powershell
   foundry service status
   ```
   Expected: Service running with endpoint URL

4. If not installed, install now:
   ```powershell
   winget install Microsoft.FoundryLocal
   ```

### Task 2: Explore Models (3 min)

**Goal:** Find available models for your hardware

1. List all models:
   ```powershell
   foundry model list
   ```

2. Filter for GPU models (if you have GPU):
   ```powershell
   foundry model list --filter device=GPU
   ```

3. Check a specific model's details:
   ```powershell
   foundry model info phi-3.5-mini
   ```

4. Note the execution provider it will use for your hardware

### Task 3: Run Your First Query (4 min)

**Goal:** Execute local inference

1. Start interactive chat:
   ```powershell
   foundry model run phi-3.5-mini
   ```
   > First run will download the model (may take a few minutes)

2. Try these prompts:
   - "What is RAII in C++?"
   - "Explain volatile keyword for embedded systems"
   - "List 5 best practices for ISR handlers"

3. Exit the chat (type `exit` or Ctrl+C)

### Task 4: Check Cache (2 min)

**Goal:** Understand model storage

1. See where models are stored:
   ```powershell
   foundry cache location
   ```

2. List cached models:
   ```powershell
   foundry cache list
   ```

3. Check disk usage (note the size of downloaded models)

---

## Practice Exercises

### Exercise 1: Install and Run First Model
**Goal:** Complete Foundry setup and run inference

<details>
<summary>📋 Instructions</summary>

1. Install Foundry CLI using winget
2. Verify installation
3. Download a small model (phi-3.5-mini)
4. Run an interactive inference session

**Commands:**
```powershell
winget install Microsoft.FoundryLocal
foundry --help
foundry model download phi-3.5-mini
foundry model run phi-3.5-mini
```

**Success Criteria:**
- ✅ Foundry CLI responds to `--help`
- ✅ Model downloads successfully
- ✅ Interactive chat starts
</details>

---

### Exercise 2: Explore Model Variants
**Goal:** Understand hardware-specific model variants

<details>
<summary>📋 Instructions</summary>

1. List all available models
2. Filter by device type (GPU vs CPU)
3. Compare model details

**Commands:**
```powershell
# List all models
foundry model list

# Filter for GPU models
foundry model list --filter device=GPU

# Filter for CPU models
foundry model list --filter device=!GPU

# Show model details
foundry model info phi-3.5-mini
```

**Success Criteria:**
- ✅ Listed available models
- ✅ Identified GPU vs CPU variants
- ✅ Understood model requirements
</details>

---

### Exercise 3: Interactive Code Exploration
**Goal:** Use Foundry for exploring code questions

<details>
<summary>📋 Instructions</summary>

1. Start an interactive session with a model
2. Ask questions about embedded C++ concepts
3. Explore the model's knowledge

**Commands:**
```powershell
# Start interactive session
foundry model run phi-3.5-mini
```

**Try these prompts in the interactive session:**
- "What is RAII in embedded C++?"
- "Explain volatile keyword for hardware registers"
- "List best practices for ISR handlers"

**Success Criteria:**
- ✅ Interactive session starts
- ✅ Model responds to prompts
- ✅ Responses are relevant
</details>

---

### Exercise 4: SDK Integration (Python)
**Goal:** Access Foundry programmatically

<details>
<summary>📋 Instructions</summary>

1. Install Python SDK
2. Write a simple script to query Foundry
3. Parse the response

**Setup:**
```powershell
pip install foundry-local-sdk openai
```

**Script:**
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
    messages=[{"role": "user", "content": "What is volatile in C++?"}]
)

print(response.choices[0].message.content)
```

**Success Criteria:**
- ✅ SDK installs successfully
- ✅ Script connects to Foundry
- ✅ Response contains expected text
</details>

---

## Quick Reference

### Essential CLI Commands

| Command | Purpose |
|---------|---------|
| `foundry --help` | List available commands |
| `foundry model list` | Show available models |
| `foundry model list --filter <key>=<value>` | Filter models by device, task, alias |
| `foundry model download <model>` | Download a model without running |
| `foundry model run <model>` | Download (if needed) and run interactively |
| `foundry model info <model>` | Display model information |
| `foundry service status` | Show service status and endpoint |
| `foundry service ps` | List currently loaded models |
| `foundry cache list` | List cached models |
| `foundry cache location` | Show cache directory path |

### Cache Commands

| Command | Purpose |
|---------|---------|
| `foundry cache location` | Show cache directory path |
| `foundry cache list` | List cached models |
| `foundry cache cd <path>` | Change cache directory |
| `foundry cache remove <model>` | Remove model from cache |

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `foundry: command not found` | Not in PATH | Run `winget install Microsoft.FoundryLocal` again |
| Model download fails | Network/space issue | Check internet connection and disk space |
| CUDA provider unavailable | Missing driver | Update NVIDIA driver |
| Out of memory | Model too large | Use smaller model |
| WSL can't find models | Path mismatch | Create symlink to Windows cache |

### Check System Requirements

```powershell
# Check available memory
Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum

# Check GPU info (NVIDIA)
nvidia-smi

# Check DirectX version
dxdiag
```

### Reset Foundry Configuration

```powershell
# Remove cache and start fresh
Remove-Item -Recurse -Force "$env:USERPROFILE\.foundry"
```

---

## Additional Resources

### Official Documentation
- [Microsoft Learn - Foundry Local](https://learn.microsoft.com/azure/ai-foundry/foundry-local/?view=foundry-classic)
- [Foundry Local CLI Reference](https://learn.microsoft.com/azure/ai-foundry/foundry-local/reference/reference-cli?view=foundry-classic)
- [Foundry Local Best Practices](https://learn.microsoft.com/azure/ai-foundry/foundry-local/reference/reference-best-practice?view=foundry-classic)
- [ONNX Runtime Execution Providers](https://onnxruntime.ai/docs/execution-providers/)
- [WSL GPU Support](https://learn.microsoft.com/windows/wsl/tutorials/gpu-compute)

### GitHub & Downloads
- [GitHub Repository](https://github.com/microsoft/Foundry-Local) — Source code and issues
- [Foundry Local Installer](https://aka.ms/foundry-local-installer) — Direct download
- [GitHub Releases](https://github.com/microsoft/Foundry-Local/releases) — All versions

### Model Information
- [Phi-3 Model Family](https://azure.microsoft.com/products/phi-3)
- [ONNX Model Zoo](https://github.com/onnx/models)

### Integration Examples
- [Foundry Python SDK Examples](https://github.com/microsoft/foundry-local-examples)
- [VS Code Extension Integration](https://learn.microsoft.com/foundry/local/vscode)

---

## Frequently Asked Questions

### Q: What's the minimum hardware for Foundry Local?

**Short Answer:** x64 CPU with 8GB RAM for small models; GPU recommended for larger models.

**Detailed Explanation:**
| Model Size | CPU RAM | GPU VRAM | Performance |
|------------|---------|----------|-------------|
| Small (< 3B) | 8GB | 4GB | Good on CPU |
| Medium (3-7B) | 16GB | 8GB | GPU recommended |
| Large (> 7B) | 32GB | 16GB+ | GPU required |

---

### Q: Can I use Foundry Local offline?

**Short Answer:** Yes, after downloading models.

**Detailed Explanation:**
- Initial model download requires internet
- Once downloaded, inference is fully offline
- Model files are cached in `.foundry/models/`
- Copy cache folder to air-gapped machines for offline use

---

### Q: How does Foundry Local compare to GitHub Copilot?

**Short Answer:** Foundry is local and general-purpose; Copilot is cloud-based and code-optimized.

**Detailed Explanation:**
| Feature | Foundry Local | GitHub Copilot |
|---------|---------------|----------------|
| Location | On-device | Cloud |
| Latency | Lower | Higher |
| Code Quality | Good | Excellent |
| Privacy | Complete | Microsoft cloud |
| Cost | Free | Subscription |
| Models | Choose your own | Optimized for code |

Use Copilot for primary development; Foundry for offline/privacy scenarios.

---

### Q: Can I use my own models with Foundry?

**Short Answer:** Foundry Local works with models from its curated catalog.

**Detailed Explanation:**
Foundry Local provides a curated catalog of models optimized for local execution. Use `foundry model list` to see available models.

For custom model requirements:
- Check if your model variant exists in the catalog
- Use model aliases to auto-select the best variant for your hardware
- Refer to official documentation for advanced customization options

---

### Q: How do I reduce model load time?

**Short Answer:** Use SSD storage and load models into the service.

**Detailed Explanation:**
1. **SSD Storage:** Move cache to fast SSD using `foundry cache cd <path>`
2. **Pre-load Models:** Use `foundry model load <model>` to keep models ready
3. **Smaller Models:** Use quantized versions (4-bit, 8-bit)
4. **GPU:** Models load faster with GPU execution provider

---

## Summary: Key Takeaways

### 1. Installation
- Install via `winget install Microsoft.FoundryLocal`
- Verify with `foundry --help` and `foundry service status`
- Download models with `foundry model download`

### 2. Execution Providers
- **CPU:** Universal, baseline performance
- **DirectML:** Any DirectX 12 GPU
- **CUDA:** NVIDIA GPUs, best performance

### 3. CLI Usage
- `foundry model run` for interactive sessions
- `foundry model list` to explore available models
- `foundry cache list` to see downloaded models

### 4. Integration Options
- Python SDK for scripting
- C# SDK for .NET applications
- JavaScript SDK for Node.js

### 5. When to Use Foundry Local
- Offline development environments
- Privacy-sensitive codebases
- Air-gapped systems
- Cost-controlled exploration

---

## Next Steps

After completing this lesson:

1. **Download additional models** - Try different model sizes to find the best balance for your hardware

2. **Set up SDK integration** - Integrate Foundry into your Python or C# development workflow

3. **Configure WSL** - If you develop in WSL, set up model sharing with Windows

4. **Explore execution providers** - Benchmark CPU vs GPU performance for your use cases

5. **Integrate with CI/CD** - Use Foundry for local code review in pre-commit hooks

6. **Combine with VS Code** - Use Foundry for offline scenarios when Copilot requires internet

7. **Share cached models** - Copy the `.foundry/models` folder to air-gapped machines

---

*Lesson 9: Foundry Local Demo*  
*Last Updated: January 2026*
