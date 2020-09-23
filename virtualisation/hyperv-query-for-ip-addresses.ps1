# we must be administrator

# get local vms
Get-VM

# get the names of running vms
(Get-VM | Where-Object {$_.State -eq "running"}).Name

# get the ip adresses
Get-VM | Where-Object {$_.State -eq "running"} | Select-Object -ExpandProperty Networkadapters | Select-Object IPAddresses

Write-Host "-----------------------------------"

# as vars
[array]$IPs = Get-VM | Where-Object {$_.State -eq "running"} | Select-Object -ExpandProperty Networkadapters | Select-Object IPAddresses

$IPs.Length
