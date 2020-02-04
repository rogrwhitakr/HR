
# das hier hat funktioniert!!!!

$date = (Get-Date -Format yyyy-MM-dd_HH:mm)


#  Preparing the Email properties
$SmtpClient = New-Object -TypeName system.net.mail.smtpClient
$SmtpClient.port="25"
$SmtpClient.host="10.194.251.20"

$MailMessage = New-Object -TypeName system.net.mail.mailmessage
$MailMessage.from = "northern-lights.ce.production@northern-lights.com"
$MailMessage.To.Add("rogrwitakr@northern-lights.com")

#  Encoding
$EmailEncoding = 'ASCII'
$MailMessage.BodyEncoding = [System.Text.Encoding]::$EmailEncoding
$MailMessage.SubjectEncoding = [System.Text.Encoding]::$EmailEncoding

$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = 'PS-Test'
$MailMessage.Body = "this is a powershell mail send test, sent at $date"

#  Sending the Email
$SmtpClient.Send($MailMessage)