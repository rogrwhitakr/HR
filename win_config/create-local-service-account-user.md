To create a **local user** on **Windows Server** for **executing PowerShell scripts locally** with **minimal privileges**:

## 1. Local User erstellen (Run As Administrator)
```powershell
# Neuer User + Passwort nie abläuft
$Password = ConvertTo-SecureString "SecureP@ssw0rd123!" -AsPlainText -Force
New-LocalUser -Name "ps-scriptuser" -Password $Password -PasswordNeverExpires -Description "Local user for PowerShell scripts"

# User deaktivieren (bis benötigt)
Disable-LocalUser -Name "ps-scriptuser"
```

## 2. Minimale Rechte zuweisen
```powershell
# User in "Users" Gruppe (Standard)
# Logon as batch job (für Task Scheduler)
$sid = (Get-LocalUser -Name "ps-scriptuser").SID
$batchPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
New-ItemProperty -Path $batchPath -Name "SeBatchPrivilege\$sid" -PropertyType MultiString -Value "SeBatchPrivilege" -Force

# Oder über secpol.msc: Local Policies → User Rights Assignment → Log on as a batch job
```

## 3. PowerShell Execution Policy erlauben
```powershell
# ExecutionPolicy für alle User (oder nur für diesen User via GPO)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

## 4. Script als Task Scheduler ausführen (empfohlen)
```powershell
# Task erstellen, läuft als ps-scriptuser
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\MyScript.ps1"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)  # oder -Daily etc.
$principal = New-ScheduledTaskPrincipal -UserId ".\ps-scriptuser" -LogonType Password
Register-ScheduledTask -TaskName "MyScriptTask" -Action $action -Trigger $trigger -Principal $principal -Password "SecureP@ssw0rd123!"
```

## 5. Direkt als Service User (falls benötigt)
```powershell
# Task Scheduler → Create Task → Run whether user logged on or not
# User: .\ps-scriptuser, Password angeben
```

## 6. Test
```powershell
# User aktivieren
Enable-LocalUser -Name "ps-scriptuser"

# Test Script ausführen
Start-Process PowerShell -ArgumentList "-File C:\Scripts\Test.ps1" -Credential (Get-Credential .\ps-scriptuser)
```

## Security Best Practices
```
✅ Local User (kein Domain Account)
✅ PasswordNeverExpires + starkes Passwort (oder Managed Service Account)
✅ Logon as batch job ONLY
✅ Script in geschütztem Ordner (C:\Scripts, NTFS ACL: Scriptuser Read+Execute)
✅ Task Scheduler: Run whether user logged on or not
❌ Keine Admin/Interactive Logon Rights
❌ Keine RDP/Console Logon
```

**Fertig.** User ist bereit für **automatisierte lokale Script‑Ausführung** ohne Admin‑Rechte.