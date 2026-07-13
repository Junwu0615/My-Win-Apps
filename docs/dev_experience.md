## *⭐ Developer Experience ⭐*
> #### *System : Windows 11*

<br>

### *A.　⭐ 開始選單*
```powershell
# 匯出設定
  - 建立備份目標資料夾
    New-Item -ItemType Directory -Force -Path "D:\Win11StartLayout"
  - 複製開始功能表的配置資料庫
    Copy-Item -Path "$env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Destination "D:\Win11StartLayout" -Recurse -Force

# 匯入設定
  - 將備份的配置還原回系統路徑
    Copy-Item -Path "D:\Win11StartLayout\LocalState\*" -Destination "$env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Recurse -Force

  - 強制重啟檔案總管與開始功能表程序，讓設定立刻生效
    Stop-Process -Name "explorer" -Force
    Stop-Process -Name "StartMenuExperienceHost" -Force -ErrorAction SilentlyContinue
```

<br>

### *B.　⭐ 工作列*
```powershell
# 匯出工作列的登錄檔設定
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "D:\Win11StartLayout\taskbar.reg" /y


# 匯入工作列設定 ( 匯入 + 重啟 explorer )
reg import "D:\Win11StartLayout\taskbar.reg"
Stop-Process -Name "explorer" -Force
```
