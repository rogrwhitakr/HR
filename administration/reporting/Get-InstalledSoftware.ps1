
$name = 'PostgreSQL'

$regkey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

$InstalledSoftware = Get-ChildItem $regkey 
foreach ($Software in $InstalledSoftware) {

#    Write-Host -message $Software.GetValue('DisplayName')
#    Write-Host -message $Software.GetValue('DisplayVersion')
#    Write-Host -message $Software.GetValue('Publisher')
    Where-Object { ($Software.GetValue('Publisher') -match $name) } |  Write-Host -message $Software.GetValue('Publisher')
#    Write-Host -message $Software.GetValue('Name')

    Where-Object { ($Software.GetValue('Publisher') -match $name) -or`
        ($Software.GetValue('Name') -match $name) -or`
        ($Software.GetValue('DisplayName') -match $name) } | Write-Host '>AYAYAYAYAYAY'
}

# new method, does take a while, not? restricted to win platform
Get-CimInstance -Class Win32_Product | Where-Object { ($_.vendor -match $name) -or ($_.name -match $name) }

# Check recently installed software list from the Event Log remotely
#Get-WinEvent -ProviderName msiinstaller | Where-Object {$_.id -eq 1033} | Select-Object timecreated,message | Format-List *