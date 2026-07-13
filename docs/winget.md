## *⭐ Winget ⭐*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

<br>

### *⭐ 允許 PowerShell 執行腳本*
> #### *最小權限原則 ➔ 當前用戶*
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```
  
<br>

### *A.　⭐ 安裝 Winget*
```powershell
# 1. 下載微軟官方最新穩定版 winget 套件 (App Installer) 及其相容核心
$URL_Winget = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$URL_VCLibs = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"

Write-Host "正在下載 Winget 安裝包..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $URL_VCLibs -OutFile "$env:TEMP\VCLibs.appx"
Invoke-WebRequest -Uri $URL_Winget -OutFile "$env:TEMP\Winget.msixbundle"

# 2. 強制安裝相依套件與 Winget ( 可能非必要 )
Write-Host "正在安裝/修復 Winget..." -ForegroundColor Cyan
Add-AppxPackage -Path "$env:TEMP\VCLibs.appx" -ErrorAction SilentlyContinue
Add-AppxPackage -Path "$env:TEMP\Winget.msixbundle"

# 3. 測試是否安裝成功並初始化
Write-Host "檢查安裝結果：" -ForegroundColor Green
winget --version

# 4. 清理暫存檔
Remove-Item "$env:TEMP\VCLibs.appx" -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\Winget.msixbundle" -ErrorAction SilentlyContinue
```

<br>

### *B.　[查找 Winget 支援應用](https://winstall.app/)*
```
[1] 將系統所需應用 依照官方網站 搜尋對應名稱 ( 軟體 id )
[2-1] 填入 ./packages/v2/admin_winget.json
[2-2] 填入 ./packages/v2/user_winget.json
```

<br>

### *C.　⭐ 一鍵安裝應用*
```powershell
# Admin
winget import -i packages/v2/admin_winget.json --accept-package-agreements --accept-source-agreements

# User ( 指令會自動偵測 + 補齊未繼承 admin 應用 )
winget import -i packages/v2/admin_winget.json --accept-package-agreements --accept-source-agreements
winget import -i packages/v2/user_winget.json --accept-package-agreements --accept-source-agreements
```

<br>

### *D.　其他*
```powershell
# 啟用跳過 Hash 的功能開關
    - 1. 啟用功能
    winget settings --enable InstallerHashOverride
    - 2. 再次嘗試安裝 (ex: Logitech.GHUB)
    winget install Logitech.GHUB --ignore-security-hash
    

# 部分應用不需要管理員權限 所以噴錯
winget install Canonical.Ubuntu.2404 --scope user
winget install Microsoft.VisualStudioCode --scope user
winget install thomasnordquist.MQTT-Explorer --scope user
winget install GeekUninstaller.GeekUninstaller --scope user
winget install PixPin.PixPin --scope machine
winget install Rufus.Rufus --scope user
winget install liule.Snipaste --scope user
winget install Microsoft.PowerToys --scope user
winget install Microsoft.Sysinternals.Suite --scope user
winget install NickeManarin.ScreenToGif --scope user
winget install xanderfrangos.twinkletray --scope user
winget install Discord.Discord --scope user
winget install Telegram.TelegramDesktop --scope user
```


<br><br>