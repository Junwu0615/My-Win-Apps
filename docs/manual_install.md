### *核心應用 & 防毒*
- #### *[ 內建常駐 ] Windows Defender*
  ```powershell
  # 修復並重新註冊防毒元件
  Get-AppxPackage *Microsoft.Windows.SecHealthUI* | Reset-AppxPackage
  
  # 依序輸入以下三行指令
  Remove-Item -Path "$env:windir\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -Path "$env:windir\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
  gpupdate /force
  ```

- #### *[ 定期掃毒 ] [Kaspersky Virus Removal Tool ( KVRT )](https://www.kaspersky.com/downloads/free-virus-removal-tool)*
- #### *[ 定期掃毒 ] [ESET Online Scanner](https://www.eset.com/afr/online-scanner/)*
- #### *[ 定期掃毒 ] [Malwarebytes](https://www.malwarebytes.com/)*
- #### *⭐ [ 拋棄式安全虛擬電腦 ] Windows-Sandbox*
  ```powershell
  # 安裝方式
  Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -All
  
  
  # 用法
  - 🔗 複製與貼上網址（純文字）
    安全狀態 ： 絕對安全
    原理 ： 只是一串純文字，只要沒有用瀏覽器去「點擊」或「開啟」它，它就沒有任何殺傷力
  
  - 🗂️ 複製與貼上檔案（例如：.exe 程式、壓縮檔）
    安全狀態 ： 複製貼上是安全的，直到你「雙擊執行」它
    原理 ： 病毒檔案就像一顆還沒拔掉插銷的手榴彈。如果只是用滑鼠對著它按 Ctrl+C、
           然後在沙盒裡按 Ctrl+V，這個動作只是「搬移資料」，病毒並未開始運作
  
  - 更進階用法好像是預先裝設測試工具 ... 之類 ( .wsb )
  ```
  
- #### *⭐ [ 實用的工具 ]*
  - #### *瀏覽器連結辨識插件 : [Malwarebytes Browser Guard](https://chromewebstore.google.com/detail/malwarebytes-browser-guar/ihcjicgdanjaechkgeegckofjjedodee?hl=zh-TW&utm_source=ext_sidebar)* 
  - #### *[VirusTotal](https://www.virustotal.com/) ( 業界標準，會同時調用超過 70 種防毒引擎<br>與網址黑名單服務，提供最全面的風險評估 )*
  - #### *[URLScan.io](https://urlscan.io/) ( 它會模擬瀏覽器去「訪問」該網址，並顯示網頁截圖與行為分析。<br>適合用來檢查網頁是否有隱藏的惡意腳本、釣魚偽裝或惡意重新導向 )*

<br>

### *密鑰管理器 ( 擇一 )*
- #### *⭐ [Bitwarden](https://bitwarden.com/)*
- #### *[Kaspersky Password Manager](https://www.kaspersky.com.tw/)*

<br>

### *2FA*
> #### *延伸參考 : [個人機密 - 資安防護措施](./2FA.md)*
- #### *[Google Authenticator](https://apps.apple.com/tw/app/google-authenticator/id388497605)*
- #### *⭐ [KeePassXC](https://keepassxc.org/)*
- #### *⭐ [Microsoft Authenticator](https://www.microsoft.com/zh-tw/security/mobile-authenticator-app)*

<br>

### *多元檔案管理器 ( 擇一 )*
> #### *各類多媒體包括但不限於 [ 影片 / 照片 / 音檔 ]*
- #### *⭐ [Cryptomator](https://cryptomator.org/)*

<br>

### *開發應用 ( 註: 不汙染系統環境路徑 )*
- #### *[Python 3.14.6](https://www.python.org/downloads/release/python-3146/)*
- #### *[Python 3.13.14](https://www.python.org/downloads/release/python-31314/)*
- #### *[Python 3.12.10](https://www.python.org/downloads/release/python-31210/)*

<br>


### *日常應用*
- #### *Could*
  - #### *[GoogleDriveSetup.exe](https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe)*

- #### *Office*
  - #### *[Trio Office : DOCX & XLSX Editor](https://apps.microsoft.com/detail/9P9F6DZJBBLJ?hl=zh-tw&gl=TW&ocid=pdpshare)*

- #### *社群軟體*
  - #### *[Line](https://www.line.me/tw/)*

- #### *翻譯工具*
  - #### *QTranslate ( 安全度不夠 )*
  - #### *[DeepL Desktop](https://www.deepl.com/en/app/thanks?os=windows)*

- #### *VPN*
  - #### *[SurfShark](https://surfshark.com/zh-tw)*

- #### *下載器*
  - #### *[By Click Downloader ( YT 下載器 )](https://www.byclickdownloader.com/zh/)*
  - #### *[YT 開源下載神器 : ytdlp-interface](https://github.com/Junwu0615/My-Win-Apps/blob/main/docs/winget.md#d%E5%85%B6%E4%BB%96)*
    - #### *[匯出 cookie 工具 : Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/cclelndahbckbenkjhflpdbgdldlbecc?utm_source=item-share-cb)*
  - #### *[MEGA Downloader](https://www.azofreeware.com/2013/05/megadownloader-081-beta-mega.html)*

<br>


### *娛樂應用*
- #### *模擬器*
  - #### *[Bluestacks](https://www.bluestacks.com/download.html)*
  - #### *[APKPure 非官方市場](https://apkpure.com/tw/)*
- #### *[Tinytask ( 腳本精靈 )](https://www.tinytask.net/)*

<br>

### *裝置應用 & 驅動*
- #### *[AVerMedia Assist Central ( Camera Device Tools )](https://www.avermedia.com/tw/support/download/assist-central)*

<br>

### *剪輯應用*
- #### *[DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)*
- #### *[Shutter Encoder](https://www.shutterencoder.com/)*

<br>

### *可選應用*
- #### *Scoop ( 類似 Chocolatey 的工具市場集 )*
    ```powershell
    # 允許本機執行腳本
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  
    # 安裝 Scoop
    irm get.scoop.sh | iex
    ```
- #### *Win RAR ( 棄用 )*
- #### *Adobe Acrobat DC ( 棄用 )*