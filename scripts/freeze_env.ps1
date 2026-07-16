# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


# 1. 徹底關閉 Windows Update 服務
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Set-Service -Name wuauserv -StartupType Disabled


# 2. 關閉 Update Orchestrator 服務 (防止自動恢復)
Stop-Service -Name UsoSvc -Force -ErrorAction SilentlyContinue
Set-Service -Name UsoSvc -StartupType Disabled


# 3. 停用相關的排程工作 (這是自動喚醒重啟的元兇)
$tasks = @(
    "\Microsoft\Windows\WindowsUpdate\Automatic App Update",
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
)
foreach ($task in $tasks) {
    if (Get-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue) {
        Disable-ScheduledTask -TaskPath $task
    }
}


Write-Host "生產環境已深度凍結：更新服務與排程工作已停用。" -ForegroundColor Green