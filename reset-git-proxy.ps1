# Removes global Git proxy settings
git config --global --unset http.proxy
git config --global --unset https.proxy
Write-Host "[INFO] Git proxy settings removed."
