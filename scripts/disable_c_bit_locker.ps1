# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}


# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


# 1. 停用所有資料碟的「自動解鎖」功能 (解決 0x80310029 錯誤的關鍵)
$volumes = Get-BitLockerVolume | Where-Object { $_.MountPoint -ne "C:" -and $_.AutoUnlockEnabled -eq $true }
foreach ($vol in $volumes) {
    Write-Host "偵測到磁碟 $($vol.MountPoint) 啟用自動解鎖，正在停用 ..." -ForegroundColor Yellow
    Disable-BitLockerAutoUnlock -MountPoint $vol.MountPoint
}

# 2. 檢查 C 碟狀態並執行解密
$status = Get-BitLockerVolume -MountPoint "C:"
if ($status.VolumeStatus -eq 'FullyEncrypted') {
    Write-Host "偵測到 C 碟已加密，正在啟動解密程序 ..." -ForegroundColor Cyan

    # 使用 manage-bde -off 直接下指令，避開 PowerShell 的連鎖依賴檢查
    Start-Process -FilePath "manage-bde" -ArgumentList "-off C:" -Wait -NoNewWindow

    Write-Host "解密程序已啟動." -ForegroundColor Green
    Write-Host "請使用 'manage-bde -status C:' 檢查解密進度." -ForegroundColor Yellow
} else {
    Write-Host "C 碟目前狀態為: $($status.VolumeStatus)，無需解密." -ForegroundColor Green
}


Write-Host "注意： 此過程無法立即完成，需等待解密完成才可進行備份 ..." -ForegroundColor Cyan