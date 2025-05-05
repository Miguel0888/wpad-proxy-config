param([string]$input)

function Get-Tokens {
    $tokens = @()
    $pattern = @(
        '(?<WHITESPACE>\s+)',
        '(?<KEYWORD>\b(?:function|var|return|if)\b)',
        '(?<IDENTIFIER>[a-zA-Z_][a-zA-Z0-9_]*)',
        '(?<STRING>"[^"]*"|''[^'']*'')',
        '(?<NUMBER>\d+)',
        '(?<OPERATOR>[=;(){}])'
    ) -join '|'

    $matches = [regex]::Matches($input, $pattern)
    foreach ($match in $matches) {
        foreach ($name in $match.Groups.Keys) {
            if ($name -ne '0' -and $match.Groups[$name].Success) {
                if ($name -ne 'WHITESPACE') {
                    $tokens += [PSCustomObject]@{
                        Type = $name
                        Value = $match.Groups[$name].Value
                    }
                }
            }
        }
    }

    return $tokens
}

return Get-Tokens
