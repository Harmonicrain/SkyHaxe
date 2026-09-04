[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$airHome = "C:\harman-air\AIRSDK_51.2.2"
$compiler = Join-Path $airHome "bin\mxmlc.bat"
$outputDir = Join-Path $repoRoot "build\tests\g3-flash-reference"
$capture = Join-Path $outputDir "flash-result.json"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot "flash-reference\g3-application.xml") `
    -Destination (Join-Path $outputDir "application.xml") -Force
if (Test-Path -LiteralPath $capture) { Remove-Item -LiteralPath $capture -Force }

& $compiler `
    "-source-path+=$(Join-Path $repoRoot 'flash-reference')" `
    "-source-path+=C:\habbo\client\habbo-client-clean\src" `
    "-external-library-path+=$(Join-Path $airHome 'frameworks\libs\air\airglobal.swc')" `
    "-target-player=25.0" "-debug=true" `
    "-output=$(Join-Path $outputDir 'G3XmlReference.swf')" `
    "$(Join-Path $repoRoot 'flash-reference\G3XmlReference.as')"
if ($LASTEXITCODE -ne 0) { throw "G3 Flash reference compile failed: $LASTEXITCODE" }

$server = Start-Process -FilePath "python" `
    -ArgumentList @("scripts/serve-g3.py", "--port", "8773", "--capture-output", $capture) `
    -WorkingDirectory $repoRoot -WindowStyle Hidden -PassThru
try {
    $ready = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        try {
            if ((Invoke-WebRequest "http://127.0.0.1:8773/fixtures/g3_xml_blob_contract.json" `
                -UseBasicParsing -TimeoutSec 1).StatusCode -eq 200) { $ready = $true; break }
        } catch {}
        Start-Sleep -Milliseconds 100
    }
    if (-not $ready) { throw "G3 capture server did not become ready" }
    & (Join-Path $airHome "bin\adl.exe") -nodebug (Join-Path $outputDir "application.xml") $outputDir
    if (-not (Test-Path -LiteralPath $capture -PathType Leaf)) { throw "AIR did not POST G3 capture" }
}
finally {
    if ($server -and -not $server.HasExited) { Stop-Process -Id $server.Id -Force }
}
& python evidence/g3_flash_reference_compare.py $capture
if ($LASTEXITCODE -ne 0) { throw "G3 AIR comparison failed: $LASTEXITCODE" }
