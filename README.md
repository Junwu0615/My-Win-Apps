## *⭐ My-Win-Apps ⭐*

<br>

### *⭐ A.　Windows Account Creation*
```
[1] Account A： Administrator ( 系統管理員 )
  帳號用途： 僅用於安裝驅動程式、系統更新、執行 setup.ps1 此類會修改系統核心的腳本
  保持習慣： 平時不用此帳號上網，也不把它當作日常帳號

[2] Account B： UserName ( 標準使用者 )
  帳號用途： 日常開發、GitHub 操作、瀏覽網頁
  強化防禦： 因為不是管理員，病毒若想寫入 C:\Windows 或修改系統註冊表，
           會直接被 UAC ( 使用者帳戶控制 ) 擋下，必須輸入密碼才能進行。
           能有效防止勒索軟體在背景自動加密系統檔案


# 若是系統剛建立 先不要做任何事情 ➔ 優先重新啟動 
  接著檢視使用者名稱 ➔ 若非預期的命名 建議重新建立帳戶
  創建 Admin ( 管理員 ) 後 ➔ 移除第一個帳戶，接著後續流程 ...
  
# 用 admin 執行 ./scripts/admin_setup.ps1 完畢後 ➔ 創建 User Account ...

# 用 user 執行 ./scripts/user_setup.ps1 完畢後 ➔ 個人化排版 ➔ 輸出 xml 設定檔 ( 方便一鍵復原 )

# 最後進行 Offline Image Deployment 快照作業 ...
```

<br>

### *⭐ B.　Install Appset*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

- #### *允許執行腳本 ( 最小權限原則 ➔ 當前用戶 )*
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  ```
  
- #### *安裝 Boxstarter*
  ```powershell
  iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
  get-boxstarter -Force
  ```

- #### *列出目前所有已安裝應用清單*
  ```
  Get-Package | Select-Object Name, Version, ProviderName | Sort-Object Name | Out-File "$HOME\Desktop\installed_apps.txt"
  ```

- #### *[參照 Chocolatey 官方網站 ➔ 搜尋對應名稱](https://community.chocolatey.org/packages)*
  ```
  [1] 將系統所需應用 依照官方網站 搜尋對應名稱 ( 軟體 id )
  [2] 填入 ./packages/packages.config
  ```

- #### *⭐ 透過 Boxstarter 自動化還原 ( 系統管理員權限執行 )*
  ```
  # Admin
  ./scripts/admin_setup.ps1
  
  # User
  ./scripts/user_setup.ps1
  ```
  
  - #### *可能會遇到衝突 ...*
    ```
    # 若是網上載下來文件因信任問題 ( 未簽署 ) 而無法使用 ➔ 需先解鎖 ( 專案根目錄 )
    Get-ChildItem -Recurse | Unblock-File
  
    # 若是遇到解析問題 另存新檔為 BOM-UTF8 格式
    
    # Chocolatey 為防止下載到被惡意竄改的安裝檔，在每個軟體套件的設定檔中都有記錄一個正確的 sha256 校驗碼
    Error - hashes do not match. Actual value was '9ACB674A2BA8DF6356DA454D49807E0CA72AC581C49E11522618745B392D1321'.
    手動校正 ( 因 Chocolatey 社群沒同步更新 )
    choco install kvrt --checksum="9ACB674A2BA8DF6356DA454D49807E0CA72AC581C49E11522618745B392D1321" -y
    ```
  
- #### *尚須手動建立應用*
  > #### *備註 : 以下應用程式因授權保護或軟體特殊性，需手動安裝或授權 ： [手動名單](./packages/manual_install.txt)*

<br>

### *⭐ C.　Offline Image Deployment*
> #### *離線映像還原 ( 災難還原 ) : 確保系統狀態與驅動程式 100% 回到某個特定時間點*

```
1. 製作啟動隨身碟(Rescue Media)： 當電腦中毒或系統損毀時，無法在 Windows 內部還原 C: 槽，必須透過隨身碟啟動環境 (WinPE) 進行
2. 創建鏡像： 將安裝好所有驅動、基本軟體、設定的 C: 槽，備份為一個 .mrimg 檔案，存放在隨身硬碟或 NAS
3. 還原鏡像： 當需要還原時，插上隨身碟啟動 -> 選擇該 .mrimg 檔案 -> 覆寫整個 C: 槽。過程約 5-10 分鐘，且不需要重灌與重新安裝軟體
```

<br>

### *⭐ D.　開發者體驗 ( Win 開始 )*
```
# 匯出設定
Export-StartLayout -Path "D:\layout.xml"

# 匯入設定
Import-StartLayout -LayoutPath "D:\layout.xml" -MountPath C:\
```


<br>

### *⭐ E.　Configuration Blueprint*
<details>
<summary><b><i>　Tree </i></b></summary>
<ul>

```bash
.
├───configs
│   └─── .gitkeep
│
├───packages
│   ├─── manual_install.txt
│   ├─── admin.config
│   └─── user.config
│
├───scripts
│   ├─── admin_setup.ps1
│   └─── user_setup.ps1
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
| [1] 環境定義 | setup.ps1 | 透過 Git 管理，隨時可以在新電腦部署開發環境 |
| [2] 備份鏡像 | Macrium Reflect<br>(.mrimg) | 在乾淨環境下製作一次快照 ( USB )，作為備援防線 |
| [3] 恢復流程 | 直接還原鏡像 | 鏡像恢復 ( 該快照包含穩定的系統底層 + setup.ps1 ) |

<br><br>