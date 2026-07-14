# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}


# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


# 檢查 BitLocker 狀態並關閉
$status = Get-BitLockerVolume -MountPoint "C:"
if ($status.VolumeStatus -eq 'FullyEncrypted') {
    Write-Host "偵測到磁碟已加密，正在進行解密，請稍候..." -ForegroundColor Yellow
    Disable-BitLocker -MountPoint "C:"
}


Write-Host "注意： 此過程無法立即完成，需等待解密完成才可進行備份 ..." -ForegroundColor Cyan
Write-Host "可透過 manage-bde -status C: 檢查進度." -ForegroundColor Cyan