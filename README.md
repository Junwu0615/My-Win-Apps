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
| [ 5 ] 備份鏡像 | [Clonezilla](https://github.com/Junwu0615/My-Win-Apps#-foffline-image-deployment) | 在乾淨環境下製作一次快照 ➔ 備援防線 |
| [ ⭐ ] 災難復原 | 還原鏡像 | 鏡像恢復 ( 該快照包含穩定的系統底層 + 環境定義 ) |
| [ ⭐ ] 密鑰管理器 | Bitwarden | 9成密鑰存放處 + 2FA |

<br>

- #### *Implementation steps*
  > ##### *1.　系統剛建立先不要做任何事情 ➔ 優先重新啟動*

  > ##### *2.　檢視使用者名稱 ➔ 若非預期的命名 直接重新建立新帳戶 ( 非登入 )<br>➔ 創建 Admin ( 管理員 ) ➔ 移除第一個帳戶*
  
  > ##### *3.　用 admin 執行 ./scripts/admin_setup.ps1*
  
  > ##### *4.　[進行硬碟加鎖 ( BitLocker )](./docs/bitlocker.md) ➔ 保管密鑰 ➔ 重新啟動 ➔ 自動解鎖非系統碟鎖*
  
  > ##### *5.　創建 User Account*
  
  > ##### *6.　用 user 執行 ./scripts/user_setup.ps1*
  
  > ##### *7.　[用戶個人化環境備份 ( 方便一鍵復原 )](./docs/dev_experience.md)*
  
  > ##### *8.　[進行快照作業](./docs/offline_image_deployment.md) ( 災難復原 ➔ 回歸該階段 )*

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

### *C.　Anti-poisoning Habits*
```
[ 主力防禦 ]
- 保持 Windows Defender 開啟

[ 核心習慣 ]
- 不下載來路不明的破解軟體（ KMS、遊戲外掛、點選「信任」的未知巨集 ）
- 插上外來硬碟時，養成先右鍵用 Defender 掃描的習慣
- 統一用 Bitwarden 管理大部分密鑰 + 2FA ( 註: 冷儲存不能少 )

[ 定期掃除 ]
- 執行 KVRT 進行全機深層掃描（ 防範高危險病毒、勒索軟體 ）
- 執行 Malwarebytes 掃描（ 惡意彈窗廣告、流氓瀏覽器綁架、木馬程式 ）
```

<br>

### *D.　Install AppSet*
- #### *⭐ 允許 PowerShell 執行腳本 ( 最小權限原則 ➔ 當前用戶 )*
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  ```
  
- #### *一鍵安裝所有必要應用*
  - #### _*[v1 : Boxstarter & Chocolatey](./docs/chocolatey.md)*_
  - #### _*[v2 : Winget](./docs/winget.md) ⭐*_

- #### *尚須手動建立應用*
  > #### *備註 : 以下應用程式因授權保護或軟體特殊性，需手動安裝或授權 ： [手動安裝名單](./packages/manual_install.md)*


<br><br>