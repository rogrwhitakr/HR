# startup / shutdown script 
# to manage virtal machines
# using the Virualbox CMDLETs from 
# https://github.com/jdhitsolutions/PSVirtualBox

# todo
# move these to a config file, maybe?

$northernlights = @(
    'dns',
    'server',
    'DNS-Server',
    'Mail-Server',
    'ubuntu-server',
    'SMB-Server',
    'dnsmasq',
    'powershell-core',
    'Admin',
    'smba'
)

$northernlights = @(
    'DNS-Server',
    'server',
    'Admin',
    'powershell-core'
)

function VM-StartUp {
    
    [CmdletBinding()]
    param (

        [Array]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Name of VirtualBox VM")] 
        $VirtualMachineName
    )

    foreach ($light in $northernlights) {
        Start-VBoxMachine -Name $light -Headless
        Start-Sleep -Verbose -Seconds 2
    }
    
}

VM-StartUp -VirtualMachineName $northernlights

function VM-Shutdown {

    $vms = Get-VBoxMachine

    foreach ($vm in $vms) {
        Stop-VBoxMachine -Name $vm.ID -Verbose
    }
}

VM-Shutdown