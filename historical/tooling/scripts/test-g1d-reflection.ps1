[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")

$outputDirectory = Join-Path $repoRoot "build\tests"
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$outputFile = Join-Path $outputDirectory "g1d-reflection.js"

Push-Location $repoRoot
try {
    & haxe -cp src -cp test -main G1dReflectionTest -js $outputFile
    if ($LASTEXITCODE -ne 0) {
        throw "G1d reflection JavaScript compilation failed with exit code $LASTEXITCODE"
    }
    $javascriptOutput = & node $outputFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        $javascriptOutput | Write-Host
        throw "G1d reflection JavaScript tests failed with exit code $LASTEXITCODE"
    }
    $javascriptOutput | Write-Host

    & haxe -cp src -cp test -main G1dReflectionTest --interp
    if ($LASTEXITCODE -ne 0) {
        throw "G1d reflection interpreter tests failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}
