### *核心防毒*
- #### *Windows Defender*
  ```powershell
  # 修復並重新註冊防毒元件
  Get-AppxPackage *Microsoft.Windows.SecHealthUI* | Reset-AppxPackage
  
  # 依序輸入以下三行指令
  Remove-Item -Path "$env:windir\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -Path "$env:windir\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
  gpupdate /force
  ```

- #### *[Kaspersky Virus Removal Tool ( KVRT )](https://www.kaspersky.com/downloads/free-virus-removal-tool)*
- #### *[ESET Online Scanner](https://www.eset.com/afr/online-scanner/)*
- #### *[Malwarebytes](https://www.malwarebytes.com/)*

<br>

### *密鑰管理器*
- #### *[Bitwarden](https://bitwarden.com/)*
- #### *[Kaspersky Password Manager](https://www.kaspersky.com.tw/)*

<br>

### *開發應用*
- #### *Python 3.14*
- #### *Python 3.13*
- #### *Python 3.12*

<br>

### *日常應用*
- #### *[Bluestacks ( 模擬器 )](https://www.bluestacks.com/download.html)*
- #### *Windows-Sandbox*
  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableVM" -All
  ```

- #### *PixPin ( 截圖標記工具 )*
- #### *QTranslate ( 翻譯工具 )*
- #### *SurfShark ( VPN )*
- #### *By Click Downloader ( YT Download )*
- #### *AVerMedia Assist Central ( Camera Device Tools )*

<br>

### *可選應用*
- #### *Scoop ( 類似 Chocolatey 的工具市場集 )*
    ```powershell
    # 允許本機執行腳本
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  
    # 安裝 Scoop
    irm get.scoop.sh | iex
    ```

- #### *tinytask*
- #### *MEGA Downloader*
- #### *DaVinci Resolve*
- #### *Shutter Encoder*
- #### *Win RAR ( 棄用 )*
- #### *Adobe Acrobat DC ( 棄用 )*