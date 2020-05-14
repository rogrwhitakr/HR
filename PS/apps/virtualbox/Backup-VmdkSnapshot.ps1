filter New-LogTimeStamp { 
    "[ "+ (Get-Date -Format 'yyyy-hh-dd HH:mm:ss') + " ] :: "+ $_
}

$backup_base_folder = "C:\Tools\backups"
$vboxmanage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$vms = Get-VBoxMachine
$date = (Get-Date -Format 'yyyy-MM-dd')

Start-Transcript -Path (Join-path -Path $backup_base_folder -ChildPath ( $date + 'vm_backup.log')) -Append
"Starting Backup of VirtualBox VM hard disks" | New-LogTimeStamp

foreach ($vm in $vms) {

    $stop_required = $false
    $uuid = [guid]::NewGuid()
    'VM {0} is {1}. creating new UUID for backup: {2}' -f ($vm.Name, $vm.state, $uuid) | New-LogTimeStamp

    if ($vm.State -eq "Running") {
        'stopping running VM "{0}"' -f $vm.Name | New-LogTimeStamp
        Stop-VBoxMachine -Name $vm.Name
        Start-Sleep -Seconds 300
        $stop_required = $true
    }
   
    $stringBuilder = New-Object System.Text.StringBuilder 
    [void] $stringBuilder.Append(" clonevm ") 
    [void] $stringBuilder.Append($vm.Name) 
    [void] $stringBuilder.Append(" --uuid ") 
    [void] $stringBuilder.Append($uuid) 
    [void] $stringBuilder.Append(" --basefolder ") 
    [void] $stringBuilder.Append($backup_base_folder) 
    [void] $stringBuilder.Append(" --name ") 
    [void] $stringBuilder.Append( $date + "-" + $vm.Name) 
    [void] $stringBuilder.Append(" --mode=`"machine`" ") 


    "starting clone process" | New-LogTimeStamp
    Start-Process -FilePath $vboxmanage -ArgumentList $stringBuilder -NoNewWindow -Wait -ErrorAction (Write-Output -InputObject ('clone process failed')) 
    'clone process complete' | New-LogTimeStamp

    if ($stop_required = $true) {

        ('starting VM "{0}" again' -f $vm.Name) | New-LogTimeStamp
        Start-VBoxMachine -Name $vm.Name -Headless
        $stop_required = $false
    }
}

"Backup of VirtualBox VM hard disks complete" | New-LogTimeStamp
Stop-Transcript