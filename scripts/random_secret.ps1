# 1. 定義字符集 (包含大小寫字母、數字與符號)
$charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
$passwordLength = 20
$randomPassword = -join ((1..$passwordLength) | ForEach-Object { $charSet[(Get-Random -Maximum $charSet.Length)] })

# 2. 顯示並確認密碼 (重要：請務必在此刻複製並存入您的密碼管理員)
Write-Host " 已隨機生成新密碼: " -ForegroundColor Yellow
Write-Host " >>> $randomPassword <<< " -ForegroundColor Green
Write-Host " 請立即複製上方密碼 ..." -ForegroundColor Cyan