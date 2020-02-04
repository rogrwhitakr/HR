
$backup_base_folder = "C:\Tools\backups"
$vm_dir = "D:\VM\NorthernLights"
$vboxmanage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

$vms =  Get-VBoxMachine -All

foreach ($vm in $vms){
    'VM {0} is {1}' -f ($vm.Name, $vm.state)

    if ($vm.State -eq "Running") {
        #Stop-VBoxMachine -Name $vm.Name
        Write-Warning -Message ('stopping running VM "{0}"' -f $vm.Name)
    }

    $uuid =  [guid]::NewGuid()

    'new UUID is {0}. continue?' -f ($uuid)

    $stringBuilder = New-Object System.Text.StringBuilder
    $stringBuilder.Append(" clonevm ")
    $stringBuilder.Append($vm.Name)
    $stringBuilder.Append(" --uuid ")
    $stringBuilder.Append($uuid)
    $stringBuilder.Append(" --basefolder ")
    $stringBuilder.Append($backup_base_folder)
    $stringBuilder.Append(" --name ")
    $stringBuilder.Append($vm.Name + "-backup")
    $stringBuilder.Append(" --mode=`"machine`" ")

    if ($vm.State -eq "Stopped") {
        'starting clone process'
  #      Start-Process -FilePath $vboxmanage -ArgumentList "clonevm", $vm.Name ,"--uuid", $uuid , "--basefolder", $backup_base_folder, "--name", "($vm.Name +`"-backup`")", "--mode=machine" -NoNewWindow -Wait
        Start-Process -FilePath $vboxmanage -ArgumentList $stringBuilder -NoNewWindow -Wait
        'complete'
    }
    'loop over'
}

