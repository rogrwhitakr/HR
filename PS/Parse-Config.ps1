function Parse-Config {
 
    [CmdletBinding()]
    param
        (
        [String]
        [Parameter( Mandatory=$true, ValueFromPipeline = $true)]
        $ConfigurationFile          
        )
 
    BEGIN {
 
    $cfg = $ConfigurationFile
    $cfg_dir = "conf"
    
    }

    PROCESS {
        try {
       
            if ((Test-Path -Path $cfg) -eq $true) {
 
                $config = [xml] ( Get-Content -Path $cfg )
                return $config
 
            }
       
            else {
 
                $file = (Join-Path -Path $PSScriptRoot.ToString() -ChildPath (Join-Path -Path $cfg_dir -ChildPath $cfg) )
 
                if ((Test-Path -Path $file) -eq $true) {
 
                    $config = [xml] ( Get-Content -Path $file )
                    return $config
 
                }
 
                else {
 
                    Write-Output "Could not find configuration file "$file
 
                }
            }
        
   }
 
    catch {
 
        $ErrorMessage = $_.Exception.Message
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Output "DETAILS:" $_.Exception.ErrorDetails
    
        }
   }
}

Clear
 
Write-Host "RUN_1" -BackgroundColor DarkRed
$VirtualBox = Parse-Config -ConfigurationFile "C:\Users\HaroldFinch\.VirtualBox\VirtualBox.xml"

Write-Host "RUN_2" -BackgroundColor DarkRed
$customConfig = Parse-Config -ConfigurationFile "computers.xml"
 
Write-Host "RUN_3_WRITING_CONFIG_TO_VARIABLE" -BackgroundColor DarkRed
$computers = Parse-Config -ConfigurationFile "C:\repos\HR\PS\conf\modules.xml"

Write-Host "CustomConfig" -BackgroundColor Green
Write-Host $customConfig.Attributes

Write-Host "VirtualBox" -BackgroundColor Green 
Write-Host $VirtualBox.VirtualBox.Global.MachineRegistry.MachineEntry.uuid
Write-Host $VirtualBox.VirtualBox.Global.SystemProperties.defaultMachineFolder

#new-config
#save-config (overwrite existing)
 
Write-Host "LOOPING_XML" -BackgroundColor DarkRed

foreach( $computer in $customConfig.Computers.VMs.ChildNodes )
{
    Write-Host $computer.Name
} 

function Get-ScriptPath {
	$scriptDir = Get-Variable PSScriptRoot -ErrorAction SilentlyContinue | ForEach-Object { $_.Value }
	if (!$scriptDir) {
		if ($MyInvocation.MyCommand.Path) {
			$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
		}
	}
	if (!$scriptDir) {
		if ($ExecutionContext.SessionState.Module.Path) {
			$scriptDir = Split-Path (Split-Path $ExecutionContext.SessionState.Module.Path)
		}
	}
	if (!$scriptDir) {
		$scriptDir = $PWD
	}
	return $scriptDir
}

$customConfig.PowerShell.Modules.Module.File | Get-Member | Select-Object * | Format-List

$customConfig.PowerShell.GetAttribute('name').ToString() | gm



function gn {
    [CmdletBinding()]
    param (
        [parameter(
        valuefrompipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [System.Object]$Object
        )
try {
    $obj = $Object
    $gm = $obj | Get-Member
    $select = $gm | Select-Object *
    $list = $select | Format-List
    return $list
    }
    catch {
 
        $ErrorMessage = $_.Exception.Message
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Output "DETAILS:" $_.Exception.ErrorDetails
    
        }

}

get-help | gn