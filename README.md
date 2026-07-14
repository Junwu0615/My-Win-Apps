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
│   ├─── bitlocker.md
│   ├─── chocolatey.md
│   ├─── defense_in_depth.md
│   ├─── dev_experience.md
│   ├─── manual_install.md
│   ├─── offline_image.md
│   └─── winget.md
│
├─── configs
│   └─── .gitkeep
│
├─── packages
│   ├─── v1
│   │    ├─── admin.config
│   │    └─── user.config
│   └─── v2
│        ├─── admin_winget.json
│        └─── user_winget.json
│
├─── scripts
│   ├─── v1
│   │    ├─── admin_setup.ps1
│   │    └─── user_setup.ps1
│   │
│   ├─── bit_locker.ps1
│   ├─── defense_in_depth.ps1
│   ├─── fix-encoding.ps1
│   └─── random_secret.ps1
│
├─── .editorconfig
├─── .gitignore
├─── LICENSE
└─── README.md
```

</ul>
</details>

<br>

| _Stage_ | _Method_ | _Objective_ |
|:--|:--|:--|
| **1.　重灌** | - | _系統剛建立先不要做任何事情 ➔ 優先重新啟動_ |
| **2.　創建 Admin 帳戶** | - | _檢視使用者名稱 ➔ 若非預期的命名<br>➔ 直接重新建立新帳戶 ( 非 MS 登入 )<br>➔ 創建 Admin ( 管理員 ) ➔ 移除第一個帳戶<br><br>封鎖木馬/勒索病毒 ➔ 直接修改系統與大面積破壞_ |
| **3.　Admin 應用建置** | _[Admin Winget](./docs/winget.md)_ | _透過 Git 管理，隨時可在新電腦部署全域應用_ |
| **4.　硬碟加鎖** | _[BitLocker](./docs/bitlocker.md)_ | _封鎖物理攻擊 : 實體竊盜 + WinPE 入侵_ |
| **5.　縱深防禦** | _[Defense in Depth](./docs/defense_in_depth.md)_ | _將 UAC 提權與安全桌面防禦頂滿 ( 防劫持 + 防監聽 )_ |
| **6.　創建 User 帳戶** | - | _一般權限 ( 99.99 % 都在此活動 )_ |
| **7.　User 應用建置** | _[User Winget](./docs/winget.md)_ | _透過 Git 管理，隨時可在新電腦部署開發應用_ |
| **8.　手動安裝指定應用** | _[Manual Install](./docs/manual_install.md)_ | _應用程式因授權保護或軟體特殊性，需手動安裝或授權_ |
| **9.　個人化環境備份** | _[Developer Experience](./docs/dev_experience.md)_ | _方便一鍵復原個人化環境_ |
| **10.　鏡像快照** | _[Clonezilla](./docs/offline_image.md)_ | _乾淨環境下製作快照 ( 離線鏡像 ) ➔ 備援防線_ |
|   |   |   |
| **⭐ 災難復原** | _鏡像還原_ | _鏡像恢復 ( 快照包含系統穩定的時間點 + 已建置完善全應用 )_ |
| **⭐ 密鑰管理器** | _Bitwarden_ | _9 成密鑰存放處 + 2FA +<br>Cryptomator 保險箱的主密碼（Master Password）+<br>BitLocker 密鑰復原檔（Recovery Key）_ |
| **⭐ 多元檔案管理器** | _Cryptomator_ | _地/雲端 ( 雙向同步/鏡像 ) + 加密資料夾_ |

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
 - 不用瀏覽器不合規插件 + cookie 密碼管理
 - 統一用 Bitwarden 管理大部分密鑰 + 2FA ( 註: 冷儲存不能少 )
 - 敏感資訊用匿名瀏覽器或獨立瀏覽器 ( 禁止外掛插件介入 )
    - 日常瀏覽 Google Chrome
    - 敏感瀏覽 Microsoft Edge

[ 定期掃除 ]
 - 執行 KVRT 進行全機深層掃描（ 防範高危險病毒、勒索軟體 ）
 - 執行 Malwarebytes 掃描（ 惡意彈窗廣告、流氓瀏覽器綁架、木馬程式 ）
 - 執行 ESET Online Scanner 掃描
```

<br><br>