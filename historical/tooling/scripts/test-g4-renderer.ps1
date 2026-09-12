[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
Push-Location $repoRoot
try {
    & haxelib run openfl build project.g4-renderer.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw "G4 HTML5 build failed with exit code $LASTEXITCODE" }
    $index = Join-Path $repoRoot "build\tests\g4-renderer\html5\bin\index.html"
    if (-not (Test-Path -LiteralPath $index -PathType Leaf)) { throw "OpenFL did not produce $index" }
    Write-Host "Built $index"
    Write-Host "Run: python scripts/serve-g4.py --port 8771"
}
finally { Pop-Location }
