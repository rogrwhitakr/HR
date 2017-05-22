Function Use-Virtualbox {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Action")] 
        [ValidateSet("Start", "Stop", "Pause", "Resume", "Reset", "List", "ListRunningVMs")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "Virtual Machine Name")] 
        [ValidateNotNullOrEmpty()]     
        $VirtualMachine,

        [Switch]
        [Parameter(Mandatory=$false)]
        $Headless

        )

    BEGIN {

        try {
        
            $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name ".\VBoxManage.exe" -Recurse  )     
            Write-Output $Method"ing VirtualBox VMs using VBoxManage"
        
        }

        catch {

            Write-Output "An Error occurred. Please assign the Path to the Executable VBoxManage.exe manually"
            Write-Output $_.Exception.Message
            Write-Output $_.Exception.Details

        }
    }

    PROCESS {

        switch ($Method) { 
            Start {
                if ( $Headless -eq $true ) {
                    Start-Process -FilePath $tool -ArgumentList 'startvm', $VirtualMachine , '--type', 'headless' -NoNewWindow
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
            List {
                Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path
            
            } 
            ListRunningVMs {
                Start-Process -FilePath $tool -ArgumentList 'list', 'runningvms', '-l'
            
            } 
            default {
                Write-Output "No method selected."
                exit 1
            }
        }
    }
}