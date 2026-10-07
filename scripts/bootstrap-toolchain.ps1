[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$toolchainRoot = Join-Path $repoRoot ".toolchain"
$downloadsRoot = Join-Path $toolchainRoot "downloads"

$archives = @{
    Haxe = @{
        File = "haxe-4.3.7-win64.zip"
        Url = "https://github.com/HaxeFoundation/haxe/releases/download/4.3.7/haxe-4.3.7-win64.zip"
        Sha256 = "29F7ACB0FB9FC66A2B9F6BD9453AF3474CCB14EBD9FD0142F351D7311C4010C9"
    }
    Neko = @{
        File = "neko-2.4.1-win64.zip"
        Url = "https://github.com/HaxeFoundation/neko/releases/download/v2-4-1/neko-2.4.1-win64.zip"
        Sha256 = "3902933DA42320E8BC04DBEE07959EE9FF09A7848E9AF48072396400CC3618C9"
    }
    Lime = @{
        File = "lime-8.3.2.zip"
        Url = "https://haxelib-files.haxe.org/files/3.0/lime-8,3,2.zip"
        Sha256 = "AB44323146DFF6512458FCB03B1C32CB9C492C64F2C0E574DE9D5D929B929DFF"
    }
    OpenFL = @{
        File = "openfl-9.5.2.zip"
        Url = "https://haxelib-files.haxe.org/files/3.0/openfl-9,5,2.zip"
        Sha256 = "873FA3739D80CC9AC0F48D3E27CC5684BFD60331F68CAF647979DE6FF437D273"
    }
}

function Assert-GeneratedPath([string] $path) {
    $root = [IO.Path]::GetFullPath($toolchainRoot).TrimEnd("\") + "\"
    $candidate = [IO.Path]::GetFullPath($path)
    if (-not $candidate.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to modify a path outside the generated toolchain directory: $candidate"
    }
}

function Get-PinnedArchive([hashtable] $archive) {
    $destination = Join-Path $downloadsRoot $archive.File
    if (Test-Path -LiteralPath $destination -PathType Leaf) {
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $destination).Hash
        if ($actual -eq $archive.Sha256) {
            return $destination
        }
        Assert-GeneratedPath $destination
        Remove-Item -LiteralPath $destination
    }

    $partial = "$destination.download"
    Assert-GeneratedPath $partial
    if (Test-Path -LiteralPath $partial) {
        Remove-Item -LiteralPath $partial
    }

    $curl = Get-Command curl.exe -ErrorAction Stop
    & $curl.Source --silent --show-error --fail --location --retry 3 --output $partial $archive.Url
    if ($LASTEXITCODE -ne 0) {
        throw "Download failed: $($archive.Url)"
    }

    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $partial).Hash
    if ($actual -ne $archive.Sha256) {
        Remove-Item -LiteralPath $partial
        throw "SHA-256 mismatch for $($archive.File): expected $($archive.Sha256), got $actual"
    }

    Move-Item -LiteralPath $partial -Destination $destination
    return $destination
}

function Expand-PinnedArchive(
    [string] $archive,
    [string] $destination,
    [string] $expectedFile
) {
    $expectedPath = Join-Path $destination $expectedFile
    if (Test-Path -LiteralPath $expectedPath -PathType Leaf) {
        return
    }

    Assert-GeneratedPath $destination
    $staging = "$destination.installing"
    Assert-GeneratedPath $staging
    foreach ($generated in @($staging, $destination)) {
        if (Test-Path -LiteralPath $generated) {
            Remove-Item -LiteralPath $generated -Recurse -Force
        }
    }

    New-Item -ItemType Directory -Path $staging | Out-Null
    & tar.exe --strip-components=1 -xf $archive -C $staging
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $staging $expectedFile))) {
        throw "Could not extract $archive"
    }
    Move-Item -LiteralPath $staging -Destination $destination
}

New-Item -ItemType Directory -Force -Path $downloadsRoot | Out-Null

$haxeArchive = Get-PinnedArchive $archives.Haxe
$nekoArchive = Get-PinnedArchive $archives.Neko
$limeArchive = Get-PinnedArchive $archives.Lime
$openflArchive = Get-PinnedArchive $archives.OpenFL

Expand-PinnedArchive $haxeArchive (Join-Path $toolchainRoot "haxe-4.3.7") "haxe.exe"
Expand-PinnedArchive $nekoArchive (Join-Path $toolchainRoot "neko-2.4.1") "neko.exe"

. (Join-Path $PSScriptRoot "toolchain-env.ps1")

Push-Location $repoRoot
try {
    if (-not (Test-Path -LiteralPath ".haxelib" -PathType Container)) {
        & haxelib newrepo
        if ($LASTEXITCODE -ne 0) {
            throw "Could not create the project-local Haxelib repository"
        }
    }

    $installed = (& haxelib list 2>&1) -join "`n"
    if ($installed -notmatch "(?m)^lime:.*\[8\.3\.2\]") {
        & haxelib install $limeArchive --always
        if ($LASTEXITCODE -ne 0) {
            throw "Could not install Lime 8.3.2"
        }
    }
    if ($installed -notmatch "(?m)^openfl:.*\[9\.5\.2\]") {
        & haxelib install $openflArchive --always
        if ($LASTEXITCODE -ne 0) {
            throw "Could not install OpenFL 9.5.2"
        }
    }

    & haxelib set lime 8.3.2 | Out-Null
    & haxelib set openfl 9.5.2 | Out-Null

    & (Join-Path $PSScriptRoot "apply-toolchain-patches.ps1")
    if ($LASTEXITCODE -ne 0) {
        throw "Could not apply guarded toolchain adaptations"
    }

    Write-Host "Haxe   $(& haxe --version)"
    Write-Host "Neko   $(& neko -version)"
    Write-Host "Haxelib $(& haxelib version)"
    Write-Host "Lime   8.3.2"
    Write-Host "OpenFL 9.5.2"
}
finally {
    Pop-Location
}
