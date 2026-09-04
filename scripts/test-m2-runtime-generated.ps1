[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
$output = Join-Path $repoRoot "build\tests\m2-runtime\html5\bin\m2-runtime.js"

Push-Location $repoRoot
try {
    # Use the real OpenFL target setup. Bare `haxe -lib openfl` does not define the Lime/OpenFL
    # backend surface and gives false failures as soon as a generated leaf imports an Event type.
    & haxelib run openfl build project.m2-runtime.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw "generated runtime compile failed with exit code $LASTEXITCODE" }
    & python evidence/m2_compile_frontier.py
    if ($LASTEXITCODE -ne 0) { throw "generated frontier evidence failed with exit code $LASTEXITCODE" }
    Write-Host "M2_RUNTIME_COMPILE_PASS $output"
}
finally { Pop-Location }
