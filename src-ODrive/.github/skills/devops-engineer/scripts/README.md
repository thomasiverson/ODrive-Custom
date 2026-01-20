# ODrive DevOps Engineer Scripts

This directory contains PowerShell scripts to help manage CI/CD workflows and code deployment for the ODrive project.

## Available Scripts

### 1. `push_with_checks.ps1`
Push code changes with automated pre-flight checks.

**Features:**
- Validates uncommitted changes
- Prevents accidental pushes to master
- Checks if branch is up-to-date with remote
- Validates YAML files (workflows)
- Optional test execution before push
- Dry-run mode for safety

**Usage:**
```powershell
# Basic push with checks
.\push_with_checks.ps1

# Push with tests
.\push_with_checks.ps1 -RunTests

# Dry run (preview only)
.\push_with_checks.ps1 -DryRun

# Push to master (requires -Force)
.\push_with_checks.ps1 -Branch master -Force
```

### 2. `check_workflow_status.ps1`
Monitor GitHub Actions workflow execution status.

**Features:**
- View recent workflow runs
- Filter by workflow file or branch
- Show detailed logs for specific runs
- Live monitoring of running workflows
- Summary statistics

**Usage:**
```powershell
# Show all recent runs
.\check_workflow_status.ps1

# Filter by workflow
.\check_workflow_status.ps1 -Workflow firmware.yaml

# View specific run details
.\check_workflow_status.ps1 -RunId 12345678

# Show logs for a run
.\check_workflow_status.ps1 -RunId 12345678 -ShowLogs

# Watch a running workflow
.\check_workflow_status.ps1 -RunId 12345678 -Watch
```

### 3. `trigger_workflow.ps1`
Manually trigger or re-run GitHub Actions workflows.

**Features:**
- Manual workflow triggering (if supported)
- Re-run entire workflows
- Re-run only failed jobs
- Branch/ref selection
- Automatic run ID tracking

**Usage:**
```powershell
# Trigger workflow on current branch
.\trigger_workflow.ps1 -Workflow firmware.yaml

# Trigger on specific branch
.\trigger_workflow.ps1 -Workflow firmware.yaml -Ref devel

# Re-run entire workflow
.\trigger_workflow.ps1 -ReRun 12345678

# Re-run only failed jobs
.\trigger_workflow.ps1 -ReRunFailed 12345678
```

## Prerequisites

All scripts require:
- **Git** - Version control system
- **GitHub CLI (gh)** - For workflow management
- **PowerShell** - Script execution (Windows PowerShell 5.1+ or PowerShell Core 7+)

### Installation

**GitHub CLI:**
```powershell
# Windows (winget)
winget install GitHub.cli

# Or with Chocolatey
choco install gh

# Verify installation
gh --version
```

**Authentication:**
```powershell
# Login to GitHub
gh auth login

# Verify access
gh auth status
```

## Typical Workflow

### Daily Development

```powershell
# 1. Make changes to code
# 2. Test locally
.\push_with_checks.ps1 -RunTests -DryRun

# 3. Push with checks
.\push_with_checks.ps1

# 4. Monitor CI pipeline
.\check_workflow_status.ps1 -Workflow firmware.yaml -Limit 5

# 5. Watch specific run if needed
.\check_workflow_status.ps1 -RunId <id> -Watch
```

### Release Process

```powershell
# 1. Create and push release tag
git tag -a fw-v0.5.6 -m "Release 0.5.6"
git push origin fw-v0.5.6

# 2. Monitor release build
.\check_workflow_status.ps1 -Branch master

# 3. If build fails, re-run failed jobs
.\trigger_workflow.ps1 -ReRunFailed <run-id>
```

### Troubleshooting CI

```powershell
# 1. Check recent failures
.\check_workflow_status.ps1 -Workflow firmware.yaml -Limit 10

# 2. View logs for failed run
.\check_workflow_status.ps1 -RunId <id> -ShowLogs

# 3. Re-run after fixing issue
.\trigger_workflow.ps1 -ReRun <id>
```

## Safety Features

- **Protected Branches**: Scripts prevent accidental pushes to `master`
- **Pre-flight Checks**: Validate code before pushing
- **Confirmation Prompts**: Ask before destructive operations
- **Dry-run Mode**: Preview actions without executing
- **YAML Validation**: Catch workflow syntax errors early

## Environment Variables

Optional environment variables for customization:

```powershell
# Set default remote
$env:ODRIVE_DEFAULT_REMOTE = "origin"

# Set default test flags
$env:ODRIVE_RUN_TESTS_BY_DEFAULT = "true"
```

## Troubleshooting

### "gh command not found"
Install GitHub CLI: `winget install GitHub.cli`

### "Not authenticated"
Run: `gh auth login`

### "Workflow not found"
Ensure you're in the repository root and workflow file exists in `.github/workflows/`

### "Push rejected"
Your branch may be behind remote. Pull latest changes: `git pull origin <branch>`

## Contributing

To add new scripts:
1. Follow PowerShell best practices
2. Include help documentation (comment-based help)
3. Add error handling and user-friendly messages
4. Test on Windows PowerShell 5.1 and PowerShell Core 7+
5. Update this README with usage examples

## Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
