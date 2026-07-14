# 修正核心寫入邏輯
$targetFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse

foreach ($file in $targetFiles) {
    if ($file.Name -eq $MyInvocation.MyCommand.Name) { continue }

    # 使用 .NET 底層類別，直接強制指定 UTF8 (帶 BOM) 編碼，不經過 PowerShell 預設處理
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $utf8WithBom = New-Object System.Text.UTF8Encoding($true) # $true 表示強制帶 BOM
    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8WithBom)

    Write-Host "已強化編碼格式: $($file.Name)" -ForegroundColor Green
}