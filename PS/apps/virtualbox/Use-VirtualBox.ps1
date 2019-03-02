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
                Write-Output "No method selected."
                exit 1
            }
        }
    }
}

Use-Virtualbox -Method Stop -VirtualMachine gnome

$tool | gm
$loc = gci $tool

(Get-ChildItem -Path $tool).DirectoryName

Set-Location $loc.DirectoryName

# Setup the Process startup info
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = ".\VBoxManage.exe"
$pinfo.Arguments = "list vms"
$pinfo.WorkingDirectory = (Get-ChildItem -Path $tool).DirectoryName

$pinfo.UseShellExecute = $false
$pinfo.CreateNoWindow = $false
$pinfo.RedirectStandardOutput = $true
$pinfo.RedirectStandardError = $true

 # Create a process object using the startup info
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $pinfo
 # Start the process
$process.Start()

# Wait a while for the process to do something
sleep -Seconds 1

# If the process is still active kill it
if (!$process.HasExited) {
    $process.Kill()
}
 # get output from stdout and stderr
$stdout = $process.StandardOutput.ReadToEnd()
$stderr = $process.StandardError.ReadToEnd()

Write-Output $stdout,$stderr