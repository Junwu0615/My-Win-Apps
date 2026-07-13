## *⭐ My-Win-Apps ⭐*

<br>

### *A.　Configuration Blueprint*
<details>
<summary><b><i>　Tree </i></b></summary>
<ul>

```bash
.
├─── assets
├─── docs
│   ├─── chocolatey.md
│   └─── winget.md
│
├─── configs
│   └─── .gitkeep
│
├─── packages
│   │    ├─── v1
│   │    │    ├─── admin.config
│   │    │    └─── user.config
│   │    └─── v2
│   │         ├─── admin_winget.json
│   │         └─── user_winget.json
│   └─── user.config
│
├─── scripts
│   ├─── v1
│   │    ├─── admin_setup.ps1
│   │    └─── user_setup.ps1
│   └─── bit_locker.ps1
│
├─── .gitignore
├─── LICENSE
└─── README.md
```

</ul>
</details>

<br>

| Stage | Method | Objective |
|:--|:--|:--|
| [ 1 ] 系統環境定義 | Winget | 透過 Git 管理，隨時可以在新電腦部署開發環境 |
| [ 2 ] 硬碟加鎖 | [bit_locker.ps1](https://github.com/Junwu0615/My-Win-Apps#-dbitlocker--%E7%B3%BB%E7%B5%B1%E7%AE%A1%E7%90%86%E5%93%A1%E6%AC%8A%E9%99%90%E5%9F%B7%E8%A1%8C-) | 預設 3 個硬碟 C/D/E ; 密鑰放在 E 槽 ( 暫時 ➔ 存放安全位置 ) |
| [ 3 ] 用戶環境定義 | Winget | - |
| [ 4 ] 用戶個人化環境 | [layout.xml](https://github.com/Junwu0615/My-Win-Apps#-edeveloper-experience--windows-menu-) | - |
| [ 5 ] 備份鏡像 | [Macrium Reflect<br>(.mrimg)](https://github.com/Junwu0615/My-Win-Apps#-foffline-image-deployment) | 在乾淨環境下製作一次快照 ( USB )，作為備援防線 |
| [ ⭐ ] 災難復原 | 還原鏡像 | 鏡像恢復 ( 該快照包含穩定的系統底層 + 環境定義 ) |
| [ ⭐ ] 密鑰管理器 | Bitwarden | 9成密鑰存放處 + 2FA |

<br>

- #### *Implementation steps*
  > ##### *系統剛建立先不要做任何事情 ➔ 優先重新啟動*

  > ##### *檢視使用者名稱 ➔ 若非預期的命名 直接重新建立新帳戶 ( 非登入 )<br>➔ 創建 Admin ( 管理員 ) ➔ 移除第一個帳戶*
  
  > ##### *用 admin 執行 ./scripts/admin_setup.ps1*
  
  > ##### *進行硬碟加鎖 ( BitLocker ) ➔ 保管密鑰 ➔ 重新啟動 ➔ 自動解鎖非系統碟鎖*
  
  > ##### *創建 User Account*
  
  > ##### *用 user 執行 ./scripts/user_setup.ps1*
  
  > ##### *[用戶個人化環境備份 ( 方便一鍵復原 )](./docs/dev_experience.md)*
  
  > ##### *進行 Offline Image Deployment 快照作業 ( 災難復原 ➔ 回歸該階段 )*

<br>

### *B.　Windows Account Creation*
```
[1] Account A： Administrator ( 系統管理員 )
    帳號用途： 負責底層與全域工具 ( 僅用於安裝驅動程式、系統更新、執行會修改系統核心的腳本 )
    保持習慣： 平時不用此帳號上網，也不把它當作日常帳號

[2] Account B： UserName ( 標準使用者 )
    帳號用途： 負責應用程式與個人化環境 ( 日常開發、娛樂、瀏覽網頁 ...等 )
    強化防禦： 因為不是管理員，病毒若想寫入 C:\Windows 或修改系統註冊表，
             會直接被 UAC ( 使用者帳戶控制 ) 擋下，必須輸入密碼才能進行。
             能有效防止勒索軟體在背景自動加密系統檔案
```

<br>

### *C.　Install AppSet*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

- #### *⭐ 允許 PowerShell 執行腳本 ( 最小權限原則 ➔ 當前用戶 )*
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  ```
  
- #### *一鍵安裝所有必要應用*
  - #### _*[v1 : Boxstarter & Chocolatey](./docs/chocolatey.md)*_
  - #### _*[v2 : Winget](./docs/winget.md) ⭐*_

  
- #### *尚須手動建立應用*
  > #### *備註 : 以下應用程式因授權保護或軟體特殊性，需手動安裝或授權 ： [手動安裝名單](./packages/manual_install.md)*

<br>

### *⭐ D.　BitLocker ( 系統管理員權限執行 )*
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

### *⭐ E.　Developer Experience ( Windows Menu )*
```powershell
# 匯出設定
  - 建立備份目標資料夾
    New-Item -ItemType Directory -Force -Path "D:\Win11StartLayout"
  - 複製開始功能表的配置資料庫
    Copy-Item -Path "$env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Destination "D:\Win11StartLayout" -Recurse -Force

# 匯入設定
  - 將備份的配置還原回系統路徑
    Copy-Item -Path "D:\Win11StartLayout\LocalState\*" -Destination "$env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Recurse -Force

  - 強制重啟檔案總管與開始功能表程序，讓設定立刻生效
    Stop-Process -Name "explorer" -Force
    Stop-Process -Name "StartMenuExperienceHost" -Force -ErrorAction SilentlyContinue
```

<br>

### *⭐ F.　Offline Image Deployment*
> #### *離線映像還原 ( 災難還原 ) : 確保系統狀態與驅動程式 100% 回到某個特定時間點*

```
1. 製作啟動隨身碟(Rescue Media)： 當電腦中毒或系統損毀時，無法在 Windows 內部還原 C: 槽，必須透過隨身碟啟動環境 (WinPE) 進行
2. 創建鏡像： 將安裝好所有驅動、基本軟體、設定的 C: 槽，備份為一個 .mrimg 檔案，存放在隨身硬碟或 NAS
3. 還原鏡像： 當需要還原時，插上隨身碟啟動 -> 選擇該 .mrimg 檔案 -> 覆寫整個 C: 槽。過程約 5-10 分鐘，且不需要重灌與重新安裝軟體
```

<br>

### *G.　Anti-poisoning Habits*
```
[ 主力防禦 ]
- 保持 Windows Defender 開啟

[ 核心習慣 ]
- 不下載來路不明的破解軟體（ KMS、遊戲外掛、點選「信任」的未知巨集 ）
- 插上外來硬碟時，養成先右鍵用 Defender 掃描的習慣

[ 定期掃除 ]
- 執行 KVRT 進行全機深層掃描（ 防範高危險病毒、勒索軟體 ）
- 執行 Malwarebytes（ 免費版 ） 掃描（ 惡意彈窗廣告、流氓瀏覽器綁架、木馬程式 ）
```

<br><br>