[CmdletBinding()]
param(
    [string] $BuiltClientRoot,
    [string] $TextRoot,
    [string] $OutputDirectory,
    [string] $Version = '0.1.0-dev',
    [string] $OwnerGuidePath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if ([string]::IsNullOrWhiteSpace($BuiltClientRoot)) {
    $BuiltClientRoot = Join-Path $PSScriptRoot '..\build\client\html5\bin'
}
if ([string]::IsNullOrWhiteSpace($TextRoot)) {
    $TextRoot = Join-Path $PSScriptRoot '..\public\assets\habbo-text'
}
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $PSScriptRoot '..\build\release'
}
$built = (Resolve-Path -LiteralPath $BuiltClientRoot).Path
$textResources = (Resolve-Path -LiteralPath $TextRoot).Path
$destination = [System.IO.Path]::GetFullPath($OutputDirectory)
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if (-not $destination.StartsWith($repo, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Release output must remain under the SkyHaxe repository.'
}
foreach ($required in @('index.html', 'skyhaxe.js', 'lib\default.pak', 'swf-decode-worker.js', 'config.ini')) {
    if (-not (Test-Path -LiteralPath (Join-Path $built $required) -PathType Leaf)) {
        throw "Built client is missing $required"
    }
}
foreach ($required in @('manifest.json', 'text.mjs', 'native-core.mjs')) {
    if (-not (Test-Path -LiteralPath (Join-Path $textResources $required) -PathType Leaf)) {
        throw "Habbo font resource tree is missing $required"
    }
}
$textManifest = Get-Content -LiteralPath (Join-Path $textResources 'manifest.json') -Raw |
    ConvertFrom-Json
foreach ($resource in @($textManifest.files)) {
    if ($resource.file -notmatch '^(text\.mjs|native-core\.mjs|(fonts|profiles)/[\w.-]+)$') {
        throw "Unsafe font manifest path: $($resource.file)"
    }
    $resourcePath = Join-Path $textResources $resource.file
    if (-not (Test-Path -LiteralPath $resourcePath -PathType Leaf)) { throw "Missing font resource: $($resource.file)" }
    if ((Get-Item -LiteralPath $resourcePath).Length -ne [long]$resource.bytes -or
        (Get-FileHash -LiteralPath $resourcePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $resource.sha256) {
        throw "Habbo font resource differs: $($resource.file)"
    }
}
$clientJavaScript = Join-Path $built 'skyhaxe.js'
if (Select-String -LiteralPath $clientJavaScript -SimpleMatch 'skyhaxe_PerformanceHud.show' -Quiet) {
    throw 'Built client contains the debug FPS HUD. Rebuild with scripts/build.ps1 -Release.'
}

if (Test-Path -LiteralPath $destination) {
    $resolved = (Resolve-Path -LiteralPath $destination).Path
    if (-not $resolved.StartsWith($repo, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe release target.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
New-Item -ItemType Directory -Path $destination | Out-Null
Get-ChildItem -LiteralPath $built -Force |
    Where-Object Name -NotLike '*.map' |
    Copy-Item -Destination $destination -Recurse -Force
$textDestination = Join-Path $destination 'assets\habbo-text'
New-Item -ItemType Directory -Path $textDestination -Force | Out-Null
Copy-Item -Path (Join-Path $textResources '*') -Destination $textDestination -Recurse -Force
$deployDestination = Join-Path $destination 'deploy'
New-Item -ItemType Directory -Path $deployDestination -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $repo 'deploy\nginx-skyhaxe.conf.example') -Destination $deployDestination -Force
if (-not [string]::IsNullOrWhiteSpace($OwnerGuidePath)) {
    $guide = (Resolve-Path -LiteralPath $OwnerGuidePath).Path
    Copy-Item -LiteralPath $guide -Destination (Join-Path $destination 'SERVER-OWNER-GUIDE.md') -Force
}

$release = [ordered]@{
    product = 'SkyHaxe'
    version = $Version
    built_at_utc = [DateTime]::UtcNow.ToString('o')
    git_revision = (git -C $repo rev-parse HEAD).Trim()
    source_has_uncommitted_changes = [bool](git -C $repo status --porcelain)
    runtime_assets_bundled = $false
    runtime_assets_note = 'Supply compatible original SWFs and gamedata at base.url.'
}
$release | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $destination 'release.json') -Encoding UTF8
$checksums = Get-ChildItem -LiteralPath $destination -Recurse -File |
    Where-Object Name -ne 'SHA256SUMS' |
    Sort-Object FullName |
    ForEach-Object {
        $relative = $_.FullName.Substring($destination.Length + 1).Replace('\', '/')
        '{0}  {1}' -f (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant(), $relative
    }
$checksums | Set-Content -LiteralPath (Join-Path $destination 'SHA256SUMS') -Encoding ascii
Write-Host "Packaged operator release at $destination"
