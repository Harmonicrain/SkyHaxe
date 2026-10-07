[CmdletBinding()]
param([string] $SourceRoot = $env:SKYHAXE_SOURCE_ROOT)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ([string]::IsNullOrWhiteSpace($SourceRoot)) { throw 'Pass -SourceRoot or set SKYHAXE_SOURCE_ROOT' }
$env:SKYHAXE_SOURCE_ROOT = (Resolve-Path -LiteralPath $SourceRoot).Path.Replace('\', '/')
. (Join-Path $PSScriptRoot 'toolchain-env.ps1')
$temporary = Join-Path $repo '.tmp-font-project.xml'
if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
$project = Get-Content -LiteralPath (Join-Path $repo 'project.xml') -Raw
$project = $project.Replace('main="V32BrowserMain" path="build/client" file="skyhaxe"',
    'main="HabboTextIntegrationTest" path="build/font-tests" file="font-tests"')
$project = $project.Replace('<source path="client" />', '<source path="client" /><source path="test" />')
[IO.File]::WriteAllText($temporary, $project, [Text.UTF8Encoding]::new($false))
Push-Location $repo
try {
    & node scripts/build-habbo-text.mjs
    if ($LASTEXITCODE -ne 0) { throw 'Font resource verification failed' }
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & haxelib run openfl build $temporary html5 -debug }
    finally { $ErrorActionPreference = $previous }
    if ($LASTEXITCODE -ne 0) { throw 'Font integration build failed' }
} finally { Pop-Location; Remove-Item -LiteralPath $temporary }
