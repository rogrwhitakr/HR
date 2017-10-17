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
'Admin'
)

function VM-StartUp {

    foreach ($light in $northernlights) {
        Start-VBoxMachine -Name $light -Headless -Verbose
        Start-Sleep -Verbose -Seconds 2
    }
    
}

function VM-Shutdown {

    $vms = Get-VBoxMachine

    foreach ($vm in $vms) {
        Stop-VBoxMachine -Name $vm.ID -Verbose
    }
}
