# wpad-proxy-config

A lightweight PowerShell toolkit to automatically configure Git and Gradle proxy settings on Windows using WPAD/PAC.

## 🔍 Features

- Reads PAC URL from the Windows registry
- Downloads and parses PAC file using PowerShell (supports `var xyz = "PROXY ..."` and `return xyz`)
- Sets Git proxy settings (`http.proxy` / `https.proxy`) automatically
- Optional debug output
- No dependencies: **no Node.js**, **no WSH**, **no admin rights**

## ⚙️ Usage

### Configure Git proxy:

```powershell
.\configure-git-proxy.ps1
```

### With optional debug output:

Edit `configure-git-proxy.ps1`:

```powershell
$DebugEnabled = $true
```

Then run as usual.

### Reset Git proxy:

```powershell
.eset-git-proxy.ps1
```

## 📂 File overview

| File                     | Description |
|--------------------------|-------------|
| `get-wpad-url.ps1`       | Reads PAC URL from registry (`AutoConfigURL`) |
| `parse-pac.ps1`          | Parses the PAC file and extracts proxy |
| `configure-git-proxy.ps1`| Sets Git proxy based on PAC |
| `reset-git-proxy.ps1`    | Unsets any Git proxy settings |
| `test-git-proxy.ps1`     | (optional) Tests Git connectivity via current proxy |

## 📦 Requirements

- Windows
- PowerShell 5.1 or later
- Git must be installed and on PATH

## ✅ Example output

```
[INFO] Using PAC from http://wpad.company.local/wpad.dat
[INFO] Set Git-Proxy to http://proxy.company.local:3128
[SUCCESS] Git proxy successfully configured.
```
