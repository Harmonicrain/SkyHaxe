[CmdletBinding()]
param(
    [string] $Chrome = 'C:/Program Files/Google/Chrome/Application/chrome.exe',
    [int] $Port = 8791,
    [string] $RuntimeRoot = $env:SKYHAXE_RUNTIME_ROOT,
    # Records the current output as the answer to compare against. Use only when the digests are
    # meant to move -- a decoder change that alters pixels is a defect until proven otherwise.
    [switch] $Record
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ([string]::IsNullOrWhiteSpace($RuntimeRoot)) {
    throw 'Set SKYHAXE_RUNTIME_ROOT or pass -RuntimeRoot'
}
$RuntimeRoot = (Resolve-Path -LiteralPath $RuntimeRoot).Path
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    $stage = '.toolchain/swf-decode'
    $corpus = Join-Path $stage 'corpus'
    New-Item -ItemType Directory -Force -Path $corpus | Out-Null

    # The asset corpus is read-only, so the four fixtures are copied into the scratch tree and
    # served from there rather than mounted. fetch() is not permitted against file:// URLs, which
    # is why this needs a server at all.
    $fixtures = @(
        (Join-Path $RuntimeRoot 'dcr/hof_furni/easter_c18_chair.swf'),
        (Join-Path $RuntimeRoot 'dcr/hof_furni/rainbow_ltd19_parasol.swf'),
        (Join-Path $RuntimeRoot 'gordon/PRODUCTION-201611291003-338511768/HabboRoomContent.swf'),
        (Join-Path $RuntimeRoot 'gordon/PRODUCTION-201611291003-338511768/hh_human_body.swf')
    )
    foreach ($fixture in $fixtures) {
        if (-not (Test-Path -LiteralPath $fixture)) { throw "Missing decode fixture: $fixture" }
        Copy-Item -LiteralPath $fixture -Destination $corpus -Force
    }
    Copy-Item -LiteralPath 'test/swf-decode.html' -Destination $stage -Force
    Copy-Item -LiteralPath 'public/swf-decode-worker.js' -Destination $stage -Force

    & haxe -cp src -cp .skyhaxe/compat -cp .skyhaxe/generated -cp test -lib lime -lib openfl `
        --remap flash:openfl -D html5 -main SwfBitmapDecodeTest -js "$stage/test.js"
    if ($LASTEXITCODE -ne 0) { throw 'SWF decode baseline did not compile' }

    $server = Start-Process -FilePath 'python' `
        -ArgumentList @('-m', 'http.server', "$Port", '--bind', '127.0.0.1', '--directory', $stage) `
        -WorkingDirectory $repoRoot -WindowStyle Hidden -PassThru
    try {
        $ready = $false
        for ($attempt = 0; $attempt -lt 40; $attempt++) {
            try {
                Invoke-WebRequest -Uri "http://127.0.0.1:$Port/swf-decode.html" -UseBasicParsing -TimeoutSec 2 | Out-Null
                $ready = $true; break
            } catch { Start-Sleep -Milliseconds 250 }
        }
        if (-not $ready) { throw "Fixture server did not start on port $Port" }

        $dom = & node 'scripts/wait-browser-body.js' --chrome $Chrome `
            --url "http://127.0.0.1:$Port/swf-decode.html" --timeout 120000 `
            --debug-port ($Port + 1000) | Out-String
        $browserExit = $LASTEXITCODE
    } finally {
        if ($server -and -not $server.HasExited) { Stop-Process -Id $server.Id -Force }
    }

    $html = $dom -join "`n"
    $match = [regex]::Match($html, 'SWF_DECODE_BASELINE (\{.*\})', 'Singleline')
    if (-not $match.Success) { throw "Decode baseline produced no result: $html" }
    $observed = $match.Groups[1].Value

    $baselinePath = 'evidence/swf_decode_baseline.json'
    $recorded = $false
    if ($Record -or -not (Test-Path -LiteralPath $baselinePath)) {
        Set-Content -LiteralPath $baselinePath -Value $observed -Encoding utf8
        $recorded = $true
    }
    $expected = (Get-Content -LiteralPath $baselinePath -Raw).Trim()

    # Compared as text: the digests are the contract, and any drift in one of them is a change in
    # what a furni looks like on screen.
    $matches = ($observed.Trim() -eq $expected)
    $parsed = $observed | ConvertFrom-Json
    $characters = 0
    foreach ($file in $parsed.files) {
        if ($file.PSObject.Properties.Name -contains 'characters') { $characters += $file.characters.Count }
    }

    $result = [ordered]@{
        ok = ($matches -and $parsed.ok -and $browserExit -eq 0)
        target = 'SwfFile.readAsync + worker/native decode + direct BitmapData handoff'
        baseline = $baselinePath
        recorded_this_run = $recorded
        matches_baseline = $matches
        browser_exit = $browserExit
        fixtures = $fixtures
        bitmap_characters = $characters
    }
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath 'evidence/swf_decode_verification.json' -Encoding utf8
    if (-not $result.ok) { throw "SWF decode digests moved. Compare $baselinePath against the run above." }
    Write-Output ("SWF_DECODE_OK characters=$characters recorded=$recorded")
} finally { Pop-Location }
