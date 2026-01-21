#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Push code changes with pre-flight checks for ODrive repository.

.DESCRIPTION
    Performs validation checks before pushing code:
    - Checks for uncommitted changes
    - Runs basic syntax validation
    - Verifies branch is not master (unless forced)
    - Optionally runs tests before push
    - Creates backup tags

.PARAMETER Branch
    Target branch to push to. Defaults to current branch.

.PARAMETER Remote
    Remote name to push to. Default: origin

.PARAMETER RunTests
    Run test suite before pushing

.PARAMETER Force
    Allow push to master branch (use with caution)

.PARAMETER DryRun
    Show what would be pushed without actually pushing

.EXAMPLE
    .\push_with_checks.ps1
    Push current branch with default checks

.EXAMPLE
    .\push_with_checks.ps1 -RunTests -Branch feature/my-feature
    Push specific branch after running tests

.EXAMPLE
    .\push_with_checks.ps1 -DryRun
    Preview what would be pushed
#>

param(
    [string]$Branch = "",
    [string]$Remote = "origin",
    [switch]$RunTests,
    [switch]$Force,
    [switch]$DryRun
)

# Color output helpers
function Write-Success { param([string]$Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host "⚠ $Message" -ForegroundColor Yellow }
function Write-Failure { param([string]$Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Info { param([string]$Message) Write-Host "ℹ $Message" -ForegroundColor Cyan }

# Get repository root
$RepoRoot = git rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Failure "Not in a git repository"
    exit 1
}

Set-Location $RepoRoot

Write-Info "Starting pre-push checks for ODrive repository..."

# Check if we're in a git repo
if (-not (Test-Path ".git")) {
    Write-Failure "Not in the root of a git repository"
    exit 1
}

# Get current branch if not specified
if ([string]::IsNullOrEmpty($Branch)) {
    $Branch = git rev-parse --abbrev-ref HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-Failure "Failed to get current branch"
        exit 1
    }
}

Write-Info "Target branch: $Branch"
Write-Info "Remote: $Remote"

# Check if branch exists
git rev-parse --verify $Branch >$null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Failure "Branch '$Branch' does not exist"
    exit 1
}

# Prevent accidental push to master
if ($Branch -eq "master" -and -not $Force) {
    Write-Failure "Pushing directly to master is not allowed without -Force flag"
    Write-Warning "Consider creating a feature branch and opening a PR instead"
    exit 1
}

# Check for uncommitted changes
$Status = git status --porcelain
if ($Status) {
    Write-Warning "You have uncommitted changes:"
    Write-Host $Status
    $Response = Read-Host "Continue with uncommitted changes? (y/N)"
    if ($Response -ne "y" -and $Response -ne "Y") {
        Write-Info "Aborted by user"
        exit 0
    }
}

# Check if branch is behind remote
Write-Info "Checking if branch is up to date with remote..."
git fetch $Remote $Branch >$null 2>&1
if ($LASTEXITCODE -eq 0) {
    $LocalCommit = git rev-parse $Branch
    $RemoteCommit = git rev-parse "$Remote/$Branch" 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        if ($LocalCommit -eq $RemoteCommit) {
            Write-Info "Branch is up to date with remote"
        } else {
            $Behind = git rev-list --count "$Branch..$Remote/$Branch" 2>$null
            $Ahead = git rev-list --count "$Remote/$Branch..$Branch" 2>$null
            
            if ($Behind -gt 0) {
                Write-Warning "Your branch is $Behind commits behind $Remote/$Branch"
                Write-Warning "Consider pulling latest changes first: git pull $Remote $Branch"
            }
            if ($Ahead -gt 0) {
                Write-Success "Your branch is $Ahead commits ahead of $Remote/$Branch"
            }
        }
    }
}

# Validate YAML files if modified
$ModifiedYaml = git diff --name-only HEAD | Where-Object { $_ -match '\.(yaml|yml)$' }
if ($ModifiedYaml) {
    Write-Info "Validating YAML files..."
    foreach ($File in $ModifiedYaml) {
        if (Test-Path $File) {
            # Basic YAML validation using Python
            $ValidationResult = python -c "import yaml; yaml.safe_load(open('$File'))" 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Failure "YAML validation failed for $File"
                Write-Host $ValidationResult
                exit 1
            } else {
                Write-Success "YAML valid: $File"
            }
        }
    }
}

# Run tests if requested
if ($RunTests) {
    Write-Info "Running test suite..."
    Push-Location tools
    $TestResult = python run_tests.py 2>&1
    Pop-Location
    
    if ($LASTEXITCODE -ne 0) {
        Write-Failure "Tests failed!"
        Write-Host $TestResult
        exit 1
    }
    Write-Success "All tests passed"
}

# Show what will be pushed
Write-Info "Commits to be pushed:"
git log --oneline "$Remote/$Branch..$Branch" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Info "(New branch - no remote tracking yet)"
}

# Dry run mode
if ($DryRun) {
    Write-Info "Dry run mode - would execute:"
    Write-Host "  git push $Remote $Branch" -ForegroundColor Yellow
    Write-Success "Dry run complete"
    exit 0
}

# Confirm push
Write-Warning "Ready to push to $Remote/$Branch"
$Response = Read-Host "Proceed with push? (y/N)"
if ($Response -ne "y" -and $Response -ne "Y") {
    Write-Info "Push cancelled by user"
    exit 0
}

# Perform the push
Write-Info "Pushing to $Remote/$Branch..."
git push $Remote $Branch

if ($LASTEXITCODE -eq 0) {
    Write-Success "Successfully pushed to $Remote/$Branch"
    
    # Show CI workflow URL if GitHub
    $RemoteUrl = git remote get-url $Remote
    if ($RemoteUrl -match "github.com[:/](.+)\.git") {
        $RepoPath = $Matches[1]
        Write-Info "Monitor CI at: https://github.com/$RepoPath/actions"
    }
} else {
    Write-Failure "Push failed"
    exit 1
}
