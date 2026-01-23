# Lesson 9: Foundry Local Demo

**Session Duration:** 35 minutes  
**Audience:** Embedded/C++ Developers (Intermediate to Advanced)  
**Environment:** Windows, VS Code, WSL (optional)  
**Extensions:** GitHub Copilot  
**Source Control:** GitHub/Bitbucket

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
| **Execution Provider** | Hardware backend for inference (CPU, GPU) |
| **Model Cache** | Local storage for downloaded models |
| **Foundry CLI** | Command-line tools for model management |
| **Foundry SDK** | Programmatic access to local models |

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Why Foundry Local Matters](#why-foundry-local-matters)
- [Learning Path](#learning-path)
- [Installation](#1-installation-8-min)
- [CLI Commands](#2-cli-commands-7-min)
- [Execution Providers](#3-execution-providers-5-min)
- [SDK Integration](#4-sdk-integration-10-min)
- [WSL Integration](#5-wsl-integration-5-min)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Summary: Key Takeaways](#summary-key-takeaways)

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

**Step 1: Install Foundry CLI**

```powershell
# Using winget (recommended)
winget install Microsoft.FoundryLocal

# Verify installation
foundry --version
```

**Step 2: Initialize Foundry**

```powershell
# Initialize with default settings
foundry init

# This creates:
# - Config file at %USERPROFILE%\.foundry\config.json
# - Model cache at %USERPROFILE%\.foundry\models\
```

**Step 3: Verify Installation**

```powershell
# Check foundry status
foundry status

# List available commands
foundry --help
```

### Configure Model Cache Location (Optional)

If you need to use a different drive for model storage:

```powershell
# Set custom cache location
foundry config set cache.path "D:\foundry-models"

# Verify setting
foundry config get cache.path
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
foundry model pull phi-3-mini

# Check download progress
foundry model status

# List downloaded models
foundry model list --local
```

### Running Inference

**Interactive Chat:**
```powershell
# Start interactive chat with model
foundry chat phi-3-mini
```

**Single Query:**
```powershell
# Run single inference
foundry run phi-3-mini --prompt "Explain what volatile does in C++"
```

**From File:**
```powershell
# Process file content
foundry run phi-3-mini --file code.cpp --prompt "Review this code for embedded best practices"
```

### Model Management

```powershell
# Remove downloaded model
foundry model remove phi-3-mini

# Clear entire cache
foundry cache clear

# Check disk usage
foundry cache info
```

---

## 3. Execution Providers (5 min)

### Available Providers

| Provider | Hardware | Performance | Memory |
|----------|----------|-------------|--------|
| **CPU** | Any x64/ARM64 | Baseline | System RAM |
| **DirectML** | DirectX 12 GPU | 2-5x faster | GPU VRAM |
| **CUDA** | NVIDIA GPU | 3-10x faster | GPU VRAM |

### Checking Available Providers

```powershell
# List available execution providers
foundry providers list

# Show provider capabilities
foundry providers info directml
```

### Selecting a Provider

```powershell
# Use specific provider for inference
foundry run phi-3-mini --provider directml --prompt "Hello"

# Set default provider
foundry config set inference.provider "directml"

# Verify provider is being used
foundry run phi-3-mini --verbose --prompt "Test"
```

### Provider Recommendations

| Scenario | Recommended Provider |
|----------|---------------------|
| No dedicated GPU | CPU |
| AMD GPU / Intel GPU | DirectML |
| NVIDIA GPU | CUDA |
| Low VRAM (< 4GB) | CPU |
| Maximum performance | CUDA or DirectML |

---

## 4. SDK Integration (10 min)

### Python SDK

**Installation:**
```powershell
pip install foundry-local
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

### REST API (Local Server)

**Start Local Server:**
```powershell
# Start Foundry server on localhost:8080
foundry serve --port 8080

# Server runs until Ctrl+C
```

**Send Request (PowerShell):**
```powershell
$body = @{
    model = "phi-3-mini"
    prompt = "What is RAII?"
    max_tokens = 200
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/v1/completions" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Send Request (curl):**
```bash
curl -X POST http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "phi-3-mini", "prompt": "What is RAII?", "max_tokens": 200}'
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

**Option 2: Use Network Mount:**
```bash
# Access Windows Foundry server from WSL
curl http://$(hostname).local:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "phi-3-mini", "prompt": "Hello"}'
```

### GPU Passthrough in WSL

For CUDA support in WSL2:
1. Install latest NVIDIA Windows driver
2. CUDA support is automatic in WSL2
3. Verify: `nvidia-smi` in WSL

```bash
# Check CUDA availability in WSL
foundry providers list
# Should show: cuda (if NVIDIA driver supports WSL2)
```

---

## Practice Exercises

### Exercise 1: Install and Run First Model
**Goal:** Complete Foundry setup and run inference

<details>
<summary>📋 Instructions</summary>

1. Install Foundry CLI using winget
2. Initialize Foundry configuration
3. Download a small model (phi-3-mini)
4. Run a simple inference query

**Commands:**
```powershell
winget install Microsoft.FoundryLocal
foundry init
foundry model pull phi-3-mini
foundry run phi-3-mini --prompt "What is a state machine?"
```

**Success Criteria:**
- ✅ Foundry CLI responds to `--version`
- ✅ Model downloads successfully
- ✅ Inference returns a response
</details>

---

### Exercise 2: Compare Execution Providers
**Goal:** Understand performance differences

<details>
<summary>📋 Instructions</summary>

1. List available providers on your system
2. Run the same prompt with CPU provider
3. Run the same prompt with GPU provider (if available)
4. Compare response times

**Commands:**
```powershell
# List providers
foundry providers list

# Time CPU inference
Measure-Command { foundry run phi-3-mini --provider cpu --prompt "Hello" }

# Time GPU inference (if available)
Measure-Command { foundry run phi-3-mini --provider directml --prompt "Hello" }
```

**Success Criteria:**
- ✅ Identified available providers
- ✅ Both inferences complete successfully
- ✅ Noted time difference
</details>

---

### Exercise 3: Local Code Review
**Goal:** Use Foundry for local code analysis

<details>
<summary>📋 Instructions</summary>

1. Select a small C++ file from ODrive
2. Use Foundry to review it for embedded best practices
3. Evaluate the quality of suggestions

**Commands:**
```powershell
# Review a file
foundry run phi-3-mini --file src-ODrive/Firmware/MotorControl/encoder.hpp `
    --prompt "Review this embedded C++ code for best practices. Check for: 1) Const correctness 2) RAII patterns 3) Error handling"
```

**Success Criteria:**
- ✅ Foundry processes the file
- ✅ Returns relevant suggestions
- ✅ Suggestions are actionable
</details>

---

### Exercise 4: REST API Integration
**Goal:** Access Foundry programmatically

<details>
<summary>📋 Instructions</summary>

1. Start Foundry local server
2. Send a request using PowerShell/curl
3. Parse the response

**Terminal 1 - Start Server:**
```powershell
foundry serve --port 8080
```

**Terminal 2 - Send Request:**
```powershell
$response = Invoke-RestMethod -Uri "http://localhost:8080/v1/completions" `
    -Method Post `
    -ContentType "application/json" `
    -Body '{"model": "phi-3-mini", "prompt": "What is volatile in C++?", "max_tokens": 100}'

$response.choices[0].text
```

**Success Criteria:**
- ✅ Server starts successfully
- ✅ Request returns valid JSON
- ✅ Response contains expected text
</details>

---

## Quick Reference

### Essential CLI Commands

| Command | Purpose |
|---------|---------|
| `foundry init` | Initialize configuration |
| `foundry model list` | Show available models |
| `foundry model pull <name>` | Download model |
| `foundry model list --local` | Show downloaded models |
| `foundry run <model> --prompt "..."` | Single inference |
| `foundry chat <model>` | Interactive chat |
| `foundry serve --port 8080` | Start REST API server |
| `foundry providers list` | Show available providers |

### Configuration Commands

| Command | Purpose |
|---------|---------|
| `foundry config get <key>` | Get config value |
| `foundry config set <key> <value>` | Set config value |
| `foundry cache info` | Show cache usage |
| `foundry cache clear` | Clear model cache |

### Execution Provider Flags

| Flag | Provider |
|------|----------|
| `--provider cpu` | CPU inference |
| `--provider directml` | DirectX 12 GPU |
| `--provider cuda` | NVIDIA CUDA |

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `foundry: command not found` | Not in PATH | Run `winget install Microsoft.FoundryLocal` again |
| Model download fails | Network/space issue | Check internet connection and disk space |
| CUDA provider unavailable | Missing driver | Update NVIDIA driver |
| DirectML slow | Wrong GPU selected | Check `foundry providers info directml` |
| Out of memory | Model too large | Use smaller model or CPU provider |
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
# Remove config and start fresh
Remove-Item -Recurse -Force "$env:USERPROFILE\.foundry"
foundry init
```

---

## Additional Resources

### Microsoft Documentation
- [Foundry Local Documentation](https://learn.microsoft.com/foundry/local/)
- [ONNX Runtime Execution Providers](https://onnxruntime.ai/docs/execution-providers/)
- [WSL GPU Support](https://learn.microsoft.com/windows/wsl/tutorials/gpu-compute)

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

**Short Answer:** Yes, Foundry supports ONNX format models.

**Detailed Explanation:**
```powershell
# Import custom ONNX model
foundry model import --path ./my-model.onnx --name my-custom-model

# Use imported model
foundry run my-custom-model --prompt "Test"
```

Requirements:
- Model must be in ONNX format
- Tokenizer config must be provided
- Model architecture must be supported

---

### Q: How do I reduce model load time?

**Short Answer:** Use SSD storage and keep models warm in memory.

**Detailed Explanation:**
1. **SSD Storage:** Move cache to fast SSD
2. **Warm Start:** Use `foundry serve` to keep model in memory
3. **Smaller Models:** Use quantized versions (4-bit, 8-bit)
4. **GPU:** Models load faster with GPU provider

```powershell
# Start persistent server (keeps model warm)
foundry serve --model phi-3-mini --port 8080
```

---

## Summary: Key Takeaways

### 1. Installation
- Install via `winget install Microsoft.FoundryLocal`
- Initialize with `foundry init`
- Download models with `foundry model pull`

### 2. Execution Providers
- **CPU:** Universal, baseline performance
- **DirectML:** Any DirectX 12 GPU
- **CUDA:** NVIDIA GPUs, best performance

### 3. CLI Usage
- `foundry run` for single queries
- `foundry chat` for interactive sessions
- `foundry serve` for REST API access

### 4. Integration Options
- Python SDK for scripting
- C# SDK for .NET applications
- REST API for any language

### 5. When to Use Foundry Local
- Offline development environments
- Privacy-sensitive codebases
- Air-gapped systems
- Cost-controlled exploration

---

*Lesson 9: Foundry Local Demo*  
*Last Updated: January 2026*
