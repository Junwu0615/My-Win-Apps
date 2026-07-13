## *⭐ Boxstarter & Chocolatey ⭐*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

<br>

#### *A.　⭐ 安裝 Boxstarter*
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
get-boxstarter -Force
```

<br>

#### *B.　列出目前所有已安裝應用清單*
```powershell
Get-Package | Select-Object Name, Version, ProviderName | Sort-Object Name | Out-File "$HOME\Desktop\installed_apps.txt"
```

<br>

#### *C.　[參照 Chocolatey 官方網站 ➔ 搜尋對應名稱](https://community.chocolatey.org/packages)*
```
[1] 將系統所需應用 依照官方網站 搜尋對應名稱 ( 軟體 id )
[2-1] 填入 ./packages/v1/admin.config
[2-2] 填入 ./packages/v1/user.config
```

<br>

#### *D.　⭐ 透過 Boxstarter 自動化還原 ( 系統管理員權限執行 )*
```powershell
# Admin
./scripts/v1/admin_setup.ps1

# User
./scripts/v1/user_setup.ps1
```
  
- #### *可能會遇到衝突 ...*
  ```powershell
  # 若是網上載下來文件因信任問題 ( 未簽署 ) 而無法使用 ➔ 需先解鎖 ( 專案根目錄 )
  Get-ChildItem -Recurse | Unblock-File
  
  # 若是遇到解析問題 另存新檔為 BOM-UTF8 格式
    
  # Chocolatey 為防止下載到被惡意竄改的安裝檔，在每個軟體套件的設定檔中都有記錄一個正確的 sha256 校驗碼
  Error - hashes do not match. Actual value was '9ACB674A2BA8DF6356DA454D49807E0CA72AC581C49E11522618745B392D1321'.
  手動校正 ( 因 Chocolatey 社群沒同步更新 )
  choco install kvrt --checksum="9ACB674A2BA8DF6356DA454D49807E0CA72AC581C49E11522618745B392D1321" -y
  ```

<br>

#### *E.　全部解除安裝*
```powershell
choco uninstall (choco list --local-only --limit-output | ForEach-Object { $_.Split('|')[0] }) -y
```

<br><br>