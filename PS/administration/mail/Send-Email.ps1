function Get-MailConfig {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf })]
        [string]$MailConfig
    )
    try {

        if ((Test-Path -Path $MailConfig) -eq $true) {
            [xml] $config = (Get-Content -Path (Resolve-Path -Path $MailConfig).ProviderPath)      
        }

        else {
            Write-Error -Message "No valid / resolvable MailConfig provided!!"
            Exit 1
        }

        if ($config) {
            $mailsettings = $config.Resource.'#text' | ConvertFrom-StringData

            if ($mailsettings) {
                $SmtpClient = New-Object -TypeName system.net.mail.smtpClient
                $SmtpClient.port = ($mailsettings.'mail.smtp.port')
                $SmtpClient.host = ($mailsettings.'mail.smtp.host')
                
                # how to define ?
                #$SMTPClient.EnableSsl = ($mailsettings.'mail.smtp.auth')
                $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($mailsettings.username, $mailsettings.password)

                return  $SmtpClient
            }
            else {
                Write-Error -Message "Failed to generate a valid Mail Server connection!!"
                $_ | Write-Error
                Exit 1
            }
        }
        else {
            Write-Error -Message "No valid / resolvable MailConfig provided!!"
            $_ | Write-Error
            Exit 1
        }
    }
    catch {
        $_ | Write-Error
    } 
}
# get mail settings
$MailConfig = "config\mailConfig.xml"

Get-MailConfig -MailConfig $MailConfig

#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


$params = @{
    To          = "rogrwitakr@northern-lights.one"
    From        = "notify01@northern-lights.one"
    Subject     = "send-MailMessage Test"
    Body        = "Mail Message test"
    SMTPServer  = "gateway.northern-lights.one"
    Port        = "25"
    Credential  = New-Object System.Net.NetworkCredential("notify@northern-lights.one","notify01")
    Attachments = ""
}

Send-MailMessage $params -UseSsl