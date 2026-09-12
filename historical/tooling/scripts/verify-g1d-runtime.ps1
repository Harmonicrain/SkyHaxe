[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$clientRoot = "C:\habbo\client\habbo-client-clean"
$externalVariables = "C:\habbo\ngh\gamedata\external_dev_vars.txt"
$evidencePath = Join-Path $repoRoot "evidence\g1d_runtime_verification.json"

. (Join-Path $PSScriptRoot "toolchain-env.ps1")

$clientStatusBefore = @(git -C $clientRoot status --porcelain=v1)
$variablesHashBefore = (Get-FileHash -Algorithm SHA256 -LiteralPath $externalVariables).Hash.ToLowerInvariant()

$contractOutput = & python (Join-Path $repoRoot "evidence\g1d_runtime_contract.py") 2>&1
if ($LASTEXITCODE -ne 0) {
    $contractOutput | Write-Host
    throw "G1d runtime contract generation failed with exit code $LASTEXITCODE"
}

$testOutput = & (Join-Path $PSScriptRoot "test-g1d-runtime.ps1") *>&1
$testOutput | Write-Host
$assertionMatches = @(
    $testOutput |
        Select-String -Pattern "G1D_RUNTIME_PASS assertions=([0-9]+)" -AllMatches |
        ForEach-Object { $_.Matches } |
        ForEach-Object { [int] $_.Groups[1].Value }
)
$uniqueAssertionCounts = @($assertionMatches | Select-Object -Unique)
if ($assertionMatches.Count -ne 2 -or $uniqueAssertionCounts.Count -ne 1) {
    throw "Expected matching JavaScript and interpreter runtime assertion counts"
}

$buildOutput = & (Join-Path $PSScriptRoot "build-html5.ps1") -SkipBootstrap *>&1
$buildOutput | Write-Host
$indexPath = Join-Path $repoRoot "build\html5\bin\index.html"

$clientStatusAfter = @(git -C $clientRoot status --porcelain=v1)
$variablesHashAfter = (Get-FileHash -Algorithm SHA256 -LiteralPath $externalVariables).Hash.ToLowerInvariant()
$clientStatusUnchanged = ($clientStatusBefore -join "`n") -ceq ($clientStatusAfter -join "`n")
$variablesUnchanged = $variablesHashBefore -ceq $variablesHashAfter
if (-not $clientStatusUnchanged -or -not $variablesUnchanged) {
    throw "Read-only source/client state changed during G1d runtime verification"
}

$verification = [ordered] @{
    gate = "G1d-component-runtime-primitives"
    verified_utc = [DateTime]::UtcNow.ToString("o")
    status = "pass"
    targets = [ordered] @{
        javascript = [ordered] @{ assertions = $assertionMatches[0]; pass_marker = $true }
        interpreter = [ordered] @{ assertions = $assertionMatches[1]; pass_marker = $true }
        openfl_html5 = [ordered] @{
            built = (Test-Path -LiteralPath $indexPath -PathType Leaf)
            index_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $indexPath).Hash.ToLowerInvariant()
        }
    }
    read_only_checks = [ordered] @{
        clean_client_git_status_unchanged = $clientStatusUnchanged
        clean_client_status_entries = $clientStatusAfter.Count
        external_dev_vars_sha256_before = $variablesHashBefore
        external_dev_vars_sha256_after = $variablesHashAfter
        external_dev_vars_unchanged = $variablesUnchanged
    }
    commands = @(
        "python evidence/g1d_runtime_contract.py",
        "scripts/test-g1d-runtime.ps1",
        "scripts/build-html5.ps1 -SkipBootstrap"
    )
}

# Windows PowerShell 5.1 cannot bind -Encoding utf8NoBOM; this writer is version-independent
[System.IO.File]::WriteAllText($evidencePath, ($verification | ConvertTo-Json -Depth 8), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $evidencePath"
