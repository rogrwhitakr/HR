
# module Hyper-V should be installed:
Get-Command -Module 'Hyper-V'

$VMs = @('Kanboard', 'HankScorpio')

Get-VM -Name $VMs

# get all
Get-VM

# get all running ones
'running VMs:'
Get-VM | Where-Object {$_.State -eq 'Running'}

'if vms are not on, we turn dem on'
foreach ($VM in $VMs) {
    'VM {0}: State: {1} Status: {2}' -f $VM, (Get-VM -Name $VM | Select-Object State).State, (Get-VM -Name $VM | Select-Object Status).Status
    if (Get-VM -Name $VM | Where-Object {$_.State -ne 'Running'}) {
        'starting VM {0}' -f $VM
        Start-VM -VM (Get-VM -Name $VM)
        'Started VM {0}, Status: {1}' -f $VM, (Get-VM -Name $VM | Select-Object Status).Status
    }
}