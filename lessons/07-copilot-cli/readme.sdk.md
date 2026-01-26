## GitHub Copilot SDK

While **Copilot CLI** is an interactive terminal tool for developers, the **[GitHub Copilot SDK](https://github.com/github/copilot-sdk?utm_source=blog-cli-sdk-repo-cta&utm_medium=blog&utm_campaign=cli-sdk-jan-2026)** is a programmatic library that lets you embed Copilot's agentic capabilities directly into your own applications and services.

### CLI vs SDK: When to Use Each

| Copilot CLI | Copilot SDK |
|-------------|-------------|
| Interactive terminal sessions | Programmatic integration in your apps |
| Developer productivity tool | Build AI-powered tools and automation |
| Run `copilot` command directly | Import as a library in your code |
| Human-in-the-loop workflows | Automated pipelines and services |

### SDK Installation

| Language | Command |
|----------|----------|
| **Node.js / TypeScript** | `npm install @github/copilot-sdk` |
| **Python** | `pip install github-copilot-sdk` |
| **Go** | `go get github.com/github/copilot-sdk/go` |
| **.NET** | `dotnet add package GitHub.Copilot.SDK` |

> **Prerequisite:** The Copilot CLI must be installed. The SDK communicates with the CLI running in server mode via JSON-RPC.

### Quick Demo: Python

```python
from github_copilot_sdk import CopilotClient

# SDK automatically starts CLI in server mode
client = CopilotClient()

# Analyze firmware code programmatically
response = client.chat(
    "Review @Firmware/MotorControl/motor.cpp for potential issues"
)
print(response)
```

### Use Case: Automated Firmware Documentation

Build a script that generates documentation for your embedded codebase:

```python
from github_copilot_sdk import CopilotClient
import os

client = CopilotClient()

# Generate docs for each driver file
for file in os.listdir("Firmware/Drivers"):
    if file.endswith(".c"):
        doc = client.chat(f"Generate API documentation for @Firmware/Drivers/{file}")
        with open(f"docs/{file}.md", "w") as f:
            f.write(doc)
```

This enables CI/CD integration, batch processing, and custom tooling that would be impractical with interactive CLI sessions.

### SDK Resources

- [GitHub Copilot SDK Repository](https://github.com/github/copilot-sdk?utm_source=blog-cli-sdk-repo-cta&utm_medium=blog&utm_campaign=cli-sdk-jan-2026)
- [Getting Started Guide](https://github.com/github/copilot-sdk/blob/main/docs/getting-started.md)
- [Cookbook & Recipes](https://github.com/github/copilot-sdk/blob/main/cookbook/README.md)

> **Note:** The SDK is currently in Technical Preview.

---
