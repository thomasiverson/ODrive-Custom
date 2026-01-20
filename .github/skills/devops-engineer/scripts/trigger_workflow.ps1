#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Manually trigger GitHub Actions workflows for ODrive repository.

.DESCRIPTION
    Triggers workflow runs manually using GitHub CLI. Useful for workflows
    that support workflow_dispatch or for re-running failed workflows.

.PARAMETER Workflow
    Workflow file name (e.g., firmware.yaml)

.PARAMETER Ref
    Git ref (branch, tag, or commit) to run workflow on (default: current branch)

.PARAMETER ReRun
    Re-run a specific workflow run ID

.PARAMETER ReRunFailed
    Re-run only failed jobs in a specific workflow run ID

.EXAMPLE
    .\trigger_workflow.ps1 -Workflow firmware.yaml
    Trigger firmware workflow on current branch

.EXAMPLE
    .\trigger_workflow.ps1 -Workflow firmware.yaml -Ref devel
    Trigger firmware workflow on devel branch

.EXAMPLE
    .\trigger_workflow.ps1 -ReRun 12345678
    Re-run entire workflow

.EXAMPLE
    .\trigger_workflow.ps1 -ReRunFailed 12345678
    Re-run only failed jobs
#>

param(
    [string]$Workflow = "",
    [string]$Ref = "",
    [string]$ReRun = "",
    [string]$ReRunFailed = ""
)

# Color output helpers
function Write-Success { param([string]$Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host "⚠ $Message" -ForegroundColor Yellow }
function Write-Failure { param([string]$Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Info { param([string]$Message) Write-Host "ℹ $Message" -ForegroundColor Cyan }

# Check if gh CLI is installed
$GhVersion = gh --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Failure "GitHub CLI (gh) is not installed"
    Write-Info "Install with: winget install GitHub.cli"
    exit 1
}

# Get repository root
$RepoRoot = git rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Failure "Not in a git repository"
    exit 1
}

Set-Location $RepoRoot

# Re-run existing workflow
if ($ReRun) {
    Write-Info "Re-running workflow: $ReRun"
    gh run rerun $ReRun
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Workflow re-run triggered successfully"
        Write-Info "Monitor status with: .\check_workflow_status.ps1 -RunId $ReRun -Watch"
    } else {
        Write-Failure "Failed to re-run workflow"
    }
    exit $LASTEXITCODE
}

# Re-run failed jobs only
if ($ReRunFailed) {
    Write-Info "Re-running failed jobs for workflow: $ReRunFailed"
    gh run rerun $ReRunFailed --failed
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Failed jobs re-run triggered successfully"
        Write-Info "Monitor status with: .\check_workflow_status.ps1 -RunId $ReRunFailed -Watch"
    } else {
        Write-Failure "Failed to re-run failed jobs"
    }
    exit $LASTEXITCODE
}

# Manual workflow trigger
if ([string]::IsNullOrEmpty($Workflow)) {
    Write-Failure "Workflow name is required"
    Write-Info "Usage: .\trigger_workflow.ps1 -Workflow <workflow-file>"
    Write-Info ""
    Write-Info "Available workflows:"
    Get-ChildItem ".github\workflows\*.yaml", ".github\workflows\*.yml" | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Yellow
    }
    exit 1
}

# Get current branch if ref not specified
if ([string]::IsNullOrEmpty($Ref)) {
    $Ref = git rev-parse --abbrev-ref HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-Failure "Failed to get current branch"
        exit 1
    }
    Write-Info "Using current branch: $Ref"
}

# Verify workflow file exists
$WorkflowPath = ".github\workflows\$Workflow"
if (-not (Test-Path $WorkflowPath)) {
    Write-Failure "Workflow file not found: $WorkflowPath"
    Write-Info "Available workflows:"
    Get-ChildItem ".github\workflows\*.yaml", ".github\workflows\*.yml" | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Yellow
    }
    exit 1
}

# Check if workflow supports manual trigger
$WorkflowContent = Get-Content $WorkflowPath -Raw
if ($WorkflowContent -notmatch "workflow_dispatch") {
    Write-Warning "This workflow may not support manual triggering (workflow_dispatch)"
    Write-Warning "It may only run on push/pull_request events"
    $Response = Read-Host "Continue anyway? (y/N)"
    if ($Response -ne "y" -and $Response -ne "Y") {
        Write-Info "Cancelled by user"
        exit 0
    }
}

Write-Info "Triggering workflow: $Workflow"
Write-Info "Target ref: $Ref"
Write-Host ""

# Confirm trigger
Write-Warning "This will trigger a new workflow run"
$Response = Read-Host "Proceed? (y/N)"
if ($Response -ne "y" -and $Response -ne "Y") {
    Write-Info "Cancelled by user"
    exit 0
}

# Trigger the workflow
gh workflow run $Workflow --ref $Ref

if ($LASTEXITCODE -eq 0) {
    Write-Success "Workflow triggered successfully"
    Write-Host ""
    Write-Info "Waiting for run to appear..."
    Start-Sleep -Seconds 3
    
    # Try to get the latest run ID
    $LatestRun = gh run list --workflow=$Workflow --limit 1 --json databaseId,status,headBranch | ConvertFrom-Json
    if ($LatestRun) {
        $RunId = $LatestRun.databaseId
        Write-Success "Workflow run ID: $RunId"
        Write-Info "Monitor with: .\check_workflow_status.ps1 -RunId $RunId -Watch"
        Write-Info "Or view in browser: gh run view $RunId --web"
    }
} else {
    Write-Failure "Failed to trigger workflow"
    Write-Info "Possible reasons:"
    Write-Info "  - Workflow doesn't support workflow_dispatch"
    Write-Info "  - Invalid ref/branch name"
    Write-Info "  - Insufficient permissions"
    exit 1
}
