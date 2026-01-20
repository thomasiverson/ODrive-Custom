if (-not (Get-Command python -ErrorAction SilentlyContinue) -and -not (Get-Command python3 -ErrorAction SilentlyContinue)) {
    Write-Error "Python not found. Please install Python 3 to use this script."
    exit 1
}

$py = if (Get-Command python3 -ErrorAction SilentlyContinue) { 'python3' } else { 'python' }
& $py (Join-Path $PSScriptRoot 'list_errors_from_yaml.py')
