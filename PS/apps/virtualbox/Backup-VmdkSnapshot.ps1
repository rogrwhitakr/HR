

$backup_base_folder = "C:\Tools\backups"
$vboxmanage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$vms = Get-VBoxMachine
$stop_required = $false
$date = (Get-Date -Format 'yyyy-MM-dd')

Start-Transcript -Path ($backup_base_folder + 'vm_backup.log') -Append
Write-Verbose "Starting Backup of VirtualBox VM hard disks"

foreach ($vm in $vms) {

    $uuid = [guid]::NewGuid()
    Write-Warning -Message ('VM {0} is {1}. new UUID is {2}' -f ($vm.Name, $vm.state, $uuid))

    if ($vm.State -eq "Running") {
        Write-Warning -Message ('stopping running VM "{0}"' -f $vm.Name)
        Stop-VBoxMachine -Name $vm.Name
        Start-Sleep -Seconds 300
        $stop_required = $true
    }
   
    $stringBuilder = New-Object System.Text.StringBuilder 
    $stringBuilder.Append(" clonevm ") 
    $stringBuilder.Append($vm.Name) 
    $stringBuilder.Append(" --uuid ") 
    $stringBuilder.Append($uuid) 
    $stringBuilder.Append(" --basefolder ") 
    $stringBuilder.Append($backup_base_folder) 
    $stringBuilder.Append(" --name ") 
    $stringBuilder.Append( $date + "-" + $vm.Name) 
    $stringBuilder.Append(" --mode=`"machine`" ") 


    Write-Warning -Message ('starting clone process')
    Start-Process -FilePath $vboxmanage -ArgumentList $stringBuilder -NoNewWindow -Wait
    Write-Warning -Message ('clone process complete')

    if ($stop_required = $true) {

        Write-Warning -Message ('starting VM "{0}" again' -f $vm.Name)
        Start-VBoxMachine -Name $vm.Name -Headless
        $stop_required = $false
    }
}

Write-Verbose "Backup of VirtualBox VM hard disks complete"
Stop-Transcript