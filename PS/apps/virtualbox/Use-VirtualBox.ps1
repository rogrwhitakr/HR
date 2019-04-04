Function Use-Virtualbox {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Action")] 
        [ValidateSet("Start", "Stop", "Pause", "Resume", "Reset")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "Virtual Machine Name")] 
        [ValidateNotNullOrEmpty()]     
        $VirtualMachine,

        [Switch]
        [Parameter(Mandatory = $false)]
        $Headless

    )

    BEGIN {

        try {
            # first we get the backup tool
            $tool = Find-Executable -Executable "VBoxManage.exe"
            Write-Verbose "${Method} VirtualBox VMs using $tool"
        
        }

        catch {

            Write-Error "An Error occurred. Please assign the Path to the Executable VBoxManage.exe manually"
            Write-Error $_.Exception.Message
            Write-Error $_.Exception.Details

        }
    }

    PROCESS {

        switch ($Method) { 
            Start {
                if ( $Headless -eq $true ) {
                    Start-Process -FilePath $tool -ArgumentList 'startvm', $VirtualMachine , '--type', 'headless' 
                }
                else {
                    Start-Process -FilePath $tool -ArgumentList 'startvm', $VirtualMachine
                }
            } 
            
            Stop {
                Start-Process -FilePath $tool -ArgumentList 'controlvm', $VirtualMachine , 'poweroff'
            } 
            
            Pause {
                Start-Process -FilePath $tool -ArgumentList 'controlvm', $VirtualMachine , 'savestate'
            } 
            
            Resume {
                Start-Process -FilePath $tool -ArgumentList 'controlvm', $VirtualMachine , 'resume'
            
            } 
            Reset {
                Start-Process -FilePath $tool -ArgumentList 'controlvm', $VirtualMachine , 'reset'
            
            }                  
            default {
                Write-Warning "No method selected."
                exit 1
            }
        }
    }
}

Use-Virtualbox -Method Stop -VirtualMachine "dnsmasq" -verbose
Use-Virtualbox -Method Start -VirtualMachine "dnsmasq" -Verbose