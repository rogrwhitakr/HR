# read a xml encoded mail config
# and extract ist values to a return object containing smtp server valuez

# path of the config

$config = "$PSScriptRoot\mailConfig.xml"

$config 


# this is a demo this, not really usable
# *****************************************************************************************************************
function Read-XMLConfig {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        $ConfigurationFile
            
    )

    $cfg = $ConfigurationFile 

    try {
        if ((Test-Path -Path $cfg) -eq $true) {
            $config = [xml] ( Get-Content -Path $cfg )
            return $config
        }   
        else {
            Write-Warning -Message ("Could not find or read configuration file {0}" -f $file)
            return 
        }
    }
    catch {

        $ErrorMessage = $_.Exception.Message
        Write-Error "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Error "DETAILS:" $_.Exception.ErrorDetails

    }
}


Write-Host "RUN_1" -BackgroundColor DarkRed
Read-XMLConfig -ConfigurationFile "modules.xml"
Read-XMLConfig -ConfigurationFile "C:\repos\HR\data\xml\modules.xml"
