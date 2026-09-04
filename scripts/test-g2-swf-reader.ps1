[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
Push-Location $repoRoot
try {
    & python (Join-Path $repoRoot "evidence\g2_reader_contract.py")
    if ($LASTEXITCODE -ne 0) { throw "G2 reference contract failed with exit code $LASTEXITCODE" }
    & haxelib run openfl build project.g2-swf-reader.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw "G2 HTML5 build failed with exit code $LASTEXITCODE" }
    $index = Join-Path $repoRoot "build\tests\g2-swf-reader\html5\bin\index.html"
    if (-not (Test-Path -LiteralPath $index -PathType Leaf)) { throw "OpenFL did not produce $index" }
    Write-Host "Built $index"
    Write-Host "Now run: python scripts/serve-g2.py  (page and corpus share one origin)"
}
finally { Pop-Location }
