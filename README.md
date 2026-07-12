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
```

<br>

### *⭐ B.　Install Appset*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

- #### *安裝 Boxstarter*
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
    get-boxstarter -Force
    ```

- #### *列出目前所有已安裝應用清單*
    ```
    Get-Package | Select-Object Name, Version, ProviderName | Sort-Object Name | Out-File "$HOME\Desktop\installed_apps.txt"
    ```

- #### *[Chocolatey 官方網站](https://community.chocolatey.org/packages)*
  ```
  [1] 製作系統所需應用 軟體 id 參照官方網站 搜尋對應名稱
  [2] 填入 ./packages/packages.config
  ```

- #### *⭐ 透過 Boxstarter 自動化還原 ( 系統管理員權限執行 )*
  ```
  ./scripts/setup.ps1
  ```
  
- #### *手動名單*
  ```
  SurhShark
  By Click Downloader
  Kaspersky Password Manager
  AVerMedia Assist Central
  
  tinytask
  DaVinci Resolve
  Shutter Encoder
  Adobe Acrobat DC
  ```

<br>

### *⭐ C.　Offline Image Deployment*
> #### *離線映像還原 ( 災難還原 ) : 確保系統狀態與驅動程式 100% 回到某個特定時間點*

```
1. 製作啟動隨身碟(Rescue Media)： 當電腦中毒或系統損毀時，無法在 Windows 內部還原 C: 槽，必須透過隨身碟啟動環境 (WinPE) 進行
2. 創建鏡像： 將安裝好所有驅動、基本軟體、設定的 C: 槽，備份為一個 .mrimg 檔案，存放在隨身硬碟或 NAS
3. 還原鏡像： 當需要還原時，插上隨身碟啟動 -> 選擇該 .mrimg 檔案 -> 覆寫整個 C: 槽。過程約 5-10 分鐘，且不需要重灌與重新安裝軟體
```

<br>

### *⭐ C.　Configuration Blueprint*
<details>
<summary><b><i>　Tree </i></b></summary>
<ul>

```bash
.
├───configs
│   └───.gitkeep
├───packages
│   └───packages.config
├───scripts
│   └───setup.ps1
├─── .gitignore
├─── LICENSE
└─── README.md
```

</ul>
</details>

<br>

| Stage | Method | Objective |
|:--:|:--|:--|
| 1. 環境定義 | setup.ps1 | 透過 Git 管理，隨時可以在新電腦部署開發環境 |
| 2. 備份鏡像 | Macrium Reflect<br>(.mrimg) | 在乾淨環境下製作一次快照 ( USB )，作為備援防線 |
| 3. 恢復流程 | 直接還原鏡像 | 鏡像恢復 ( 該快照包含穩定的系統底層 + setup.ps1 ) |

<br><br>