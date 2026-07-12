# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host "正在進行硬碟加鎖 (BitLocker) ..." -ForegroundColor Cyan

# 1. 設定修復金鑰備份路徑 ( 建議放到 USB 或 Admin 專屬的備份資料夾 )
# 注意：不要放在加密碟(C + D)，否則上鎖後如果進不去會打不開
$BackupDir = "E:\BitLocker_Keys_Backup"
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }

# ==================== C 碟 (系統碟) 加密 ====================
Write-Host "-> 正在啟用 C 碟 BitLocker..." -ForegroundColor Yellow
$C_Drive = Get-BitLockerVolume -MountPoint "C:"

if ($C_Drive.VolumeStatus -eq "FullyDecrypted") {
    # 這裡使用 TPM 晶片配合隨機修復金鑰加密（最標準的 Windows 自動化作法）
    # 如果電腦沒有 TPM，需要額外允許「無相容 TPM 時啟用 BitLocker」的群組原則
    Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes128 -UsedSpaceOnly -TpmAndBackupKeyProtector > $null

    # 匯出修復金鑰檔案
    $Key = (Get-BitLockerVolume -MountPoint "C:").KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
    Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $Key.KeyProtectorId > $null

    # 將金鑰明文存成文字檔備份
    $Key.RecoveryPassword | Out-File "$BackupDir\BitLocker_C_RecoveryKey.txt"
    Write-Host "[ OK ] C 碟已啟動加密，修復金鑰已備份至 $BackupDir" -ForegroundColor Green
} else {
    Write-Host "[ SKIP ] C 碟已經處於加密狀態或正在加密中。" -ForegroundColor Yellow
}

# ==================== D 碟 (資料碟) 加密 ====================
Write-Host "-> 正在啟用 D 碟 BitLocker..." -ForegroundColor Yellow
$E_Drive = Get-BitLockerVolume -MountPoint "D:" -ErrorAction SilentlyContinue

if ($null -ne $E_Drive) {
    if ($E_Drive.VolumeStatus -eq "FullyDecrypted") {
        # 使用隨機修復金鑰來加密 D 碟
        Enable-BitLocker -MountPoint "D:" -EncryptionMethod XtsAes128 -UsedSpaceOnly -PasswordProtector > $null

        # 取得並備份 D 碟修復金鑰
        $E_Key = (Get-BitLockerVolume -MountPoint "D:").KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
        $E_Key.RecoveryPassword | Out-File "$BackupDir\BitLocker_E_RecoveryKey.txt"

        # 允許這台電腦自動解鎖 D 碟
        # 這樣新 User 登入時，D 碟會自動解鎖，不需要新 User 輸入密碼
        Enable-BitLockerAutoUnlock -MountPoint "D:"

        Write-Host "[ OK ] D 碟已啟動加密，並已設定自動解鎖。" -ForegroundColor Green
    } else {
        Write-Host "[ SKIP ] D 碟已經處於加密狀態或正在加密中。" -ForegroundColor Yellow
    }
} else {
    Write-Host "[FAIL] 找不到 D 碟，請確認磁碟代號是否正確！" -ForegroundColor Red
}


Write-Host "完成 C + D 硬碟加密！ 密鑰放置在 $BackupDir 請妥善保管 ..." -ForegroundColor Cyan