## *⭐ Defense in Depth ⭐*
> #### *安全性導向 (A)：UAC 與安全桌面設定是 Windows 防禦劫持的基石。這是最安全、最具備防禦價值的設定*

> #### *隱私導向 (B, C, D)：遙測、廣告建議與 Bing 搜尋整合，這些屬於微軟的「雲端延伸服務」，關閉後除了失去搜尋網頁建議外，完全不影響系統運作*

> #### *精簡導向 (E, F)：服務（如 MapsBroker, WAPush）確實已過時或與開發者環境無關。這類調整對效能提升雖然輕微，但對「系統整潔度」提升巨大*

<br>

### *A.　⭐ 將 UAC 提權與安全桌面防禦頂滿 ( 防劫持 + 防監聽 )*
```powershell
$systemPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# 1. 限制一般使用者提權時必須「輸入管理員密碼」（非管理員的 UAC 提權行為）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorUser" -Value 1

# 2. 限制管理員提權時也要「輸入密碼」或確認（提高防護，防止自動惡意提權）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorAdmin" -Value 1

# 3. 強制 UAC 彈出時必須切換至「安全桌面」（凍結背景，防止變形木馬或鍵盤側錄）
Set-ItemProperty -Path $systemPath -Name "PromptOnSecureDesktop" -Value 1
```

<br>

### *B.　⭐ 關閉遙測與追蹤服務*
```powershell
# 停止並禁用診斷追蹤服務
Stop-Service -Name "DiagTrack" -Force
Set-Service -Name "DiagTrack" -StartupType Disabled

# 停止並禁用裝置管理遙測服務
Stop-Service -Name "dmwappushservice" -Force
Set-Service -Name "dmwappushservice" -StartupType Disabled

# 禁用相容性遙測 (若有的話)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -ErrorAction SilentlyContinue
```

<br>

### *C.　⭐ 關閉 Windows Defender 以外的建議功能*
```powershell
# 關閉開始選單建議
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0

# 關閉顯示建議內容
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
```

<br>


### *D.　⭐ 徹底禁用 Bing 搜尋*
```powershell
# 1. 建立搜尋政策機碼路徑
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (!(Test-Path $path)) { New-Item -Path $path -Force }

# 2. 禁用搜尋框中的網路搜尋與 Bing 整合
Set-ItemProperty -Path $path -Name "DisableSearchBoxSuggestions" -Value 1

# 3. 停用搜尋結果中的網頁內容 (針對 Windows 10/11)
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (!(Test-Path $policyPath)) { New-Item -Path $policyPath -Force }
Set-ItemProperty -Path $policyPath -Name "ConnectedSearchUseWeb" -Value 0
Set-ItemProperty -Path $policyPath -Name "AllowCloudSearch" -Value 0
```

<br>

### *E.　⭐ 服務層級的精簡*
```powershell
# 關閉下述服務指令
  - PrintNotify (列印通知)：如果不連接實體印表機
  - MapsBroker (下載地圖服務)：絕對沒用的背景進程
  - WAPush (WAP 推送訊息傳遞)：現代環境早已不用

$uselessServices = @("MapsBroker", "WAPush")
foreach ($svc in $uselessServices) {
    Set-Service -Name $svc -StartupType Disabled
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
}
```

<br>

### *F.　⭐ 停用不必要的 Windows 功能*
```powershell
# 禁用 Windows 傳遞最佳化 (Windows Update 佔用頻寬的兇手)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0

# 禁用遠端協助 (除非需要遠端支援，否則這也是潛在攻擊面)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0
```

<br><br>