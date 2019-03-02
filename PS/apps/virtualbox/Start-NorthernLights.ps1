
Import-Module -Name PSVirtualBox 

function Start-Northernlights {
    
    [CmdletBinding()]
    param (

        [Array]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Name of VirtualBox VM")] 
        $VirtualMachineName
    )

    foreach ($machine in $VirtualMachineName) {
        Start-VBoxMachine -Name $machine -Headless
        Start-Sleep -Verbose -Seconds 2
    }
    
}

$northernlights = @(
    'DNS-Server',
    'server',
    'powershell-core'
)

Start-Northernlights -VirtualMachineName $northernlights