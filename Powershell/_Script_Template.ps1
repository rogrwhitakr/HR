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
$sLogPath = "C:\Windows\Temp"
$sLogName = "<script_name>.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

<#

Function <FunctionName>{
  Param()
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
  }
  
  Process{
    Try{
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

#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
#Script Execution goes here
#Log-Finish -LogPath $sLogFile


function Get-Something { 
  <# 
  .SYNOPSIS 
  Describe the function here 
  .DESCRIPTION 
  Describe the function in more detail 
  .EXAMPLE 
  Give an example of how to use it 
  .EXAMPLE 
  Give another example of how to use it 
  .PARAMETER computername 
  The computer name to query. Just one. 
  .PARAMETER logname 
  The name of a file to write failed computer names to. Defaults to errors.txt. 
  #> 
  [CmdletBinding()] 
  param 
  ( 
    [Parameter(Mandatory=$True, 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True, 
      HelpMessage='What computer name would you like to target?')] 
    [Alias('host')] 
    [ValidateLength(3,30)] 
    [string[]]$computername, 
         
    [string]$logname = 'errors.txt' 
  ) 
 
  begin { 
  write-verbose "Deleting $logname" 
    del $logname -ErrorActionSilentlyContinue 
  } 
 
  process { 
 
    write-verbose "Beginning process loop" 
 
    foreach ($computer in $computername) { 
      Write-Verbose "Processing $computer" 
      # use $computer to target a single computer 
     
 
      # create a hashtable with your output info 
      $info = @{ 
        'info1'=$value1; 
        'info2'=$value2; 
        'info3'=$value3; 
        'info4'=$value4 
      } 
      Write-Output (New-Object –TypenamePSObject –Prop $info) 
    } 
  } 
}