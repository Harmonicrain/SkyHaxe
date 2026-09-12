[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    & python evidence/v21_converter_regression.py
    if ($LASTEXITCODE -ne 0) { throw 'AS3 text conversion probe failed' }
    & haxe -cp src -cp .toolchain/ax3/compat -cp generated -cp .toolchain/tests/window-conversion/generated -cp test -lib lime -lib openfl --remap flash:openfl -D html5 -main V21FontCoverageTest -js .toolchain/v21/font-coverage.js
    if ($LASTEXITCODE -ne 0) { throw 'Generated font coverage probe did not compile' }
    & python scripts/verify-browser-probe.py --page test/font-coverage.html --marker V21_FONT_COVERAGE_PASS --result evidence/font_coverage_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Actual font-program coverage probe failed' }
    & python evidence/prepare_openfl_window_candidate.py
    if ($LASTEXITCODE -ne 0) { throw 'Pinned OpenFL candidate preparation failed' }
    & haxe -cp src -cp test -lib lime -lib openfl -cp .toolchain/v21/openfl --remap flash:openfl -D html5 -main V21SelectionTest -js .toolchain/v21/selection-test.js
    if ($LASTEXITCODE -ne 0) { throw 'Selection visibility probe did not compile' }
    & python scripts/verify-browser-probe.py --page test/window-selection.html --marker V21_SELECTION_PASS --result evidence/window_selection_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Selection visibility rendering probe failed' }
    & haxe -cp src -cp test -lib lime -lib openfl -cp .toolchain/v21/openfl --remap flash:openfl -D html5 -main V21ThicknessTest -js .toolchain/v21/thickness-test.js
    if ($LASTEXITCODE -ne 0) { throw 'Truffle text raster/layout probe did not compile' }
    & python scripts/verify-browser-probe.py --page test/window-thickness.html --marker V21_THICKNESS_PASS --result evidence/window_thickness_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Truffle text raster/layout probe failed' }
} finally { Pop-Location }
