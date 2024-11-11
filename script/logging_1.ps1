filter New-LogTimeStamp { 
    "[ "+ (Get-Date -Format 'yyyy-hh-dd HH:mm:ss') + " ] :: "+ $_
}

Start-Transcript -Path (Join-path -Path $backup_base_folder -ChildPath ( $date + '_vm_backup.log')) -Append
"Starting Backup of VirtualBox VM hard disks" | New-LogTimeStamp

'VM {0} is {1}. creating new UUID for backup: {2}' -f ($vm.Name, $vm.state, $uuid) | New-LogTimeStamp