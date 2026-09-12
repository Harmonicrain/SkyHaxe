[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $Candidate,
    [string] $RollbackRoot = $env:SKYHAXE_BASELINE_ROOT
)
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RollbackRoot)) {
    throw "Set SKYHAXE_BASELINE_ROOT or pass -RollbackRoot (outside the repository)"
}
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
& python (Join-Path $repo "build-support\generation\update-client.py") promote `
    --candidate $Candidate --rollback-root $RollbackRoot
if ($LASTEXITCODE -ne 0) { throw "Promotion failed with exit code $LASTEXITCODE" }
