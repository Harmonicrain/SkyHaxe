$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$toolchainRoot = Join-Path $repoRoot ".toolchain"
$haxeRoot = Join-Path $toolchainRoot "haxe-4.3.7"
$nekoRoot = Join-Path $toolchainRoot "neko-2.4.1"

foreach ($required in @(
    (Join-Path $haxeRoot "haxe.exe"),
    (Join-Path $haxeRoot "haxelib.exe"),
    (Join-Path $nekoRoot "neko.exe")
)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "SkyHaxe toolchain is incomplete. Run scripts/bootstrap-toolchain.ps1 first. Missing: $required"
    }
}

$env:PATH = "$haxeRoot;$nekoRoot;$env:PATH"
$env:HAXE_STD_PATH = Join-Path $haxeRoot "std"
$env:NEKOPATH = $nekoRoot

