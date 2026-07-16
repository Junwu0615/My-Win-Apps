# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


# 1. 恢復 Windows Update 服務
Set-Service -Name wuauserv -StartupType Manual
Start-Service -Name wuauserv


# 2. 恢復 Update Orchestrator 服務
Set-Service -Name UsoSvc -StartupType Manual
Start-Service -Name UsoSvc


# 3. 恢復相關排程工作
$tasks = @(
    "\Microsoft\Windows\WindowsUpdate\Automatic App Update",
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
)
foreach ($task in $tasks) {
    Enable-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue
}


Write-Host "系統已解凍，現在可以手動前往設定執行更新。" -ForegroundColor Yellow