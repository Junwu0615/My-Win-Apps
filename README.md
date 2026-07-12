## *⭐ My-Win-Apps ⭐*

<br>

### *⭐ A.　Windows Account Creation*
```
[1] Win Admin
[2] Win Dev
```

<br>

### *⭐ B.　Install*
> #### *個人化開發環境 : 軟體會隨套件庫更新而變*

- #### *安裝 Boxstarter*
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
    get-boxstarter -Force
    ```

- #### *列出目前所有已安裝應用清單*
    ```
    Get-Package | Select-Object Name, Version, ProviderName | Sort-Object Name | Out-File "$HOME\Desktop\installed_apps.txt"
    ```

- #### *透過 Boxstarter 自動化還原*
    ```
    Install-BoxstarterPackage -PackageName "setup.txt" -DisableReboot:$false
    ```

<br>

### *⭐ C.　離線映像還原 ( Offline Image Deployment )*
> #### *災難還原: 確保系統狀態與驅動程式 100% 回到某個特定時間點*

```
1. 製作啟動隨身碟(Rescue Media)： 當電腦中毒或系統損毀時，無法在 Windows 內部還原 C: 槽，必須透過隨身碟啟動環境 (WinPE) 進行
2. 創建鏡像： 將安裝好所有驅動、基本軟體、設定的 C: 槽，備份為一個 .mrimg 檔案，存放在隨身硬碟或 NAS
3. 還原鏡像： 當需要還原時，插上隨身碟啟動 -> 選擇該 .mrimg 檔案 -> 覆寫整個 C: 槽。這過程約 5-10 分鐘，且不需要重灌與重新安裝軟體
```

<br><br>