## *⭐ Winget ⭐*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

<br>

#### *A.　⭐ 安裝 Winget*
```powershell

```

<br>

#### *B.　[查找 Winget 支援應用](https://winstall.app/)*
```
[1] 將系統所需應用 依照官方網站 搜尋對應名稱 ( 軟體 id )
[2-1] 填入 ./packages/v2/admin_winget.json
[2-2] 填入 ./packages/v2/user_winget.json
```

<br>

#### *C.　⭐ 一鍵安裝應用*
```powershell
# Admin
winget import -i packages/v2/admin_winget.json --accept-package-agreements --accept-source-agreements

# User
winget import -i packages/v2/user_winget.json --accept-package-agreements --accept-source-agreements
```

<br><br>