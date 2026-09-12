[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")).Path
. (Join-Path $repoRoot "scripts\toolchain-env.ps1")
$ax3Root = Join-Path $repoRoot ".toolchain\ax3"

Push-Location $ax3Root
try {
    # Haxe prints a deprecation warning for `--java ... -D jvm` on stderr. Under Windows
    # PowerShell 5.1 with $ErrorActionPreference = "Stop", any stderr line from a native
    # executable becomes a terminating NativeCommandError -- which aborted this script after a
    # successful compile but before the copy below. The exit code is the real signal, so relax
    # the preference across the call and keep checking $LASTEXITCODE.
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & haxe -cp src -lib format -D no-copt -D analyzer-optimize -main ax3.Main -java java_out -D jvm
    }
    finally { $ErrorActionPreference = $previousPreference }
    if ($LASTEXITCODE -ne 0) { throw "ax3 Haxe build failed with exit code $LASTEXITCODE" }
    $built = Join-Path $ax3Root "java_out\Main.jar"
    if (-not (Test-Path -LiteralPath $built -PathType Leaf)) {
        throw "ax3 did not produce $built"
    }
    Copy-Item -LiteralPath $built -Destination (Join-Path $ax3Root "converter-m2.jar") -Force
    Write-Host "Built .toolchain/ax3/converter-m2.jar"
}
finally { Pop-Location }
