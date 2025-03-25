
# new method, does take a while, not? restricted to win platform
Get-CimInstance -Class Win32_Product | Where-Object { ($_.vendor -match $name) -or ($_.name -match $name) }

# get all installed via registry
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*

# look for a specific software
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "*notepad*"}

# more display sthingy
$regkey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$InstalledSoftware = Get-ChildItem $regkey 

foreach ($Software in $InstalledSoftware) {
    Write-Host -message $Software.GetValue('DisplayName')
    $Software
}
