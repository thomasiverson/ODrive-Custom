param(
    [Parameter(Mandatory=$true)]
    [string]$Symbol
)

$ErrorActionPreference = 'Continue'

Write-Host "=== Searching for symbol: $Symbol ===" -ForegroundColor Cyan
Write-Host

# Try git grep first
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[Git Search Results]" -ForegroundColor Yellow
    $gitResults = git grep -n -E $Symbol -- '*.cpp' '*.hpp' '*.c' '*.h' 2>$null
    if ($gitResults) {
        $gitResults | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "  (no matches in git index)" -ForegroundColor Gray
    }
    Write-Host
}

# Full workspace search
Write-Host "[Full Workspace Search]" -ForegroundColor Yellow
$found = $false
Get-ChildItem -Recurse -File -Include @('*.cpp','*.hpp','*.c','*.h','*.py') -ErrorAction SilentlyContinue | 
    Where-Object { 
        $_.FullName -notmatch '\.git' -and 
        $_.FullName -notmatch '\\build\\' -and 
        $_.FullName -notmatch '\\node_modules\\' -and
        $_.FullName -notmatch '\\.vscode\\'
    } | ForEach-Object {
        $matches = Select-String -Path $_.FullName -Pattern $Symbol -ErrorAction SilentlyContinue
        if ($matches) {
            $found = $true
            $matches | ForEach-Object { 
                Write-Host "  $($_.Path):$($_.LineNumber): $($_.Line.Trim())" 
            }
        }
    }

if (-not $found) {
    Write-Host "  (no matches found)" -ForegroundColor Gray
}

Write-Host
Write-Host "=== Search complete ===" -ForegroundColor Cyan
