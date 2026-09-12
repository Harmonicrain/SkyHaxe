[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $SourceRoot,
    [string] $CandidatesRoot = $env:SKYHAXE_CANDIDATES_ROOT,
    [string] $FlexRoot = $env:SKYHAXE_FLEX_ROOT,
    [string] $CandidateId,
    [switch] $IncludeDirty,
    [switch] $Finalize
)
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($CandidatesRoot)) {
    throw "Set SKYHAXE_CANDIDATES_ROOT or pass -CandidatesRoot (outside the repository)"
}
if ([string]::IsNullOrWhiteSpace($FlexRoot)) {
    throw "Set SKYHAXE_FLEX_ROOT or pass -FlexRoot with the Flex/AIR SDK root"
}
$env:SKYHAXE_FLEX_ROOT = (Resolve-Path -LiteralPath $FlexRoot).Path
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$argsList = @((Join-Path $repo "build-support\generation\update-client.py"), "prepare",
              "--source-root", $SourceRoot, "--candidates-root", $CandidatesRoot)
if ($CandidateId) { $argsList += @("--candidate-id", $CandidateId) }
if ($IncludeDirty) { $argsList += "--include-dirty" }
if ($Finalize) { $argsList += "--finalize" }
& python @argsList
if ($LASTEXITCODE -ne 0) { throw "Update candidate failed with exit code $LASTEXITCODE" }
