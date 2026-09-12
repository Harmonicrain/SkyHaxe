[CmdletBinding()]
param(
    [switch] $SkipBootstrap,
    [string] $SourceRoot = $env:SKYHAXE_SOURCE_ROOT,
    [string] $CandidateRoot,
    [string] $OutputDirectory
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path

$projectFile = Join-Path $repoRoot "project.xml"
if (-not [string]::IsNullOrWhiteSpace($CandidateRoot)) {
    $CandidateRoot = (Resolve-Path -LiteralPath $CandidateRoot).Path
    $SourceRoot = Join-Path $CandidateRoot "upstream"
    foreach ($relative in @("generated", "platform", "compat", "build-support\assets", "upstream\src")) {
        if (-not (Test-Path -LiteralPath (Join-Path $CandidateRoot $relative) -PathType Container)) {
            throw "Candidate is missing isolated build input: $relative"
        }
    }
    if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
        $OutputDirectory = Join-Path $CandidateRoot "build\client"
    }
    $slash = { param($value) ([System.IO.Path]::GetFullPath($value)).Replace("\", "/") }
    $xml = Get-Content -LiteralPath $projectFile -Raw
    $xml = $xml.Replace('path="build/client"', 'path="' + (& $slash $OutputDirectory) + '"')
    $xml = $xml.Replace('<source path="src" />', '<source path="' + (& $slash (Join-Path $repoRoot "src")) + '" />')
    $xml = $xml.Replace('<source path=".skyhaxe/compat" />', '<source path="' + (& $slash (Join-Path $CandidateRoot "compat")) + '" />')
    $xml = $xml.Replace('<source path=".skyhaxe/generated" />', '<source path="' + (& $slash (Join-Path $CandidateRoot "generated")) + '" />')
    $xml = $xml.Replace('value=".skyhaxe/platform"', 'value="' + (& $slash (Join-Path $CandidateRoot "platform")) + '"')
    $xml = $xml.Replace('<source path="build-support/platform" />', '<source path="' + (& $slash (Join-Path $repoRoot "build-support\platform")) + '" />')
    $xml = $xml.Replace('<source path="client" />', '<source path="' + (& $slash (Join-Path $repoRoot "client")) + '" />')
    $xml = $xml.Replace('path="client/config.ini"', 'path="' + (& $slash (Join-Path $repoRoot "client\config.ini")) + '"')
    $xml = $xml.Replace('path="public/swf-decode-worker.js"', 'path="' + (& $slash (Join-Path $repoRoot "public\swf-decode-worker.js")) + '"')
    $xml = $xml.Replace('build-support/assets/', 'build-support/assets/')
    $projectFile = Join-Path $CandidateRoot "project.xml"
    [System.IO.File]::WriteAllText($projectFile, $xml, [System.Text.UTF8Encoding]::new($false))
}

if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
    throw "Set SKYHAXE_SOURCE_ROOT or pass -SourceRoot with a wired2-ngh Habbo-Sky checkout"
}
$SourceRoot = (Resolve-Path -LiteralPath $SourceRoot).Path
if (-not (Test-Path -LiteralPath (Join-Path $SourceRoot "src") -PathType Container)) {
    throw "Habbo-Sky source root has no src directory: $SourceRoot"
}
$env:SKYHAXE_SOURCE_ROOT = $SourceRoot.Replace("\", "/")

if (-not $SkipBootstrap) {
    & (Join-Path $PSScriptRoot "bootstrap-toolchain.ps1")
}
. (Join-Path $PSScriptRoot "toolchain-env.ps1")

$required = if ($CandidateRoot) {
    @($projectFile, "client\V32BrowserMain.hx", "client\config.ini")
} else {
    @("project.xml", "client\V32BrowserMain.hx", "client\config.ini",
      ".skyhaxe\generated", ".skyhaxe\platform", ".skyhaxe\compat",
      "build-support\assets\component-library-assets.xml")
}
foreach ($relative in $required) {
    $path = if ([System.IO.Path]::IsPathRooted($relative)) { $relative } else { Join-Path $repoRoot $relative }
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing supported build input: $path" }
}

Push-Location $repoRoot
try {
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try { & haxelib run openfl build $projectFile html5 -debug }
    finally { $ErrorActionPreference = $previousPreference }
    if ($LASTEXITCODE -ne 0) { throw "OpenFL HTML5 build failed with exit code $LASTEXITCODE" }

    $effectiveOutput = if ($CandidateRoot) { $OutputDirectory } else { Join-Path $repoRoot "build\client" }
    $index = Join-Path $effectiveOutput "html5\bin\index.html"
    if (-not (Test-Path -LiteralPath $index -PathType Leaf)) {
        throw "OpenFL reported success but did not produce $index"
    }
    Write-Host "Built $index"
}
finally { Pop-Location }
