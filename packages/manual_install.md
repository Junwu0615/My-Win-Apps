### 核心
- #### Windows Defender
  ```powershell
  # 修復並重新註冊防毒元件
  Get-AppxPackage *Microsoft.Windows.SecHealthUI* | Reset-AppxPackage
  
  # 依序輸入以下三行指令
  Remove-Item -Path "$env:windir\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -Path "$env:windir\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
  gpupdate /force
  ```

- #### ESET Online Scanner
- #### Malwarebytes
- #### Kaspersky Password Manager

<br>

### 日常
- #### Scoop ( 類似 Chocolatey 的工具市場集 )
    ```powershell
    # 允許本機執行腳本
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  
    # 安裝 Scoop
    irm get.scoop.sh | iex
    ```

- #### PixPin
- #### QTranslate
- #### SurfShark
- #### By Click Downloader
- #### AVerMedia Assist Central

<br>

### 可選
- #### tinytask
- #### MEGA Downloader
- #### DaVinci Resolve
- #### Shutter Encoder
- #### Win RAR # 已棄用
- #### Adobe Acrobat DC # 已棄用