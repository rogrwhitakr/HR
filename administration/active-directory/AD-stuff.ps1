
# Find local User Profiles 

$selected = Get-CimInstance -ClassName Win32_UserProfile -Filter "Special=False" | Add-Member -MemberType ScriptProperty -Name UserName -Value { (New-Object System.Security.Principal.SecurityIdentifier($this.Sid)).Translate([System.Security.Principal.NTAccount]).Value } -PassThru | Out-GridView -Title "Select User Profile" -OutputMode Single
$selected 
