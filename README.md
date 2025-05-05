# wpad-proxy-config

A lightweight PowerShell toolkit to automatically configure Git (and optionally Gradle) proxy settings on Windows using WPAD/PAC.

## 🔍 Features

- Reads PAC URL from the Windows registry
- Downloads and parses PAC file using PowerShell (supports `var xyz = "PROXY ..."` and `return xyz`)
- Simulates a simplified `FindProxyForURL()` to extract proxy
- Automatically sets Git proxy settings (`http.proxy` / `https.proxy`)
- Includes test and reset helpers
- Optional debug output
- No dependencies: **no Node.js**, **no WSH**, **no admin rights**

## ⚙️ Usage

### 1. Configure Git proxy:

```powershell
.\configure-git-proxy.ps1
```

Optional: enable debug mode by setting at the top of the script:

```powershell
$DebugEnabled = $true
```

### 2. Test connectivity to GitHub:

```powershell
.	est-git-proxy.ps1
```

### 3. Reset Git proxy settings:

```powershell
.eset-git-proxy.ps1
```

## 📂 File overview

| File                     | Description |
|--------------------------|-------------|
| `get-wpad-url.ps1`       | Reads PAC URL from Windows registry (`AutoConfigURL`) |
| `parse-pac.ps1`          | Downloads and parses the PAC file, extracts the proxy |
| `configure-git-proxy.ps1`| Main entry: combines everything to configure Git proxy |
| `reset-git-proxy.ps1`    | Clears Git proxy settings |
| `test-git-proxy.ps1`     | Tests GitHub connectivity using current Git proxy |

## 📦 Requirements

- Windows
- PowerShell 5.1 or later
- Git must be installed and on PATH

## ✅ Example output

```
[INFO] Using PAC from http://wpad.company.local/wpad.dat
[INFO] Setting Git proxy to http://proxy.company.local:3128
[SUCCESS] Git proxy configured successfully.
```
