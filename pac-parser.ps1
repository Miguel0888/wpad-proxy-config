param([array]$tokens)

$index = 0

function CurrentToken {
    if ($index -lt $tokens.Count) {
        return $tokens[$index]
    }
    return $null
}

function ConsumeToken {
    $index++
}

function Expect($type) {
    $token = CurrentToken
    if ($token.Type -ne $type) {
        throw "Expected $type but got $($token.Type)"
    }
    ConsumeToken
    return $token
}

function ParseVarDeclaration {
    Expect "KEYWORD" # var
    $id = Expect "IDENTIFIER"
    Expect "OPERATOR" # =
    $value = Expect "STRING"
    Expect "OPERATOR" # ;
    return [PSCustomObject]@{
        Type = "VarDeclaration"
        Name = $id.Value
        Value = $value.Value
    }
}

function ParseReturnStatement {
    Expect "KEYWORD" # return
    $token = CurrentToken
    if ($token.Type -eq "IDENTIFIER") {
        $expr = $token.Value
        ConsumeToken
    } elseif ($token.Type -eq "STRING") {
        $expr = $token.Value
        ConsumeToken
    } else {
        throw "Unexpected token in return: $($token.Type)"
    }
    Expect "OPERATOR" # ;
    return [PSCustomObject]@{
        Type = "ReturnStatement"
        Value = $expr
    }
}

function ParseIfStatement {
    Expect "KEYWORD" # if
    Expect "OPERATOR" # (
    # ignore condition
    while (CurrentToken.Value -ne ")") { ConsumeToken }
    Expect "OPERATOR" # )
    Expect "OPERATOR" # {
    $stmt = ParseReturnStatement
    Expect "OPERATOR" # }
    return [PSCustomObject]@{
        Type = "IfStatement"
        Body = $stmt
    }
}

function ParseFunction {
    Expect "KEYWORD" # function
    Expect "IDENTIFIER"
    Expect "OPERATOR" # (
    while (CurrentToken.Value -ne ")") { ConsumeToken }
    Expect "OPERATOR" # )
    Expect "OPERATOR" # {
    $body = @()
    while (CurrentToken.Value -ne "}") {
        $token = CurrentToken
        if ($token.Type -eq "KEYWORD" -and $token.Value -eq "return") {
            $body += ParseReturnStatement
        } elseif ($token.Type -eq "KEYWORD" -and $token.Value -eq "if") {
            $body += ParseIfStatement
        } else {
            ConsumeToken
        }
    }
    Expect "OPERATOR" # }
    return [PSCustomObject]@{
        Type = "Function"
        Body = $body
    }
}

function ParseScript {
    $ast = @()
    while ($index -lt $tokens.Count) {
        $token = CurrentToken
        if ($token.Type -eq "KEYWORD" -and $token.Value -eq "var") {
            $ast += ParseVarDeclaration
        } elseif ($token.Type -eq "KEYWORD" -and $token.Value -eq "function") {
            $ast += ParseFunction
        } else {
            ConsumeToken
        }
    }
    return $ast
}

return ParseScript
