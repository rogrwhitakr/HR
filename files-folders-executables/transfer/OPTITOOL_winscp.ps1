
# the place where winscp lives
$env:WINSCP_PATH = 'C:\Program Files (x86)\WinSCP'

# add the dll to do...something
Add-Type -Path (Join-Path $env:WINSCP_PATH 'WinSCPnet.dll')

# Install
Install-Module -Name WinSCP -Scope CurrentUser

# Import
Import-Module -Name WinSCP

# Cmdlets
Get-Command -Module WinSCP

# start with a session
New-WinSCPSession -SessionOption

gh New-WinSCPSession -Full

$credential = Get-Credential
$hostname = 'u119042.your-storagebox.de'
$user = 'u119042'
$passwort = 'wVprfeRDpZP0x1Fp'

Get-ChildItem -path HKLM:\SOFTWARE\ -Recurse -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object {$_.ItemProperty -in "winscp"}
exit 0
$sshHostKeyFingerprint = "ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb"
$sessionOption = New-WinSCPSessionOption -HostName $hostname -SshHostKeyFingerprint $sshHostKeyFingerprint -Credential $credential
New-WinSCPSession -SessionOption $sessionOption