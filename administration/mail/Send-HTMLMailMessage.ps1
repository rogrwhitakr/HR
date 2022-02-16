
# das hier hat funktioniert!!!!

$date = (Get-Date -Format yyyy-MM-dd_HH:mm)


#  Preparing the Email properties
$SmtpClient = New-Object -TypeName system.net.mail.smtpClient
$SmtpClient.port="25"
$SmtpClient.host="10.10.10.2"

$MailMessage = New-Object -TypeName system.net.mail.mailmessage
$MailMessage.from = "northern-lights.production@northern-lights.one"
$MailMessage.To.Add("rogrwitakr@northern-lights.one")

#  Encoding
$EmailEncoding = 'ASCII'
$MailMessage.BodyEncoding = [System.Text.Encoding]::$EmailEncoding
$MailMessage.SubjectEncoding = [System.Text.Encoding]::$EmailEncoding

$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = 'PS-Test'
$MailMessage.Body = "this is a powershell mail send test, sent at $date"

#  Sending the Email
$SmtpClient.Send($MailMessage)