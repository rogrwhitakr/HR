$Option = New-ScheduledJobOption -RunElevated -RequireNetwork
$Trigger = New-JobTrigger -Daily -At 13:00
$JobSplat = @{
    Name               = 'Update PS Help'
	ScriptBlock        = {Update-Help}
	Trigger            = $Trigger
	ScheduledJobOption = $Option
}
Register-ScheduledJob @JobSplat