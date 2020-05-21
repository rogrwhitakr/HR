

$Path = "Y:\"
$Drive = "Y:\"
$x = new-object system.io.driveinfo($Drive)
$x.drivetype | Out-Null

If ($x.drivetype -eq "Network") {
    $currentDrive = Split-Path -qualifier (Get-childItem -path $Drive).Path
    $logicalDisk = Get-WmiObject Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$currentDrive'"
    $unc = $Drive.Path.Replace($currentDrive, $logicalDisk.ProviderName)
    $output = "`r`n`r`nThe UNC Path for " + $Drive + " is " + $unc
    $output
}


(Get-childItem -path $Drive).PSParentPath


if ([bool](![uri]$Path).IsUnc -and $Path -match '\w:\\') {
    "yey"
}
else {
    "ney"
    $currentDrive = Split-Path -qualifier (Set-Location -Path $Path).Path
    $logicalDisk = Get-WmiObject Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$currentDrive'"
    $unc = $Drive.Path.Replace($currentDrive, $logicalDisk.ProviderName)
    $output = "`r`n`r`nThe UNC Path for " + $Drive + " is " + $unc
    $output
}



#To collect mapped drives and it's path.
$MappedDrives = @{}
Get-WmiObject win32_logicaldisk -Filter 'drivetype=4' | ForEach-Object { $MappedDrives.($_.deviceID) = $_.ProviderName }

#The below samples add additional property called 'UncPath' to the output of Get-item and Get-ChildItem
Get-ChildItem P: | Select-Object *, @{n='UncPath'; e= { $_.FullName.Replace( $_.Root, $MappedDrives.($_.Root.ToString().SubString(0,2)) +'\') }}
Get-Item P:\2015\House | Select-Object *, @{n='UncPath'; e= { $_.FullName.Replace( $_.Root, $MappedDrives.($_.Root.ToString().SubString(0,2)) +'\') }}
