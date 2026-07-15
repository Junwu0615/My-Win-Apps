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

# 2. 強制安裝相依套件與 Winget (可能非必要)
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
[1] 將系統所需應用 依照官方網站 搜尋對應名稱 (軟體 id)
[2-1] 填入 ./packages/v2/admin_winget.json
[2-2] 填入 ./packages/v2/user_winget.json
```

<br>

### *C.　⭐ 一鍵安裝應用*
```powershell
# Admin
winget import -i packages/v2/admin_winget.json --accept-package-agreements --accept-source-agreements --disable-interactivity

# User ( 指令會自動偵測 + 補齊未繼承 admin 應用 )
winget import -i packages/v2/admin_winget.json --accept-package-agreements --accept-source-agreements --disable-interactivity
winget import -i packages/v2/user_winget.json --accept-package-agreements --accept-source-agreements --disable-interactivity
```

<br>

### *D.　其他*
```powershell
⭐ 清理快取
    # 開啟 winget 的暫存日誌與快取目錄
    ( 將該資料夾內的所有日誌檔與 Downloads 資料夾內的快取安裝包直接全選刪除 )
      winget --logs
    
    # 清除個別軟體安裝時的殘留
      - 清除當前使用者暫存快取
      Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    
      - 清除系統全域暫存快取（必須是系統管理員權限）
      Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
      
    # 以管理員身分在背景自動執行最深度的磁碟清理
      cleanmgr /sagerun:1
    

# 啟用跳過 Hash 的功能開關
    - 1. 啟用功能
    winget settings --enable InstallerHashOverride
    - 2. 再次嘗試安裝 (ex: Logitech.GHUB)
    winget install Logitech.GHUB -e --ignore-security-hash


:: -e 精準搜索 (不加上會模糊搜尋)
:: --scope machine (強制全機安裝以確保權限)
:: --scope user (侷限當前使用者)


# 1. 系統/核心與開發工具
winget install Canonical.Ubuntu.2404 -e --scope machine
winget install Microsoft.VisualStudioCode -e --scope machine
winget install Microsoft.PowerToys -e --scope machine
winget install Microsoft.Sysinternals.Suite -e --scope machine

# 2. 系統維護與實用工具
winget install GeekUninstaller.GeekUninstaller -e --scope machine
winget install Rufus.Rufus -e --scope machine
winget install thomasnordquist.MQTT-Explorer -e --scope machine
winget install NickeManarin.ScreenToGif -e --scope machine
winget install xanderfrangos.twinkletray -e --scope machine

# 3. 截圖與影音工具
winget install PixPin.PixPin -e --scope machine
winget install ErrorFlynn.ytdlp-interface -e
winget install ffmpeg -e --scope machine
# winget install liule.Snipaste -e --scope machine

# 4. 通訊軟體
winget install Discord.Discord -e --scope user
winget install Telegram.TelegramDesktop -e --scope user
```


<br><br>