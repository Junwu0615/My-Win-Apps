# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force

# 1. 檢查並安裝 Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "正在安裝 Chocolatey..." -ForegroundColor Yellow
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2. 根據 packages.config 自動安裝所有軟體
Write-Host "正在依據 packages.config 安裝應用程式..." -ForegroundColor Cyan
choco install packages.config -y

$configPathDir = "../packages/packages.config"
$configPath = Join-Path -Path $PSScriptRoot -ChildPath $configPathDir
if (Test-Path $configPath) {
    choco install $configPath -y
} else {
    Write-Error "找不到 $($configPathDir)，請確認檔案位置！"
}

# TODO 3. 同步設定檔
# Write-Host "同步設定檔..." -ForegroundColor Green
# $sourceConfig = "$PSScriptRoot\configs\vscode\settings.json"
# $destConfig = "$env:APPDATA\Code\User\settings.json"
#
# if (Test-Path $sourceConfig) {
#     Copy-Item $sourceConfig -Destination $destConfig -Force
# }

Write-Host "部署完成！ 請重新啟動電腦 ..." -ForegroundColor Cyan