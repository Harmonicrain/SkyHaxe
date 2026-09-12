[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
Push-Location $repoRoot
try {
    & python evidence/prepare_openfl_window_candidate.py
    if ($LASTEXITCODE -ne 0) { throw 'Pinned OpenFL candidate preparation failed' }
    & python evidence/prepare_embedded_candidate.py
    if ($LASTEXITCODE -ne 0) { throw 'Pinned embedded assets preparation failed' }
    & python evidence/prepare_window_skin_candidate.py
    if ($LASTEXITCODE -ne 0) { throw 'Original window skins preparation failed' }
    & python scripts/generate-infostand-compile-root.py --window-manager
    if ($LASTEXITCODE -ne 0) { throw 'Window manager compile root is incomplete' }
    & haxelib run openfl build project.v22-window-manager.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw 'Window manager foundation does not compile' }
    & haxelib run openfl build project.v22-window-runtime.xml html5 -debug
    if ($LASTEXITCODE -ne 0) { throw 'Window runtime canary does not compile' }
    & python scripts/verify-browser-probe.py --page test/window-runtime.html --marker V22_WINDOW_RUNTIME_PASS --result evidence/window_runtime_verification.json
    if ($LASTEXITCODE -ne 0) { throw 'Original window runtime browser gate failed' }
} finally { Pop-Location }
