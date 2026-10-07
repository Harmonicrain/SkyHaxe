[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$openflRoot = Join-Path $repoRoot ".haxelib\openfl\9,5,2"
$patch = Join-Path $repoRoot "build-support\toolchain\openfl-9.5.2-html5-texture-state.patch"
$targets = [ordered]@{
    "src/openfl/display3D/Context3D.hx" = @{
        Before = "3c831d9c1e06afc4b1d682a1474db2372fcf2aa0fd1ef53ff6c461c1ca494a81"
        After = "6cfe83c0369ecefab9e3572b6048dd92f9c27db901f2c6fc977364c7bc595f70"
    }
    "src/openfl/display3D/_internal/Context3DState.hx" = @{
        Before = "3a30102691fa088557f6d3694be6301cb0bbf4c28bca99592258299fce803d34"
        After = "e3f0339dacdea7220cff6a84dac81725b12f7ba4c4696b4ee8a8cbee41483820"
    }
}

function Get-TargetHashes {
    $result = [ordered]@{}
    foreach ($relative in $targets.Keys) {
        $path = Join-Path $openflRoot $relative
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Pinned OpenFL file is missing: $path"
        }
        # Haxelib archives can materialize either LF or CRLF on Windows. Guard the
        # source content while treating that transport-only difference as equal.
        $content = [IO.File]::ReadAllText($path).Replace("`r`n", "`n")
        $bytes = [Text.UTF8Encoding]::new($false).GetBytes($content)
        $result[$relative] = ([BitConverter]::ToString(
            [Security.Cryptography.SHA256]::HashData($bytes)
        )).Replace("-", "").ToLowerInvariant()
    }
    return $result
}

$hashes = Get-TargetHashes
$alreadyApplied = $true
$pristine = $true
foreach ($relative in $targets.Keys) {
    $alreadyApplied = $alreadyApplied -and ($hashes[$relative] -eq $targets[$relative].After)
    $pristine = $pristine -and ($hashes[$relative] -eq $targets[$relative].Before)
}
if ($alreadyApplied) {
    Write-Host "OpenFL HTML5 texture-state adaptation already applied"
}
else {
    if (-not $pristine) {
        throw "Refusing to patch OpenFL 9.5.2: one or more guarded source hashes are unexpected"
    }

    & git -C $repoRoot apply --check --ignore-space-change --directory=".haxelib/openfl/9,5,2" $patch
    if ($LASTEXITCODE -ne 0) { throw "OpenFL texture-state patch preflight failed" }
    & git -C $repoRoot apply --ignore-space-change --directory=".haxelib/openfl/9,5,2" $patch
    if ($LASTEXITCODE -ne 0) { throw "OpenFL texture-state patch failed" }

    $hashes = Get-TargetHashes
    foreach ($relative in $targets.Keys) {
        if ($hashes[$relative] -ne $targets[$relative].After) {
            throw "OpenFL texture-state patch produced an unexpected hash for $relative"
        }
    }
    Write-Host "Applied guarded OpenFL HTML5 texture-state adaptation"
}

$patch = Join-Path $repoRoot "build-support\toolchain\openfl-9.5.2-room-batching.patch"
$targets = [ordered]@{
    "src/openfl/display/_internal/Context3DDisplayObjectContainer.hx" = @{
        Before = "01f2e9d225d1753839dfe633891a47c2a759c5a0ffe9c9d230becadb775916ee"
        After = "445c0393ca63755ff121ccfec6623a09203c3b0ebeb351fc783fe1137586a470"
    }
    "src/openfl/display/_internal/Context3DBitmap.hx" = @{
        Before = "8ee8d67cc24a9c5ea77c8208555bc112e619587fe369815bdcf7aa9ba1d8f70f"
        After = "b4cde5245c917f5e26401d9c3a9c6af69ae6d24baab6586764820f50e3c84ccb"
    }
}

$hashes = Get-TargetHashes
$alreadyApplied = $true
$pristine = $true
foreach ($relative in $targets.Keys) {
    $alreadyApplied = $alreadyApplied -and ($hashes[$relative] -eq $targets[$relative].After)
    $pristine = $pristine -and ($hashes[$relative] -eq $targets[$relative].Before)
}
if ($alreadyApplied) {
    Write-Host "OpenFL room-batching boundary already applied"
}
else {
    if (-not $pristine) {
        throw "Refusing to patch OpenFL room renderer: one or more guarded source hashes are unexpected"
    }
    & git -C $repoRoot apply --check --ignore-space-change --directory=".haxelib/openfl/9,5,2" $patch
    if ($LASTEXITCODE -ne 0) { throw "OpenFL room-batching patch preflight failed" }
    & git -C $repoRoot apply --ignore-space-change --directory=".haxelib/openfl/9,5,2" $patch
    if ($LASTEXITCODE -ne 0) { throw "OpenFL room-batching patch failed" }
    $hashes = Get-TargetHashes
    foreach ($relative in $targets.Keys) {
        if ($hashes[$relative] -ne $targets[$relative].After) {
            throw "OpenFL room-batching patch produced an unexpected hash for $relative"
        }
    }
    Write-Host "Applied guarded OpenFL room-batching boundary"
}
