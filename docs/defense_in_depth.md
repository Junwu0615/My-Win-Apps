## *⭐ Defense in Depth ⭐*
> #### *將 UAC 提權與安全桌面防禦頂滿 ( 防劫持 + 防監聽 )*

<br>

### *A.　⭐ 操作步驟*
```powershell
$systemPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# 1. 限制一般使用者提權時必須「輸入管理員密碼」（非管理員的 UAC 提權行為）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorUser" -Value 1

# 2. 限制管理員提權時也要「輸入密碼」或確認（提高防護，防止自動惡意提權）
Set-ItemProperty -Path $systemPath -Name "ConsentPromptBehaviorAdmin" -Value 1

# 3. 強制 UAC 彈出時必須切換至「安全桌面」（凍結背景，防止變形木馬或鍵盤側錄）
Set-ItemProperty -Path $systemPath -Name "PromptOnSecureDesktop" -Value 1
```