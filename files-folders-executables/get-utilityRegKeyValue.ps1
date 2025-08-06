
$registryPath = "HKLM:\SOFTWARE\company\utility"
$valueName = "AppVersion"


Get-Item -Path $registryPath -Verbose
(Get-Item -Path $registryPath).GetValue($valueName)

Get-ItemProperty -Path "HKLM:\SOFTWARE\company\utility" -Name "AppVersion"

New-Item -Path "HKLM:\SOFTWARE\company\utility"

Get-ChildItem -Path "HKLM:\SOFTWARE\" | Select-Object Name

Get-ChildItem -Path "HKLM:\\SOFTWARE\Notepad++"

Get-Item -Path "HKLM:\\SOFTWARE\Notepad++" | select *

Get-ItemProperty -Path "HKLM:\\SOFTWARE\Notepad++" -Name "AppVersion"