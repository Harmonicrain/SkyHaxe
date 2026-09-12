[CmdletBinding()]
param([Parameter(Mandatory=$true)][string] $Rollback)
$ErrorActionPreference = "Stop"
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
& python (Join-Path $repo "build-support\generation\update-client.py") rollback --rollback $Rollback
if ($LASTEXITCODE -ne 0) { throw "Rollback failed with exit code $LASTEXITCODE" }
