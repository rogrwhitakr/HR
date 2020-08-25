# startup / shutdown script 
# to manage virtal machines
# using the Virualbox CMDLETs from 
# https://github.com/jdhitsolutions/PSVirtualBox

Import-Module -Name PSVirtualBox 

function Stop-Northernlights {

    $vms = Get-VBoxMachine

    foreach ($vm in $vms) {
        Suspend-VBoxMachine -Name $vm.ID -Verbose
    }
}

Stop-Northernlights