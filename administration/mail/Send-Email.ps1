
$MailParams = @{
    To          = "rogrwitakr@northern-lights.one"
    From        = "notify01@northern-lights.one"
    Subject     = "send-MailMessage Test"
    Body        = "Mail Message test"
    SMTPServer  = "gateway.northern-lights.one"
    Port        = "25"
    UseSsl      = $false
    Credential  = New-Object System.Management.Automation.PSCredential -ArgumentList `
    ((ConvertTo-SecureString -string $values.'username' -AsPlainText -Force), `
        (ConvertTo-SecureString -string $values.'password' -AsPlainText -Force))
    Attachments = ""
}

Send-MailMessage @MailParams -Verbose