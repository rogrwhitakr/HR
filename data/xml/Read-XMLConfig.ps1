
# this is a demo this, not really usable
# *****************************************************************************************************************
function Read-XMLConfig {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $ConfigurationFile
            
    )

    #Variables

    $cfg = $ConfigurationFile 
    $cfg_dir = "config"

    #Read-XMLConfig
    

    try {
        
        if ((Test-Path -Path $cfg) -eq $true) {

            $config = [xml] ( Get-Content -Path $cfg )

            Write-Host "Parsing configuration file "$cfg.ToString()
            return $config

        }
        
        else {

            Write-Output "using configuration file $cfg"
            Write-Output "searching directory $PSScriptRoot\$cfg_dir for configuration file..."

            $file = (Join-Path -Path $PSScriptRoot.ToString() -ChildPath (Join-Path -Path $cfg_dir -ChildPath $cfg) )

            if ((Test-Path -Path $file) -eq $true) {

                $config = [xml] ( Get-Content -Path $file )

                Write-Host "Parsing "$file.ToString()
                return $config

            }

            else {

                Write-Output "Could not find configuration file "$file

            }
        }
    }
    catch {

        $ErrorMessage = $_.Exception.Message
        # *****************************************************************************************************************
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Output "DETAILS:" $_.Exception.ErrorDetails

    }
}


Write-Host "RUN_1" -BackgroundColor DarkRed
Read-XMLConfig -ConfigurationFile "virtual-machines.xml"

Write-Host "RUN_2" -BackgroundColor DarkRed
Read-XMLConfig -ConfigurationFile "C:\MyScripts\Windows\PS\config\virtual-machines.xml"

Write-Host "RUN_3_WRITING_CONFIG_TO_VARIABLE" -BackgroundColor DarkRed
$computers = Read-XMLConfig -ConfigurationFile "C:\MyScripts\Windows\PS\config\virtual-machines.xml"

#new-config
#save-config (overwrite existing)

Write-Host "LOOPING_XML" -BackgroundColor DarkRed
$config = [xml] ( Get-Content -Path C:\MyScripts\Windows\PS\config\virtual-machines.xml )

$a = 1

foreach( $computer in $computers.configuration.computers.target) 
{ 

    Write-Host $computer.name
    Write-Host "`n"$a -BackgroundColor Yellow -ForegroundColor Black
    $a = $a + 1
} 

# *****************************************************************************************************************

# xml cmdlets:
# Import-CliXml, Export-CliXml, ConvertTo-Xml

$xml = Import-Clixml -Path "C:\MyScripts\northern-lights\CONF\User\user-profiles.xml"

$xml

gh Import-Clixml