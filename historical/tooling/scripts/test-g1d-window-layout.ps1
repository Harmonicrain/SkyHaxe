[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
Push-Location $repoRoot
try {
    & haxelib run openfl build project.g1d-window-layout.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw "G1d window-layout HTML5 build failed with exit code $LASTEXITCODE" }
    $index = Join-Path $repoRoot "build\tests\g1d-window-layout\html5\bin\index.html"
    if (-not (Test-Path -LiteralPath $index -PathType Leaf)) { throw "OpenFL did not produce $index" }
    Write-Host "Built $index"
}
finally { Pop-Location }
