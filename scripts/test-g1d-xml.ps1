[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")

$outputDirectory = Join-Path $repoRoot "build\tests"
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$outputFile = Join-Path $outputDirectory "g1d-xml.js"

Push-Location $repoRoot
try {
    & haxe -cp src -cp test -main G1dXmlTest -js $outputFile
    if ($LASTEXITCODE -ne 0) {
        throw "G1d XML test compilation failed with exit code $LASTEXITCODE"
    }

    $testOutput = & node $outputFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        $testOutput | Write-Host
        throw "G1d XML JavaScript tests failed with exit code $LASTEXITCODE"
    }
    $testOutput | Write-Host
    if (($testOutput -join "`n") -notmatch "G1D_XML_PASS assertions=([0-9]+)") {
        throw "G1d XML JavaScript tests did not emit their pass marker"
    }

    & haxe -cp src -cp test -main G1dXmlTest --interp
    if ($LASTEXITCODE -ne 0) {
        throw "G1d XML interpreter tests failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}
