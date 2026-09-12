param([ValidatePattern('^v[0-9]+$')][string]$Version = "v31")

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repo ".toolchain\v21\openfl"
$target = Join-Path $repo ".toolchain\$Version\platform"
$expectedTarget = [IO.Path]::GetFullPath((Join-Path $repo ".toolchain\$Version\platform"))
$resolvedTarget = [IO.Path]::GetFullPath($target)
if ($resolvedTarget -ne $expectedTarget) {
    throw "Refusing to prepare unexpected target: $resolvedTarget"
}

if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Missing prepared v21 platform root: $source"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
foreach ($package in @("openfl", "skyhaxe")) {
    $from = Join-Path $source $package
    $to = Join-Path $target $package
    if (Test-Path -LiteralPath $to) {
        Remove-Item -LiteralPath $to -Recurse -Force
    }
    Copy-Item -LiteralPath $from -Destination $to -Recurse
}

$unexpected = Get-ChildItem -LiteralPath $target -Directory |
    Where-Object { $_.Name -notin @("openfl", "skyhaxe") }
if ($unexpected) {
    throw "Unexpected package in isolated platform root: $($unexpected.Name -join ', ')"
}

Write-Output "Prepared $Version platform-only root (openfl + skyhaxe; no com/sulake feature overrides)."
