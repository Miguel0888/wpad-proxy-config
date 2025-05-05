param (
    [string]$PacUrl,
    [switch]$DebugEnabled
)

# Download PAC file
try {
    $response = Invoke-WebRequest -Uri $PacUrl.Trim() -UseBasicParsing
    $bytes = $response.Content
    $pacContent = [System.Text.Encoding]::UTF8.GetString($bytes)
} catch {
    Write-Host "[ERROR] PAC file could not be loaded: $PacUrl"
    exit 1
}

if ($DebugEnabled) {
    Write-Host "`n[PARSER] Raw PAC content:"
    Write-Output $pacContent
    Write-Host "----------"
}

# Extract proxy variable definitions
$proxyVars = @{}
$pacContent -split "`n" | ForEach-Object {
    $line = $_.Trim()
    if ($line -match 'var\s+(\w+)\s*=\s*"PROXY\s+([^"\s:]+):(\d+)"') {
        $proxyVars[$Matches[1]] = "${Matches[2]}:${Matches[3]}"
    }
}

if ($proxyVars.Count -eq 0) {
    Write-Host "[ERROR] No proxy definitions found."
    exit 1
}

# Simulate FindProxyForURL()
$pacContent -join "`n" -match 'function\s+FindProxyForURL\s*\([^)]*\)\s*\{([^}]+)\}' | Out-Null
$functionBody = $Matches[1] -split "`n"

foreach ($line in $functionBody) {
    $clean = $line.Trim()
    if ($clean -match 'return\s+"PROXY\s+([^"\s:]+):(\d+)"') {
        $host = $Matches[1]
        $port = $Matches[2]
        Write-Output "${host}:${port}"
        return
    }
    if ($clean -match 'return\s+(\w+);') {
        $var = $Matches[1]
        if ($proxyVars.ContainsKey($var)) {
            Write-Output $proxyVars[$var]
            return
        }
    }
}

Write-Host "[ERROR] No usable return statement found."
exit 1
