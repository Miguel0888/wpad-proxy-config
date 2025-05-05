param (
    [string]$PacUrl,
    [switch]$DebugEnabled
)

# 1. Lade PAC-Datei
try {
    $response = Invoke-WebRequest -Uri $PacUrl.Trim() -UseBasicParsing
    $bytes = $response.Content
    $pac = [System.Text.Encoding]::UTF8.GetString($bytes)
} catch {
    Write-Host "[ERROR] PAC-Datei konnte nicht geladen werden: $PacUrl"
    exit 1
}

# 2. Tokenisieren
$tokenizer = Join-Path $PSScriptRoot "pac-tokenizer.ps1"
$tokens = & $tokenizer -input $pac

# 3. Parsen
$parser = Join-Path $PSScriptRoot "pac-parser.ps1"
$ast = & $parser -tokens $tokens

# 4. Suche Return-Werte
foreach ($func in $ast | Where-Object { $_.Type -eq "Function" }) {
    foreach ($stmt in $func.Body) {
        if ($stmt.Type -eq "ReturnStatement") {
            $val = $stmt.Value -replace '"', ''
            if ($val -match "^PROXY\\s+([^:\\s]+):(\\d+)$") {
                Write-Output "$($Matches[1]):$($Matches[2])"
                return
            }
        }
    }
}

Write-Host "[ERROR] Kein gültiger Proxy gefunden."
exit 1
