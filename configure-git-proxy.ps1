$DebugEnabled = $false  # Set to $true to show PAC content

$wpadScript = Join-Path $PSScriptRoot "get-wpad-url.ps1"
if (-not (Test-Path $wpadScript)) {
    Write-Host "[ERROR] get-wpad-url.ps1 not found."
    exit 1
}

$pacUrl = & $wpadScript
if (-not $pacUrl) {
    Write-Host "[ERROR] No PAC URL found."
    exit 1
}

try {
    $response = Invoke-WebRequest -Uri $pacUrl.Trim() -UseBasicParsing
    $bytes = $response.Content
    $pacContent = [System.Text.Encoding]::UTF8.GetString($bytes)

    if ($DebugEnabled) {
        Write-Host "`n========== PAC File (Debug Output) ==========" -ForegroundColor Cyan
        Write-Output $pacContent
        Write-Host "===============================================`n"
    }
} catch {
    Write-Host "[ERROR] Could not load PAC file: $pacUrl"
    exit 1
}

$parserScript = Join-Path $PSScriptRoot "parse-pac.ps1"
if (-not (Test-Path $parserScript)) {
    Write-Host "[ERROR] parse-pac.ps1 not found."
    exit 1
}

$proxyHostPort = & $parserScript -PacUrl $pacUrl -DebugEnabled:$DebugEnabled

if (-not $proxyHostPort -or $proxyHostPort -notmatch ':') {
    Write-Host "[ERROR] Failed to extract proxy from PAC."
    exit 1
}

$parts = $proxyHostPort -split ':'
$proxyHost = $parts[0]
$proxyPort = $parts[1]

Write-Host "[INFO] Setting Git proxy to http://${proxyHost}:${proxyPort}"
git config --global http.proxy "http://${proxyHost}:${proxyPort}"
git config --global https.proxy "http://${proxyHost}:${proxyPort}"

Write-Host "[SUCCESS] Git proxy configured successfully."
