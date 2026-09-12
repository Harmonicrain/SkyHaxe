[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    & python evidence/prepare_embedded_candidate.py
    if ($LASTEXITCODE -ne 0) { throw 'Embedded manifest preparation failed' }
    & haxelib run openfl build project.v22-embedded.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw 'Embedded asset canary build failed' }
    & python scripts/verify-browser-probe.py --page build/tests/v22-embedded/html5/bin/index.html --marker V22_EMBEDDED_PASS --result evidence/embedded_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Embedded asset canary failed' }
    & haxe -cp src -cp .toolchain/ax3/compat -cp generated -cp test -lib lime -lib openfl --remap flash:openfl -D html5 -main V22HostBridgeTest -js .toolchain/v21/host-test.js
    if ($LASTEXITCODE -ne 0) { throw 'Host contract build failed' }
    & python scripts/verify-browser-probe.py --page test/window-host.html --marker V22_HOST_PASS --result evidence/window_host_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Host contract failed' }
    & haxe -cp src -cp .toolchain/ax3/compat -cp generated -cp test -lib lime -lib openfl --remap flash:openfl -D html5 -main V22AssetLoadingTest -js .toolchain/v21/asset-test.js
    if ($LASTEXITCODE -ne 0) { throw 'Asset-load contract build failed' }
    & python scripts/verify-browser-probe.py --page test/window-assets.html --marker V22_ASSET_LOADING_PASS --result evidence/window_asset_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Asset-load contract failed' }
} finally { Pop-Location }
