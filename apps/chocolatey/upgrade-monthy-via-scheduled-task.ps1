$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\Manage-Chocolatey.ps1 -UpgradeOnly"

# Trigger runs on the first day of every month at 03:00 AM
$trigger = New-ScheduledTaskTrigger -At 3:00am -Daily
# (Or set a Monthly trigger directly in the Task Scheduler UI)

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "Chocolatey-Monthly-Upgrade" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Description "Monthly unattended Chocolatey package upgrades with file logging."