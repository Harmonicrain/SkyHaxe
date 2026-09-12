[CmdletBinding()]
param([string] $Chrome = 'C:/Program Files/Google/Chrome/Application/chrome.exe')

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    New-Item -ItemType Directory -Force -Path '.toolchain/v7-shadow' | Out-Null
    & haxe -cp src -cp .toolchain/ax3/compat -cp generated -cp test -lib lime -lib openfl --remap flash:openfl -D html5 -main V7ShadowCoercionTest -js .toolchain/v7-shadow/test.js
    if ($LASTEXITCODE -ne 0) { throw 'Generated shadow regression did not compile' }
    $testProfile = Join-Path ([System.IO.Path]::GetTempPath()) ('skyhaxe-shadow-' + [guid]::NewGuid().ToString('N'))
    $testUrl = 'file:///' + ($repoRoot -replace '\\','/') + '/test/shadow-coercion.html'
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        # A GUI executable must be piped so Windows PowerShell waits and captures stdout.
        $dom = & $Chrome --headless --disable-gpu --no-first-run --no-default-browser-check --allow-file-access-from-files "--user-data-dir=$testProfile" --dump-dom $testUrl 2> .toolchain/shadow-browser-stderr.log | Out-String
        $browserExit = $LASTEXITCODE
    } finally { $ErrorActionPreference = $previousPreference }
    $html = $dom -join "`n"
    $passed = $browserExit -eq 0 -and $html -match '<body>[^<]*V7_SHADOW_COERCION_PASS'
    $result = [ordered]@{
        ok = $passed
        target = 'published generated FurnitureVisualization + RoomObjectModel + RoomObjectSprite'
        browser = $Chrome
        assertions = @('absent lift remains NaN', 'shadow coordinates finite at scales 32 and 64', 'finite lift preserved')
        browser_exit = $browserExit
        body = ([regex]::Match($html, '<body>([^<]*)')).Groups[1].Value
    }
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath 'evidence/shadow_verification.json' -Encoding utf8
    if (-not $passed) { throw "Browser shadow regression failed: $html" }
    Write-Output $result.body
} finally { Pop-Location }
