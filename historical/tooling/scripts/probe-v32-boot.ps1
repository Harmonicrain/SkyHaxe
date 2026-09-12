<#
    Boot probe for the v32 full-client candidate.

    This exists because the obvious way to watch the boot -- point a browser pane at it and read
    window globals -- cannot work. Lime drives its entire frame loop from requestAnimationFrame,
    and a hidden page is never given animation frames, so a backgrounded preview reports zero
    ENTER_FRAME and zero EXIT_FRAME no matter how healthy the client is. That reads exactly like
    the deadlock being investigated, which is why the measurement has to come from a browser that
    is actually running frames.

    Headless Chrome with a virtual time budget does run them, and runs them faster than wall clock,
    so a sixty second boot window costs a few seconds here. The client mirrors its diagnostics onto
    the document element (see V32BrowserMain.watchFrameEvents) precisely so --dump-dom can recover
    them; the console cannot be used for this because the component embed system emits one line per
    asset and evicts everything else.
#>
[CmdletBinding()]
param(
    [string] $Chrome = 'C:/Program Files/Google/Chrome/Application/chrome.exe',
    [int] $Port = 8766,
    [int] $BudgetMs = 60000,
    # The graph cannot fully resolve without one: HabboConfigurationManager unlocks only on the
    # localization COMPLETE callback, and HabboLocalizationManager does not request its texts until
    # HABBO_CONNECTION_EVENT_AUTHENTICATED. So a probe with no ticket stops at a legitimate wait.
    [string] $Sso = '12345'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
Push-Location $repoRoot
try {
    if (-not (Test-Path -LiteralPath $Chrome)) { throw "Chrome not found at $Chrome" }
    try {
        Invoke-WebRequest -Uri "http://127.0.0.1:$Port/index.html" -UseBasicParsing -TimeoutSec 3 | Out-Null
    } catch {
        throw "No v32 server on port $Port. Start it with: python scripts/serve-client.py --port $Port --web-root build/v32/html5/bin"
    }

    $testProfile = Join-Path ([System.IO.Path]::GetTempPath()) ('skyhaxe-v32-' + [guid]::NewGuid().ToString('N'))
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        # SwiftShader rather than --disable-gpu: OpenFL selects WebGL2 and the point of the probe is
        # to exercise the same renderer path the real client takes.
        $dom = & $Chrome --headless=new --no-first-run --no-default-browser-check `
            --use-angle=swiftshader --enable-unsafe-swiftshader --disable-dev-shm-usage `
            "--user-data-dir=$testProfile" "--virtual-time-budget=$BudgetMs" `
            --dump-dom "http://127.0.0.1:$Port/index.html#sso=$Sso" 2> '.toolchain/v32-boot-stderr.log' | Out-String
        $browserExit = $LASTEXITCODE
    } finally { $ErrorActionPreference = $previous }

    $html = $dom -join "`n"
    function Read-Attr([string] $name) {
        $m = [regex]::Match($html, $name + '="([^"]*)"')
        if ($m.Success) { return $m.Groups[1].Value } else { return $null }
    }

    $result = [ordered]@{
        browser_exit = $browserExit
        dom_bytes    = $html.Length
        state        = Read-Attr 'data-skyhaxe-candidate'
        frames       = Read-Attr 'data-skyhaxe-frames'
        locked       = Read-Attr 'data-skyhaxe-locked'
        census       = Read-Attr 'data-skyhaxe-census'
        processlog   = Read-Attr 'data-skyhaxe-processlog'
        typecheck    = Read-Attr 'data-skyhaxe-typecheck'
    }
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath 'evidence/v32_boot_probe.json' -Encoding utf8
    $result | ConvertTo-Json -Depth 4
} finally { Pop-Location }
