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
  Author:         rogrwitakr
  Creation Date:  2017-02-20
  Purpose/Change: Initial script development
 
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
 
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
 
#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
 
 
#----------------------------------------------------------[Declarations]----------------------------------------------------------

function Get-WinSCP {

    try {
        $tool = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath ( Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "WinSCP.com" -Recurse  ) 
        $dll = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath ( Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "WinSCPnet.dll" -Recurse  ) 
        
        if (((Test-Path $tool ) -ne $true ) -or ((Test-Path $dll) -ne $true )) {
            $tool = 'assign the path to executable manually'
            $dll = 'assign the path to dll manually'
        }           
        Write-Output "Tool:$tool"
        Write-Output "Dll :$dll"
    }

    catch {
    
        $ErrorMessage = $_.Exception.Message
        Write-Output "An Error occurred. Please assign the Path to the Executable."
        Write-Output $ErrorMessage
    
    }

}

Get-WinSCP

#----------------------------------------------------------[WinSCP]----------------------------------------------------------
#
#   TODO: incorporate into Get-WinSCP


$tool = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath ( Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "WinSCP.com" -Recurse  ) 
        $dll = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath ( Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "WinSCPnet.dll" -Recurse  ) 
 

 Start-Process -FilePath $tool -WindowStyle Maximized
 
 Get-ChildItem hklm:\software | `
    ForEach-Object {
        Get-ItemProperty $_.pspath| Select-Object *
    }



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
 
 
Add-Type -Path $dll
 
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "192.168.150.254"
    UserName = "Administrator"
    Password = "vasques"
    SshHostKeyFingerprint = "SHA256:QDC6jbMl9Sxzp95nz2qzbn/W6lL6lWM+QT/66qartQY"
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
The authenticity of host '192.168.150.254 (192.168.150.254)' can't be established.
ECDSA key fingerprint is SHA256:QDC6jbMl9Sxzp95nz2qzbn/W6lL6lWM+QT/66qartQY.
ECDSA key fingerprint is MD5:5c:fc:1b:24:1b:f0:44:56:6d:ba:05:5c:f4:d3:fd:44.
