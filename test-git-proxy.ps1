# Simple test to see if Git can access a remote repository
try {
    git ls-remote https://github.com > $null
    Write-Host "[SUCCESS] Git can access GitHub."
} catch {
    Write-Host "[ERROR] Git failed to access GitHub. Check proxy settings."
}
