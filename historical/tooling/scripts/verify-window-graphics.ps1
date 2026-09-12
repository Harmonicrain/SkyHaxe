[CmdletBinding()]
param([string] $Chrome = 'C:/Program Files/Google/Chrome/Application/chrome.exe')

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    & haxe -cp src -cp .toolchain/ax3/compat -cp generated -cp .toolchain/v21/generated -cp test -lib lime -lib openfl --remap flash:openfl -D html5 -main V21GraphicContextTest -js .toolchain/v21/graphics-test.js
    if ($LASTEXITCODE -ne 0) { throw 'Candidate GraphicContext regression did not compile' }
    $testProfile = Join-Path ([System.IO.Path]::GetTempPath()) ('skyhaxe-window-' + [guid]::NewGuid().ToString('N'))
    $testUrl = 'file:///' + ($repoRoot -replace '\\','/') + '/test/window-graphics.html'
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $dom = & $Chrome --headless --disable-gpu --no-first-run --no-default-browser-check --allow-file-access-from-files "--user-data-dir=$testProfile" --dump-dom $testUrl 2> .toolchain/window-graphics-browser-stderr.log | Out-String
        $browserExit = $LASTEXITCODE
    } finally { $ErrorActionPreference = $previousPreference }
    $passed = $browserExit -eq 0 -and $dom -match '<body>[^<]*V21_GRAPHIC_CONTEXT_PASS' -and $dom -notmatch '<body>[^<]*FAIL'
    $result = [ordered]@{
        ok = $passed
        target = 'isolated candidate generated GraphicContext + IGraphicContext'
        browser_exit = $browserExit
        body = ([regex]::Match($dom, '<body>([^<]*)')).Groups[1].Value
    }
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath 'evidence/window_graphics_verification.json' -Encoding utf8
    if (-not $passed) { throw "Browser graphic-context regression failed: $dom" }
    Write-Output $result.body
} finally { Pop-Location }
