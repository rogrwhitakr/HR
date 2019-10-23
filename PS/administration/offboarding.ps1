<# .NOTES ===========================================================================
Created with: SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
Created on: 04/11/2016 21:00
Created by: Maurice Daly
Filename: DisableUserOffice365.ps1 ===========================================================================
.DESCRIPTION
This script provides a standard off-boarding method for staff leaving
the company.
 
The script does the following;
1. Disables the specified user account
2. Updates the user description with the user who disabled the account
and the time/date when the account was disabled
3. Moves the account to the disabled user account OU (needs to exist)
4. Sets an out of office reply stating that the employee has left the company
5. Disables activesync, pop3, imap etc
6. Places mail account into legal hold for 7 years (requires Office 365 E3)
7. Hides the mail account from the GAL
8. Emails the former employee's manager advising that the account has been disabled
 
Version 1.0
Initial release
 
Use : This script is provided as it and I accept no responsibility for
any issues arising from its use.
 
Twitter : @modaly_it
Blog : https://modalyitblog.wordpress.com/
#>
 
Write-Host " **************** PLEASE ENTER ACTIVE DIRECTORY ADMIN CREDENTIALS **************** "
$Credential = Get-Credential -Credential "$env:DOMAIN\$env:username"
$DC = $env:LOGONSERVER.Substring(2)
 
#Initiate Remote PS Session to local DC
$ADPowerShell = New-PSSession -ComputerName $DC -Authentication Negotiate -Credential $Credential
 
# Import-Module ActiveDirectory
write-host "Importing Active Directory PowerShell Commandlets"
Invoke-Command -Session $ADPowerShell -scriptblock { import-module ActiveDirectory }
Import-PSSession -Session $ADPowerShell -Module ActiveDirectory -AllowClobber -ErrorAction Stop
 
# Retrieve AD Details
$ADDetails = Get-ADDomain
$Domain = $ADDetails.DNSRoot
Clear-Host
 
write-host "Importing Office 365 PowerShell Commandlets"
Write-Host -ForegroundColor White -BackgroundColor DarkBlue " **************** PLEASE ENTER OFFICE 365 ADMIN CREDENTIALS **************** "
$Office365Credential = Get-Credential
$Office365PowerShell = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Office365Credential -Authentication Basic -AllowRedirection
Import-PSSession $Office365PowerShell
Clear-Host
 
write-host " **************** Disable Active Directory User Account & Enable Out Of Office **************** "
write-host " "
 
# Get Variables
$DisabledDate = Get-Date
$LeaveDate = Get-Date -Format "dddd dd MMMM yyyy"
$DisabledBy = Get-ADUser "$env:username" -properties Mail
$DisabledByEmail = $DisabledBy.Mail
 
# Prompt for AD Username
$Employee = Read-Host "Employee Username"
$EmployeeDetails = Get-ADUser $Employee -properties *
If ($EmployeeDetails.Manager -ne $null) {
    $Manager = Get-ADUser $EmployeeDetails.Manager -Properties Mail
}
 
Clear-Host
 
# Prompt for confirmation
write-host " ******************************** CONFIRM USER DISABLE REQUEST ******************************** "
write-host " "
write-host -ForegroundColor Yellow "Please review the Employee details below to ensure you are disabling the correct user account."
$EmployeeDetails | Format-List Name, Title, Company, @{ Expression = { $_.mail }; Label = "Email Address" }, @{Expression = { $_.Created }; Label = "Employment Started"}
 
$choice = " "
while ($choice -notmatch "[y|n]") {
    $choice = read-host "Do you want to continue? (Y/N)"
}
 
# Actions
if ($choice -eq "y") {
    Clear-Host
    write-host " ******************************** DISABLING USER ACCOUNT ******************************** "
    write-host " "
    write-host "Step1. Modifying user description for audit purposes" -ForegroundColor Yellow
    Set-ADUser $Employee -Description "Disabled by $($DisabledBy.name) on $DisabledDate"
    write-host "Step2. Disabling $Employee Active Directory Account." -ForegroundColor Yellow
    Disable-ADAccount $Employee
    Remove-ADPrincipalGroupMembership -Identity  $Employee -MemberOf $ADgroups -Confirm:$false
    write-host "Step3. Moving $Employee to the Disabled User Accounts OU." -ForegroundColor Yellow
    write-host " "
    Move-ADObject -Identity $EmployeeDetails.DistinguishedName -targetpath "OU=Disabled Users,DC=DOMAIN,DC=local"
    write-host "Waiting 5 seconds for AD & Exchange OU update to complete"
    Start-Sleep -Seconds 5
    write-host " "
    write-host "Refreshing Employee Details for Exchange Modification."
    write-host " "
    Get-ADUser $Employee -Properties Description | Format-List Name, Enabled, Description
    write-host "Step 4. Setting Exchange Out Of Office Auto-Responder." -ForegroundColor Yellow
    Set-MailboxAutoReplyConfiguration -Identity $EmployeeDetails.Mail -AutoReplyState enabled -ExternalAudience all -InternalMessage "Please note that I no longer work for COMPANY as of $LeaveDate." -ExternalMessage "Please note that I no longer work for COMPANY as of $LeaveDate."
    Write-Host "Step 5. Disabling POP,IMAP, OWA and ActiveSync access for $User" -ForegroundColor Yellow
    Set-CasMailbox -Identity $EmployeeDetails.mail -OWAEnabled $false -POPEnabled $false -ImapEnabled $false -ActiveSyncEnabled $false
    Write-Host "Step 6. Hiding $($EmployeeDetails.name) from Global Address lists" -ForegroundColor Yellow
    Set-ADUser -identity $Employee -add @{ msExchHideFromAddressLists = "True" }
    Set-ADUser -instance $EmployeeDetails -whatif
    If ($Manager.Mail -like "*@*") {
        Write-Host "Step 7. Sending Confirmation E-mail To Employee's Manager." -ForegroundColor Yellow
        $msg = new-object Net.Mail.MailMessage
        $smtp = new-object Net.Mail.SmtpClient("DOMAIN.mail.protection.outlook.com")
        $msg.From = "itservicedesk@COMPANY.com"
        $msg.To.Add("$($Manager.Mail)")
        $msg.subject = "IT Notification - Employee Leaving Confirmation"
        $msg.body = "This email is confirm that $($EmployeeDetails.Name)'s account has been disabled. An out of office notification advising that $($EmployeeDetails.Name) has left the company has also been set. Note that the account will be deleted after 30 days. Should you require access to $($EmployeeDetails.Name) email account or personal drive, please contact the IT Service Desk."
        $smtp.Send($msg)
    }
}
else {
    write-host " "
    write-host "Employee disable request canceled" -ForegroundColor Yellow
}