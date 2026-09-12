[CmdletBinding()]
param(
    [ValidateRange(1, 65535)]
    [int] $Port = 8080
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$webRoot = Join-Path $repoRoot "build\html5\bin"
if (-not (Test-Path -LiteralPath (Join-Path $webRoot "index.html") -PathType Leaf)) {
    throw "No HTML5 build found. Run scripts/build-html5.ps1 first."
}

Write-Host "Serving SkyHaxe at http://127.0.0.1:$Port/"
& python -m http.server $Port --bind 127.0.0.1 --directory $webRoot

