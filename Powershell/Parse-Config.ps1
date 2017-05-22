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
    #parse-config
    PROCESS {
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
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Output "DETAILS:" $_.Exception.ErrorDetails
    
        }
   }
}
 
Write-Host "RUN_1" -BackgroundColor DarkRed
Parse-Config -ConfigurationFile "modules.xml"
 
Write-Host "RUN_2" -BackgroundColor DarkRed
Parse-Config -ConfigurationFile "C:\repos\HR\Powershell\conf\modules.xml"
 
Write-Host "RUN_3_WRITING_CONFIG_TO_VARIABLE" -BackgroundColor DarkRed
$computers = Parse-Config -ConfigurationFile "C:\repos\HR\Powershell\conf\modules.xml"
 
#new-config
#save-config (overwrite existing)
 
Write-Host "LOOPING_XML" -BackgroundColor DarkRed
Write-Host (Get-Content "C:\repos\HR\Powershell\conf\modules.xml")
 
foreach( $computer in $computers.configuration.computers.target)
{
    Write-Host $computer.name
} 