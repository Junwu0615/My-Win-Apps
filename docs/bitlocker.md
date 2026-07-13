## *⭐ BitLocker ⭐*
> #### *系統管理員權限執行*

> #### *預設 3 個硬碟 C/D/E ; 密鑰放在 E 槽 ( 暫時 ➔ 存放安全位置 )*

<br>

### *A.　⭐ 操作步驟*
```powershell
[1] 確認 TPM 是否為就緒: 強烈依賴電腦硬體的 TPM ( BIOS 設定 )
tpm.msc

[2] 執行加密腳本: C + D 槽加密 
./scripts/bit_locker.ps1

[3] 重新開機 ➔ 重開機進入桌面 ➔ C 碟正式轉為加密中（ 保護開啟 ）

[4] 執行該指令 ➔ D 碟的自動解鎖就會成功啟用，以後開機進入 Windows 就不需要手動輸入 D 碟密碼
manage-bde -unlock D: -RecoveryPassword "48位元修復金鑰"
Enable-BitLockerAutoUnlock -MountPoint "D:"

[5] 查看加密進度
manage-bde -status
```

<br>

### *B.　其他*
```powershell
# 加密需要時間
  - 腳本執行完畢只代表 ➔ 開始加密程序
  - 加密過程可直接切換使用者或重啟電腦是安全的，Windows 會在背景默默把剩下的部分加密完

# 清除 C 碟所有數字密碼保護器
manage-bde -protectors -delete C: -type RecoveryPassword

# 手動刪除其他不想要的識別碼
manage-bde -protectors -delete C: -id "{???}"

# 已加密完成的碟 密鑰即不在異動 唯一所在即密鑰區 (務必妥善保管)
```

<br>

### *C.　確認加密有效性*
```
# 資料碟 ➔ 參照 A.[4]

# 系統碟
    - [再次確認] 檢視 C 碟目前的修復金鑰
    manage-bde -protectors -get C:
    
    - [驗證程序] 強制 C 碟在下次重啟時進入 BitLocker 復原模式
    manage-bde -forcerecovery C:
```

<br>

### *D.　外接硬碟加密*
```
Coming soon
```

<br><br>