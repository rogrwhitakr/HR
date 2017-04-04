#requires -version 5
<#
.SYNOPSIS
  <Overview of script>
 
.DESCRIPTION
  <Brief description of script>
 
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
 
.INPUTS
  <Inputs if any, otherwise state None>
 
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
 
.NOTES
  Version:        1.0
  Author:         Benno Osterholt
  Creation Date:  2017-02-20
  Purpose/Change: Initial script development
 
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
 
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
 
#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
 
#Dot Source required Function Libraries
. "C:\Scripts\Functions\Logging_Functions.ps1"
 
#param (
  #  $localPath = "C:\OT_Kunden"
#   $remotePath = "/home/user/"
#)
 
#----------------------------------------------------------[Declarations]----------------------------------------------------------
 
$winscppath = "C:\Program Files\WinSCP\"
$winscpnet = "WinSCPnet.dll"
 
#check if WinSCPnet.dll is available
 
$dll = $winscppath + $winscpnet
 
if ( ( Test-Path $dll ) -eq $false ) {
 
    $url = "https://winscp.net/download/WinSCP-5.9.4-Automation.zip"
   
    try {
        Invoke-WebRequest -Uri $url -Verbose
        Start-Sleep -Seconds "30"
        $file = $env:USERPROFILE + "\" + (Get-ChildItem -Path $env:USERPROFILE -Name "aWinSCP-5.9.4-Automation.zip" -Recurse)
        $file = (Get-ChildItem -Path $env:USERPROFILE -Name "aWinSCP-5.9.4-Automation.zip" -Recurse).FullName
 
        $Overwrite = $true
         
        Expand-Archive -Path $file -DestinationPath $winscppath -Force:$Overwrite
 
        $ShowDestinationFolder = $true 
        if ($ShowDestinationFolder)
        {
          explorer.exe $Destination
        }
 
#        Move-Item ($file) -Destination $winscppath -Verbose -Force
    }
 
    catch [Exception] {
        Write-Output $_.Exception.Message
    }
}
 
else {
    Write-Output "found $winscpnet in $winscppath"
}
#----------------------------------------------------------[WinSCP]----------------------------------------------------------
 
 
    $url = "https://winscp.net/download/WinSCP-5.9.4-Automation.zip"
Select-String -InputObject $url -Pattern "*.zip"
 
#----------------------------------------------------------[WinSCP]----------------------------------------------------------
 
gci env: | Where-Object -Property Path | select -ExpandProperty value
 
Add-Type -Path $dll
 
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "192.168.100.179"
    UserName = "admin"
    Password = "asder123"
    SshHostKeyFingerprint = "ssh-ed25519 256 8c:fa:83:63:4d:aa:b6:06:6c:44:0b:ab:af:ce:bd:bd"
}
 
$session = New-Object WinSCP.Session
 
#try {
    $session.Open($sessionOptions)
    # Get list of files in the directory
    $directoryInfo = $session.ListDirectory("/home/admin/MyScripts")
    Write-Output $directoryInfo
    pause
    # Ihr Code
}
 
catch [Exception] {
    Write-Output ("Error: {0}" -f $_.Exception.Message)
#    exit 1
}
 
finally {
    $session.Dispose()
 
 #   exit 0
}