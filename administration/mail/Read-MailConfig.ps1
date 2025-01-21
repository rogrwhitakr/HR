# read a xml encoded mail config
# and extract ist values to a return object containing smtp server valuez

# path of the config

$config = "$PSScriptRoot\mailConfig.xml"

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
$config = Read-XMLConfig -ConfigurationFile $config 

# the OT config is *special*
[system.string]$stringdata = $config.ChildNodes.'#text'

# convert to parsed data that can be used
$values = ConvertFrom-StringData -StringData $stringdata

Write-Host "RUN_2" -BackgroundColor DarkRed

$MailParams = @{
    From       = $values.'mail.smtp.from'
    To         = 'user@company.de'
    Subject    = 'Testmail'
    Body       = 'also testmail'
    SMTPServer = $values.'mail.smtp.host'
    Port       = $values.'mail.smtp.port'
    UseSsl     = if ($values.'mail.smtp.port' -ne '25') { $true } else { $false }
    Credential = New-Object System.Management.Automation.PSCredential -ArgumentList `
    ((ConvertTo-SecureString -string $values.'username' -AsPlainText -Force), `
        (ConvertTo-SecureString -string $values.'password' -AsPlainText -Force))
}

try {
    Send-MailMessage @MailParams -Verbose
}
catch {
    $_ | Write-Error
}
