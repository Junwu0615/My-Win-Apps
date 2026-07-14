# 檢查是否以管理員身分執行
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "錯誤： 此腳本必須以「系統管理員身分」執行！請對 PowerShell 按右鍵選擇「以系統管理員身分執行」"
    exit 1
}

# 設定 PowerShell 執行權限
Set-ExecutionPolicy Bypass -Scope Process -Force


# 建立系統還原點
Write-Host "[0] 正在建立系統還原點 ..." -ForegroundColor Yellow
Checkpoint-Computer -Description "My-Win-Apps-Pre-Optimization" -RestorePointType "MODIFY_SETTINGS"
Write-Host "還原點建立完成." -ForegroundColor Green


Write-Host "[1] 將 UAC 提權與安全桌面防禦頂滿 ( 防劫持 + 防監聽 ) ..." -ForegroundColor Cyan
$systemPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
# 1. 限制一般使用者提權時必須「輸入管理員密碼」（非管理員的 UAC 提權行為）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorUser" -Value 1
# 2. 限制管理員提權時也要「輸入密碼」或確認（提高防護，防止自動惡意提權）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorAdmin" -Value 1
# 3. 強制 UAC 彈出時必須切換至「安全桌面」（凍結背景，防止變形木馬或鍵盤側錄）
Set-ItemProperty -Path $systemPath -Name "PromptOnSecureDesktop" -Value 1


Write-Host "[2] 關閉遙測與追蹤服務 ..." -ForegroundColor Cyan
# 停止並禁用診斷追蹤服務
Stop-Service -Name "DiagTrack" -Force
Set-Service -Name "DiagTrack" -StartupType Disabled
# 停止並禁用裝置管理遙測服務
Stop-Service -Name "dmwappushservice" -Force
Set-Service -Name "dmwappushservice" -StartupType Disabled
# 禁用相容性遙測 (若有的話)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -ErrorAction SilentlyContinue


Write-Host "[3] 關閉 Windows Defender 以外的建議功能 ..." -ForegroundColor Cyan
# 關閉開始選單建議
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
# 關閉顯示建議內容
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0


Write-Host "[4] 徹底禁用 Bing 搜尋 ..." -ForegroundColor Cyan
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


Write-Host "[5] 服務層級的精簡 ..." -ForegroundColor Cyan
$uselessServices = @("MapsBroker", "WAPush")
foreach ($svc in $uselessServices) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Set-Service -Name $svc -StartupType Disabled
        Stop-Service -Name $svc -Force
    }
}


Write-Host "[6] 停用不必要的 Windows 功能 ..." -ForegroundColor Cyan
# 禁用 Windows 傳遞最佳化 (Windows Update 佔用頻寬的兇手)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0
# 禁用遠端協助 (除非需要遠端支援，否則這也是潛在攻擊面)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0


Write-Host "優化完成！ 建議立即重新啟動電腦以生效 ..." -ForegroundColor Yellow