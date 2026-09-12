[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $Candidate,
    [string] $FlexRoot = $env:SKYHAXE_FLEX_ROOT
)
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($FlexRoot)) {
    throw "Set SKYHAXE_FLEX_ROOT or pass -FlexRoot with the Flex/AIR SDK root"
}
$env:SKYHAXE_FLEX_ROOT = (Resolve-Path -LiteralPath $FlexRoot).Path
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
& python (Join-Path $repo "build-support\generation\update-client.py") finalize --candidate $Candidate
if ($LASTEXITCODE -ne 0) { throw "Candidate finalization failed with exit code $LASTEXITCODE" }
