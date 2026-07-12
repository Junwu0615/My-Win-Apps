# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host "[1] 正在進行硬碟加鎖 (BitLocker) ..." -ForegroundColor Cyan

# =============== 設定並檢查金鑰備份路徑 ( E 碟 ) ===============
# 注意：不要放在加密碟(C + D)，否則上鎖後如果進不去會打不開
$BackupDir = "E:\BitLocker_Keys_Backup"
if (!(Test-Path $BackupDir)) {
    try {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        Write-Host "[INFO] 已在 E 碟成功建立密鑰備份資料夾：$BackupDir" -ForegroundColor Gray
    } catch {
        Write-Error "錯誤： 無法在 E 碟建立資料夾，請確認 E 碟是否存在或是否有寫入權限！"
        exit 1
    }
} else {
    Write-Host "[SKIP] 已在 E 碟成功建立密鑰備份資料夾：$BackupDir" -ForegroundColor Yellow
}

# ==================== C 碟 (系統碟) 加密 ====================
Write-Host "[2] 正在啟用 C 碟 BitLocker..." -ForegroundColor Yellow
$C_Drive = Get-BitLockerVolume -MountPoint "C:"

if ($C_Drive.VolumeStatus -eq "FullyDecrypted") {
    try {
        # 明確為 C 碟手動新增一個修復金鑰保護器
        Write-Host "正在為 C 碟新增修復金鑰保護器..." -ForegroundColor Gray
        $AddProtectorResult = manage-bde -protectors -add C: -RecoveryPassword | Out-Null

        # 啟動加密（修正為 xts_aes128）
        Write-Host "正在啟動 C 碟 BitLocker 加密..." -ForegroundColor Gray
        manage-bde -on C: -UsedSpaceOnly -EncryptionMethod xts_aes128 | Out-Null

        Write-Host "等待系統同步寫入修復金鑰 ..." -ForegroundColor Gray
        Start-Sleep -Seconds 5

        # 撈取 C 碟所有的文字型金鑰保護器
        $BdeStatus = manage-bde -protectors -get C: -type RecoveryPassword

        if ($BdeStatus -match "\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}") {
            $BdeStatus | Out-File "$BackupDir\BitLocker_C_RecoveryKey.txt" -Force
            Write-Host "[ OK ] C 碟已引導加密，修復金鑰已成功導出至 $BackupDir" -ForegroundColor Green
        } else {
            Write-Warning "偵測到的回應內容：`n$BdeStatus"
            throw "系統已開啟加密，但經由底層工具仍無法讀取到 48 位數的修復金鑰，請確認 TPM 狀態"
        }
    } catch {
        Write-Error "C 碟加密失敗，原因: $_"
        exit 1
    }
} else {
    Write-Host "[SKIP] C 碟已經處於加密狀態或正在加密中" -ForegroundColor Yellow
}

# ==================== D 碟 (資料碟) 加密 ====================
Write-Host "[3] 正在啟用 D 碟 BitLocker..." -ForegroundColor Yellow
$D_Drive = Get-BitLockerVolume -MountPoint "D:" -ErrorAction SilentlyContinue

if ($null -ne $D_Drive) {
    if ($D_Drive.VolumeStatus -eq "FullyDecrypted") {
        try {
            # 比照 C 碟，先手動為 D 碟新增修復金鑰保護器
            Write-Host "正在為 D 碟新增修復金鑰保護器..." -ForegroundColor Gray
            manage-bde -protectors -add D: -RecoveryPassword | Out-Null

            # 用修正後的加密方法啟用 D 碟加密
            Write-Host "正在啟動 D 碟 BitLocker 加密..." -ForegroundColor Gray
            manage-bde -on D: -UsedSpaceOnly -EncryptionMethod xts_aes128 | Out-Null

            Write-Host "等待系統同步寫入修復金鑰 ..." -ForegroundColor Gray
            Start-Sleep -Seconds 5

            # 撈取 D 碟金鑰保護器
            $D_BdeStatus = manage-bde -protectors -get D: -type RecoveryPassword

            if ($D_BdeStatus -match "\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}") {
                # 匯出金鑰到 E 碟備份
                $D_BdeStatus | Out-File "$BackupDir\BitLocker_D_RecoveryKey.txt" -Force
                Write-Host "[ OK ] D 碟已啟動加密，修復金鑰已成功導出至 $BackupDir" -ForegroundColor Green
            } else {
                throw "成功引導加密，但未能讀取到 D 碟金鑰檔案文字"
            }
        } catch {
            Write-Error "D 碟加密失敗，原因: $_"
            exit 1
        }
    } else {
        Write-Host "[SKIP] D 碟已經處於加密狀態或正在加密中，確保金鑰是否有備份" -ForegroundColor Yellow
        $D_BdeStatus = manage-bde -protectors -get D: -type RecoveryPassword
        if ($D_BdeStatus -match "\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}") {
            $D_BdeStatus | Out-File "$BackupDir\BitLocker_D_RecoveryKey.txt" -Force
        }
        Write-Host "[SKIP] D 碟已經處於加密狀態（金鑰已確認備份）" -ForegroundColor Yellow
    }
} else {
    Write-Host "[FAIL] 找不到 D 碟，請確認磁碟代號是否正確！" -ForegroundColor Red
    exit 1
}


Write-Host "[4] 階段一完成！ C + D 硬碟已安全引導加密！" -ForegroundColor Green
Write-Host "🔑 修復密鑰已安全放置在：$BackupDir" -ForegroundColor Cyan
Write-Host "⚠️  請務必在重開機前，將該資料夾複製到外部隨身碟或手機保管！" -ForegroundColor Magenta
Write-Host "--------------------------------------------------------" -ForegroundColor Gray
Write-Host "💡 接下來請繼續完成 README 步驟 ([3]、[4]、[5])" -ForegroundColor Yellow
Write-Host "README [1] 請立即重新開機以通過 C 碟硬體測試。" -ForegroundColor Yellow
Write-Host "README [2] 進入桌面後，以管理員身分執行： Enable-BitLockerAutoUnlock -MountPoint 'D:'" -ForegroundColor Yellow
Write-Host "README [3] 輸入 manage-bde -status 查看進度" -ForegroundColor Yellow