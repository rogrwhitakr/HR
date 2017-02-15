#requires -version 2
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
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. "C:\Scripts\Functions\Logging_Functions.ps1"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Log File Info
$sLogPath = "$USERPROFILE\Desktop\Logs"
$sLogName = "VirtualBox.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#virtualboxcmd
$virtualbox = $VBOX_MSI_INSTALL_PATH

#-----------------------------------------------------------[Functions]------------------------------------------------------------



function Get-VirtualBox{
  
  Param(

    [Parameter(Mandatory=$true)][String] $
  
  )
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
    cd $vb
    cmd /c "VBoxManage.exe list runningvms"
  }
  
  Process{
    Try{
        Set-Location $VBOX_MSI_INSTALL_PATH.drive
        Set-Location $virtualbox.drive
      <code goes here>
    }
    
    Catch{
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
      Log-Write -LogPath $sLogFile -LineValue " "
    }
  }
}



#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
#Script Execution goes here
#Log-Finish -LogPath $sLogFile