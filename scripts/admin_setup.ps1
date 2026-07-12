# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "[1] 正在安裝 Chocolatey..." -ForegroundColor Cyan
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}


Write-Host "[2] 正在依據 packages.config 安裝應用程式..." -ForegroundColor Cyan
$configDir = "../packages/admin.config"
$configPath = Join-Path -Path $PSScriptRoot -ChildPath $configDir
if (Test-Path $configPath) {
    choco install $configPath -y
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Chocolatey 安裝過程發生錯誤，請檢查網路或套件名稱。"
        exit 1
    }
} else {
    Write-Error "找不到 $configDir 請確認檔案位置！"
    exit 1
}


Write-Host "[3] 驗證安裝狀態" -ForegroundColor Cyan
# 取得 config 中的所有 ID
$required = Get-Content $configPath | Select-String 'id="([^"]+)"' | ForEach-Object { $_.Matches.Groups[1].Value }

# 取得已安裝清單的目錄 (Chocolatey 實際安裝的套件)
$chocoLibDir = "C:\ProgramData\chocolatey\lib"
$installedPackages = Get-ChildItem -Path $chocoLibDir | Select-Object -ExpandProperty Name

foreach ($app in $required) {
    # 檢查目錄名稱是否包含該 ID (不分大小寫)
    if ($installedPackages -ilike "*$app*") {
        Write-Host "[ OK ] $app 已安裝" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $app 未找到" -ForegroundColor Red
    }
}


# Write-Host "[4] 同步設定檔..." -ForegroundColor Cyan
# $sourceConfig = "$PSScriptRoot\configs\vscode\settings.json"
# $destConfig = "$env:APPDATA\Code\User\settings.json"
#
# if (Test-Path $sourceConfig) {
#     Copy-Item $sourceConfig -Destination $destConfig -Force
# }


Write-Host "[5] 部署完成！ 請重新啟動電腦 ..." -ForegroundColor Cyan