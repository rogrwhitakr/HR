
$backup_base_folder = "C:\Tools\backups"
$vm_dir = "D:\VM\NorthernLights"
$vboxmanage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
#foreach ( $virtual_machine in (Get-ChildItem -Path $vm_dir -Directory) ) {

    # get the virtual HDD. the sorting needs not to happen really. or the selecting...
  #  $virtual_HDD = Get-ChildItem -path $virtual_machine.FullName -Recurse | `
  #      Where-Object {$_.Extension -eq ".vmdk" -or $_.Extension -eq ".vdi" -and $_.FullName -notmatch "Snapshots"} | `
  #      Sort-Object -Property LastWriteTime | Select-Object -First 1
  #  'virtual_HDD is {0}' -f $virtual_HDD

    # get the newest / last snapshot sorted by write time
  #  $snapshot = Get-ChildItem -path $virtual_machine.FullName -Recurse | `
  #      Where-Object {$_.Extension -eq ".vmdk" -or $_.Extension -eq ".vdi" -and $_.FullName -match "Snapshots"} | `
  #      Sort-Object -Property LastWriteTime | Select-Object -Last 1
  #  'snapshot is {0}' -f $snapshot 

    # copy the hdd if not there yet
    # robocopy might be the better tool here!
  #  Copy-Item -Path $virtual_HDD.FullName -Destination $backup_dir -WhatIf

  #"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
  # this one worked
 # VBoxManage clonevm SQL --uuid="2d03746f-24ed-4f0c-a181-25357a55912f" --basefolder="C:\Tools\backups" --name="SQL-backup" --mode="machine"

    # if snapshot list empty, dont go any further!
#}

#Start-Process -FilePath $vboxmanage -ArgumentList 'list', '--sorted', 'vms' -NoNewWindow -PassThru

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

