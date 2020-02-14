
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
#    'SQL', removed, redmine has its own instance now
    'Auth',
    'redmine',
#	'OpenStack', not atm!
	'ELK',
    'Admin',
    'PFSENSE'
)

Start-Northernlights -VirtualMachineName $northernlights