function Backup-SMBShare {
    $log = 
    $online = Test-Connection -ComputerName Reese -ErrorAction write

}

Backup-SMBShare 


####################################################################################################
####################################################################################################


Get-ChildItem env:

$env:OPTITOOL = "D:\OPTITOOL"

Set-Location $env:OPTITOOL

Set-Location $env:HOMEPATH

gc $env:HOMEPATH