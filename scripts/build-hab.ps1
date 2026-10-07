#Requires -Version 5.1
<#
.SYNOPSIS
  Convert the runtime corpus's asset SWFs into .hab bundles with swf2hab (incremental).

.DESCRIPTION
  swf2hab is a separate, standalone project (Python 3.9+, no required dependencies). This script
  only invokes it. Output mirrors the corpus under <RuntimeRoot>\hab\, which is where
  client/config.ini's asset.hab.url points, so the original SWFs are never touched. A .hab newer
  than its .swf is skipped unless -Force is given; any SWF without a .hab keeps loading as SWF.

.EXAMPLE
  $env:SKYHAXE_RUNTIME_ROOT = 'C:\path\to\ngh'
  $env:SWF2HAB_ROOT = 'C:\path\to\swf2hab'
  .\scripts\build-hab.ps1
#>
[CmdletBinding()]
param(
    [string] $RuntimeRoot = $env:SKYHAXE_RUNTIME_ROOT,
    [string] $Swf2HabRoot = $env:SWF2HAB_ROOT,
    [string[]] $Trees = @('gordon\PRODUCTION-201611291003-338511768', 'dcr\hof_furni'),
    [string[]] $Exclude = @('Habbo.swf', 'HabboAir.swf', '*backup*'),
    [ValidateSet('full', 'sulake')] [string] $Profile = 'full',
    [int] $Jobs = [Math]::Max(1, [Environment]::ProcessorCount - 1),
    [switch] $Force
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RuntimeRoot)) { throw 'Pass -RuntimeRoot or set SKYHAXE_RUNTIME_ROOT.' }
if ([string]::IsNullOrWhiteSpace($Swf2HabRoot)) { throw 'Pass -Swf2HabRoot or set SWF2HAB_ROOT (the swf2hab checkout).' }
$runtime = (Resolve-Path -LiteralPath $RuntimeRoot).Path
$converter = (Resolve-Path -LiteralPath $Swf2HabRoot).Path
if (-not (Test-Path -LiteralPath (Join-Path $converter 'swf2hab\__main__.py'))) {
    throw "$converter is not a swf2hab checkout"
}
$habRoot = Join-Path $runtime 'hab'
$reports = Join-Path $habRoot 'reports'
New-Item -ItemType Directory -Force -Path $reports | Out-Null

$failed = $false
foreach ($tree in $Trees) {
    $source = Join-Path $runtime $tree
    if (-not (Test-Path -LiteralPath $source -PathType Container)) { Write-Warning "skipping missing $source"; continue }
    $output = Join-Path $habRoot $tree
    $report = Join-Path $reports (($tree -replace '[\\/]+', '-') + '.json')
    $arguments = @('-m', 'swf2hab', 'convert', $source, '-o', $output, '--profile', $Profile,
        '-j', $Jobs, '--report', $report)
    foreach ($pattern in $Exclude) { $arguments += @('--exclude', $pattern) }
    if ($Force) { $arguments += '--force' }
    Push-Location $converter
    try {
        & python @arguments
        if ($LASTEXITCODE -ne 0) { $failed = $true; Write-Warning "swf2hab reported failures for $tree (see $report)" }
    } finally { Pop-Location }
}

Push-Location $converter
try {
    & python -m swf2hab verify $habRoot
    if ($LASTEXITCODE -ne 0) { throw 'Some .hab files failed validation.' }
} finally { Pop-Location }
if ($failed) { exit 2 }
