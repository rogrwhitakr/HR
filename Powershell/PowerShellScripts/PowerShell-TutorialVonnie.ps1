#05.04.2016

Get-Service | ? {$_.Status -eq "running"} | Select-Object -Property machinename,displayname,Name 

#07.04.2016

get-service -ComputerName reese

$session = New-PSSession -ComputerName reese -Credential (Get-Credential)
Invoke-Command -Session $session -ScriptBlock {get-service}

winrm g

Set-Alias gh Get-Help
gh about_Remote_Troubleshooting


$dire = "C:\"

function do-shit {
    param(
        [String] $FilePath #[mandatory:true]
        )
        Get-ChildItem -Path $FilePath -Recurse
 }

 do-shit($dire)

 gh *operator*

 Get-Service  | Format-wide name -Column 5

 Get-EventLog system | select -First 3 | Tee-Object -Variable $syslog
    Format-Table -Property entrytype,source,timegenerated, @{n="Generated how long ago: ";e={(Get-Date) - $_.TimeGenerated }; align='right';formatstring='dd\.hh\:mm\:ss'}
