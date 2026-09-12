[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
$outputDirectory = Join-Path $repoRoot "build\tests\v9-furniture-state"
$outputFile = Join-Path $outputDirectory "v9-furniture-state.js"

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
Push-Location $repoRoot
try {
    & haxe -cp .toolchain/ax3/compat -cp test `
        -main V9FurnitureStateSemanticsTest -js $outputFile
    if ($LASTEXITCODE -ne 0) { throw "V9 furniture-state compile failed with exit code $LASTEXITCODE" }

    $result = & node $outputFile 2>&1
    if ($LASTEXITCODE -ne 0) { throw "V9 furniture-state test failed with exit code $LASTEXITCODE`n$result" }
    $result | Write-Host
    if (($result -join "`n") -notmatch "V9_FURNITURE_STATE_SEMANTICS_PASS assertions=5") {
        throw "V9 furniture-state pass marker missing"
    }
}
finally {
    Pop-Location
}
