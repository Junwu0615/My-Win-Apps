# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "[1] 正在安裝 Chocolatey ..." -ForegroundColor Cyan
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # 重新整理系統環境變數，確保當前視窗能立刻抓到 choco 指令
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    # 強制重載環境變數防賴皮
    if (Get-Command Update-SessionEnvironment -ErrorAction SilentlyContinue) { Update-SessionEnvironment }
}

# 再次確認 choco 是否真的就緒
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Error "Chocolatey 安裝失敗或環境變數未生效，請以系統管理員身分重新執行！"
    exit 1
}


Write-Host "[2] 正在依據 admin.config 安裝應用程式 ..." -ForegroundColor Cyan
$configDir = "../packages/v1/admin.config"
$configPath = Join-Path -Path $PSScriptRoot -ChildPath $configDir
if (Test-Path $configPath) {
    # 自動同意 + 忽略校驗錯誤
    choco install "$configPath" -y --ignore-checksums
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Chocolatey 安裝過程發生錯誤，請檢查網路或套件名稱。"
        exit 1
    }
} else {
    Write-Error "找不到 $configDir 請確認檔案位置！"
    exit 1
}


Write-Host "[3] 驗證安裝狀態 ..." -ForegroundColor Cyan
# 取得 config 中的所有 ID
$required = Get-Content $configPath | Select-String 'id="([^"]+)"' | ForEach-Object { $_.Matches.Groups[1].Value }

# 取得已安裝清單的目錄 (Chocolatey 實際安裝的套件)
$chocoLibDir = "C:\ProgramData\chocolatey\lib"
if (Test-Path $chocoLibDir) {
    $installedPackages = Get-ChildItem -Path $chocoLibDir | Select-Object -ExpandProperty Name

    foreach ($app in $required) {
        # 使用 -match (正則比對) 防範極端字元
        if ($installedPackages -match $app) {
            Write-Host "[ OK ] $app 已安裝" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] $app 未找到" -ForegroundColor Red
        }
    }
} else {
    Write-Host "[WARN] 找不到 Chocolatey 的 lib 目錄，無法進行本地驗證。" -ForegroundColor Yellow
}


Write-Host "[4] 所有應用更新至最新版 ..." -ForegroundColor Cyan
# 自動同意 + 忽略校驗錯誤 + 跳過內部慢速搜尋
choco upgrade all -y --ignore-checksums --skip-automated-searches


Write-Host "[5] 同步設定檔至系統預設範本 ( 未來所有新用戶將繼承 ) ..." -ForegroundColor Cyan
$sourceConfig = "$PSScriptRoot\configs\vscode\settings.json"

# 指向 Windows 的 Default 範本目錄
$defaultAppData = "C:\Users\Default\AppData\Roaming"
$destConfig = "$defaultAppData\Code\User\settings.json"

if (Test-Path $sourceConfig) {
    # 確保目標資料夾存在
    $destDir = Split-Path $destConfig
    if (!(Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Copy-Item $sourceConfig -Destination $destConfig -Force
    Write-Host "[ OK ] 已將 VS Code 設定檔寫入 Default 範本" -ForegroundColor Green
}


Write-Host "[6] 部署完成！ 請重新啟動電腦 ..." -ForegroundColor Cyan