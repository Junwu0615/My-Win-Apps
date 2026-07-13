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
- #### *Windows-Sandbox*
  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableVM" -All
  ```

<br>

### *密鑰管理器*
- #### *[Bitwarden](https://bitwarden.com/)*
- #### *[Kaspersky Password Manager](https://www.kaspersky.com.tw/)*

<br>

### *開發應用*
- #### *[Python 3.14.6](https://www.python.org/downloads/release/python-3146/)*
- #### *[Python 3.13.14](https://www.python.org/downloads/release/python-31314/)*
- #### *[Python 3.12.10](https://www.python.org/downloads/release/python-31210/)*

<br>

### *日常應用*
- #### *[Line](https://www.line.me/tw/)*
- #### *[Bluestacks ( 模擬器 )](https://www.bluestacks.com/download.html)*
- #### *[QTranslate ( 翻譯工具 )](https://qtranslate.en.softonic.com/)*
- #### *[SurfShark ( VPN )](https://surfshark.com/zh-tw)*
- #### *[By Click Downloader ( YT Download )](https://www.byclickdownloader.com/zh/)*

<br>

### *裝置應用 & 驅動*
- #### *[AVerMedia Assist Central ( Camera Device Tools )](https://www.avermedia.com/tw/support/download/assist-central)*

<br>

### *可選應用*
- #### *Scoop ( 類似 Chocolatey 的工具市場集 )*
    ```powershell
    # 允許本機執行腳本
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  
    # 安裝 Scoop
    irm get.scoop.sh | iex
    ```

- #### *[tinytask ( 腳本精靈 )](https://www.tinytask.net/)*
- #### *[MEGA Downloader](https://megadownloader.en.softonic.com/)*
- #### *[DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)*
- #### *[Shutter Encoder](https://www.shutterencoder.com/)*
- #### *Win RAR ( 棄用 )*
- #### *Adobe Acrobat DC ( 棄用 )*