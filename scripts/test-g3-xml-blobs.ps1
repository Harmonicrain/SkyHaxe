[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $PSScriptRoot "toolchain-env.ps1")
Push-Location $repoRoot
try {
    & python evidence/g3_xml_blob_contract.py
    if ($LASTEXITCODE -ne 0) { throw "G3 XML contract failed with exit code $LASTEXITCODE" }
    & haxelib run openfl build project.g3-xml-blobs.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw "G3 XML browser build failed with exit code $LASTEXITCODE" }
    $index = Join-Path $repoRoot "build\tests\g3-xml-blobs\html5\bin\index.html"
    if (-not (Test-Path -LiteralPath $index -PathType Leaf)) { throw "OpenFL did not produce $index" }
    Write-Host "Built $index"
}
finally { Pop-Location }
