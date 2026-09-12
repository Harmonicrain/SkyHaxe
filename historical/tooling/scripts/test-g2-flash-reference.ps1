[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$airHome = "C:\harman-air\AIRSDK_51.2.2"
$flex = Join-Path $airHome "bin\mxmlc.bat"
$outputDir = Join-Path $repoRoot "build\tests\g2-flash-reference"
$outputSwf = Join-Path $outputDir "G2FlashReference.swf"
$log = Join-Path $outputDir "flash-reference.log"
$capture = Join-Path $outputDir "flash-result.json"

if (-not (Test-Path -LiteralPath $flex -PathType Leaf)) { throw "Flex compiler missing: $flex" }
if (-not (Test-Path -LiteralPath (Join-Path $airHome "bin\adl.exe") -PathType Leaf)) { throw "AIR ADL missing: $airHome" }
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot "flash-reference\application.xml") -Destination $outputDir -Force
if (Test-Path -LiteralPath $capture) { Remove-Item -LiteralPath $capture -Force }
$requestLog = [IO.Path]::ChangeExtension($capture, ".requests.log")
if (Test-Path -LiteralPath $requestLog) { Remove-Item -LiteralPath $requestLog -Force }

& $flex `
    "-source-path+=$(Join-Path $repoRoot 'flash-reference')" `
    "-source-path+=C:\habbo\client\habbo-client-clean\src" `
    "-external-library-path+=$(Join-Path $airHome 'frameworks\libs\air\airglobal.swc')" `
    "-target-player=25.0" `
    "-debug=true" `
    "-output=$outputSwf" `
    "$(Join-Path $repoRoot 'flash-reference\G2FlashReference.as')"
if ($LASTEXITCODE -ne 0) { throw "Flash reference compile failed with exit code $LASTEXITCODE" }

$server = Start-Process -FilePath "python" `
    -ArgumentList @("scripts/serve-g2.py", "--port", "8770", "--capture-output", $capture) `
    -WorkingDirectory $repoRoot -WindowStyle Hidden -PassThru
try {
    $ready = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri "http://127.0.0.1:8770/fixtures/g2_reader_contract.json" -UseBasicParsing -TimeoutSec 1
            if ($response.StatusCode -eq 200) { $ready = $true; break }
        } catch {}
        Start-Sleep -Milliseconds 100
    }
    if (-not $ready) { throw "Flash reference HTTP server did not become ready" }
    $output = & (Join-Path $airHome "bin\adl.exe") -nodebug (Join-Path $outputDir "application.xml") $outputDir 2>&1
    $output | Tee-Object -FilePath $log | Write-Host
    if (-not (Test-Path -LiteralPath $capture -PathType Leaf)) {
        throw "Flash reference runtime did not POST its capture"
    }
}
finally {
    if ($server -and -not $server.HasExited) { Stop-Process -Id $server.Id -Force }
}
& python (Join-Path $repoRoot "evidence\g2_flash_reference_compare.py") $capture
if ($LASTEXITCODE -ne 0) { throw "Flash reference comparison failed with exit code $LASTEXITCODE" }
