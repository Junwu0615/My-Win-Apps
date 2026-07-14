# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

Write-Host "開始系統最佳化與瘦身作業 ..." -ForegroundColor Cyan


# 1. 停止 Windows Update 服務並清理暫存
Write-Host "[1] 清理更新暫存 ..." -ForegroundColor Yellow
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv
Start-Service -Name bits

# 2. 關閉休眠 (釋放磁碟空間)
# Write-Host "[2] 停用休眠功能 ..." -ForegroundColor Yellow
# powercfg -h off


# 3. 啟用 CompactOS (強制壓縮)
Write-Host "[3] 正在執行系統檔案壓縮 (CompactOS) ..." -ForegroundColor Yellow
compact /compactos:always


# 4. 清理系統與使用者暫存檔
Write-Host "[4] 清理暫存檔案 ..." -ForegroundColor Yellow
$tempPaths = @("$env:windir\Temp\*", "$env:TEMP\*")
foreach ($path in $tempPaths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}


Write-Host "瘦身與最佳化完成！系統現在已準備好進行鏡像備份." -ForegroundColor Green