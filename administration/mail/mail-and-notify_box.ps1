
#  Preparing the Email properties
$SmtpClient = New-Object -TypeName system.net.mail.smtpClient
$SmtpClient.port="25"
$SmtpClient.host='gateway.northern-lights.one'
$SmtpClient.Credentials = New-Object System.Net.NetworkCredential('notify@northern-lights.one','notify01')

$MailMessage = New-Object -TypeName system.net.mail.mailmessage
$MailMessage.from = 'notify01@northern-lights.one'
$MailMessage.To.Add('rogrwitakr@northern-lights.one')

#  Encoding
$EmailEncoding = 'ASCII'
$MailMessage.BodyEncoding = [System.Text.Encoding]::$EmailEncoding
$MailMessage.SubjectEncoding = [System.Text.Encoding]::$EmailEncoding

$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = '{0} !!! TIME TO GO !!!' -f (Get-Date).DateTime
$MailMessage.Body = '{0} !!! TIME TO GO !!!' -f (Get-Date).DateTime

#  Sending the Email
$SmtpClient.Send($MailMessage)

# pop-up box
function Pop-Up {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $PopUp
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($PopUp, [System.Windows.Forms.MessageBoxButtons]::OK)
}

Pop-Up -PopUp ('TIME TO GO !!!{1}Es ist {0} !!!' -f (Get-Date).DateTime, [Environment]::NewLine)

# yes no message box
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Do you want to restart?','Restart','YesNo','Warning')
