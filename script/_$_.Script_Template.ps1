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

#Dot Source required Function Libraries
. "C:\Scripts\Functions\Logging_Functions.ps1"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

TODO = Logging standardised

#Script Version
$ScriptVersion = "1.0"

Start-Transcript -Path $ScriptVersion


#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function new-Params {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")] 
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
        [ValidateScript({Test-Path $_ })]
        $Path,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)] 
        [ValidateScript({Test-Path $_ -include *.zip,*.7z})]
        $Archive,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    BEGIN {

        try {
        
            # DO SOMETHING     
        
        }

        catch {

            # CATCH ERROR

            $ErrorMessage = $_.Exception.Message
            Write-Log -Path $logfile -Level Error -Message 'An Error occurred. Please assign the Path to the Executable 7zip.'
            Write-Log -Path $logfile -Level Error -Message $ErrorMessage

        }
    }

    PROCESS {

        switch ($Method) 
            { 
                Add {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' to ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path
                } 
                
                Delete {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' from ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path
                } 
                
                Extract {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' from ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'x', '-mx9','-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized
                } 
                
                Test {
                    Start-Process -FilePath $tool -ArgumentList 't', '-mx9','-scsUTF-8 ', $archive

                } 
                Update {
                    Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path

                } 
                default {
                    Write-Log -Path $logfile -Level Warn -Message 'No Method selected!'
                }
            }
    }
}

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
    Remove-Item $logname -ErrorActionSilentlyContinue 
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
      Write-Output (New-Object �TypenamePSObject �Prop $info) 
    } 
  } 
}

########################################################################################################
# switch statement
########################################################################################################
[string]$operator

switch ($calc){
    {$calc.TotalDays -ge 1} {$operator = "Days";break;}
    {$calc.TotalHours -ge 1} {$operator = "Hours";break;}
    {$calc.TotalMinutes -ge 1} {$operator = "Minutes";break;}
    {$calc.TotalSeconds -ge 1} {$operator = "Seconds"; break;}
}

# making a pro forma new line operator
$ofs = [Environment]::NewLine
'using variables like so: {0}{1}{2}{3}{4}{5}{6}{7}' -f $ofs,$andere,$ofs,$template,$ofs,$in,$ofs,$out
