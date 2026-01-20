#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Check GitHub Actions workflow status for ODrive repository.

.DESCRIPTION
    Monitors the status of GitHub Actions workflows, showing recent runs,
    their status, and providing detailed logs when requested.

.PARAMETER Workflow
    Workflow file name (e.g., firmware.yaml, documentation.yml)
    If not specified, shows all workflows

.PARAMETER Limit
    Number of recent runs to show (default: 10)

.PARAMETER Watch
    Continuously watch a specific run ID

.PARAMETER RunId
    Specific run ID to view details

.PARAMETER ShowLogs
    Show logs for the specified run

.PARAMETER Branch
    Filter runs by branch

.EXAMPLE
    .\check_workflow_status.ps1
    Show all recent workflow runs

.EXAMPLE
    .\check_workflow_status.ps1 -Workflow firmware.yaml -Limit 5
    Show 5 most recent firmware workflow runs

.EXAMPLE
    .\check_workflow_status.ps1 -RunId 12345678 -ShowLogs
    Show detailed logs for specific run

.EXAMPLE
    .\check_workflow_status.ps1 -Watch 12345678
    Continuously watch a running workflow
#>

param(
    [string]$Workflow = "",
    [int]$Limit = 10,
    [switch]$Watch,
    [string]$RunId = "",
    [switch]$ShowLogs,
    [string]$Branch = ""
)

# Color output helpers
function Write-Success { param([string]$Message) Write-Host $Message -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Failure { param([string]$Message) Write-Host $Message -ForegroundColor Red }
function Write-Info { param([string]$Message) Write-Host $Message -ForegroundColor Cyan }

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

Write-Info "GitHub Actions Workflow Status Monitor"
Write-Host ""

# Watch specific run
if ($Watch -and $RunId) {
    Write-Info "Watching workflow run: $RunId"
    gh run watch $RunId
    exit $LASTEXITCODE
}

# Show specific run details
if ($RunId) {
    Write-Info "Fetching details for run: $RunId"
    Write-Host ""
    
    if ($ShowLogs) {
        gh run view $RunId --log
    } else {
        gh run view $RunId
        Write-Host ""
        Write-Info "Use -ShowLogs to see full logs"
        Write-Info "Use -Watch to monitor this run in real-time"
    }
    exit $LASTEXITCODE
}

# Build command arguments
$GhArgs = @("run", "list", "--limit", $Limit)

if ($Workflow) {
    $GhArgs += "--workflow=$Workflow"
    Write-Info "Filtering by workflow: $Workflow"
}

if ($Branch) {
    $GhArgs += "--branch=$Branch"
    Write-Info "Filtering by branch: $Branch"
}

Write-Host ""

# List workflow runs
$Runs = & gh @GhArgs --json databaseId,displayTitle,conclusion,status,workflowName,headBranch,createdAt,event 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Failure "Failed to fetch workflow runs"
    Write-Host $Runs
    exit 1
}

# Parse JSON output
$RunsData = $Runs | ConvertFrom-Json

if ($RunsData.Count -eq 0) {
    Write-Warning "No workflow runs found"
    exit 0
}

# Display runs in a formatted table
Write-Host "Recent Workflow Runs:" -ForegroundColor Cyan
Write-Host ("-" * 120)

foreach ($Run in $RunsData) {
    $StatusIcon = switch ($Run.status) {
        "completed" {
            switch ($Run.conclusion) {
                "success" { "✓" }
                "failure" { "✗" }
                "cancelled" { "⊗" }
                default { "?" }
            }
        }
        "in_progress" { "⟳" }
        "queued" { "⋯" }
        default { "?" }
    }
    
    $StatusColor = switch ($Run.conclusion) {
        "success" { "Green" }
        "failure" { "Red" }
        "cancelled" { "Yellow" }
        default {
            if ($Run.status -eq "in_progress") { "Cyan" }
            else { "Gray" }
        }
    }
    
    $RunTime = ([DateTime]$Run.createdAt).ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
    
    Write-Host "$StatusIcon " -ForegroundColor $StatusColor -NoNewline
    Write-Host "[ID: $($Run.databaseId)] " -ForegroundColor Gray -NoNewline
    Write-Host "$($Run.displayTitle)" -NoNewline
    Write-Host " ($($Run.workflowName))" -ForegroundColor DarkGray
    Write-Host "   Branch: " -ForegroundColor Gray -NoNewline
    Write-Host "$($Run.headBranch)" -NoNewline
    Write-Host " | Event: " -ForegroundColor Gray -NoNewline
    Write-Host "$($Run.event)" -NoNewline
    Write-Host " | Time: " -ForegroundColor Gray -NoNewline
    Write-Host "$RunTime"
    Write-Host ""
}

Write-Host ("-" * 120)
Write-Host ""

# Show summary statistics
$TotalRuns = $RunsData.Count
$SuccessCount = ($RunsData | Where-Object { $_.conclusion -eq "success" }).Count
$FailureCount = ($RunsData | Where-Object { $_.conclusion -eq "failure" }).Count
$InProgressCount = ($RunsData | Where-Object { $_.status -eq "in_progress" }).Count
$QueuedCount = ($RunsData | Where-Object { $_.status -eq "queued" }).Count

Write-Host "Summary (last $TotalRuns runs):" -ForegroundColor Cyan
Write-Success "  ✓ Success: $SuccessCount"
Write-Failure "  ✗ Failed: $FailureCount"
if ($InProgressCount -gt 0) { Write-Info "  ⟳ In Progress: $InProgressCount" }
if ($QueuedCount -gt 0) { Write-Info "  ⋯ Queued: $QueuedCount" }

Write-Host ""
Write-Info "Commands:"
Write-Host "  View run details:  .\check_workflow_status.ps1 -RunId <id>"
Write-Host "  Watch run live:    .\check_workflow_status.ps1 -RunId <id> -Watch"
Write-Host "  Show logs:         .\check_workflow_status.ps1 -RunId <id> -ShowLogs"
Write-Host "  Filter workflow:   .\check_workflow_status.ps1 -Workflow firmware.yaml"
Write-Host "  Filter branch:     .\check_workflow_status.ps1 -Branch master"
