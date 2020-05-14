# anything related to a scheduled Task
#
# Get-Help ScheduledTask
# Get-help New-ScheduledTask -Full 

Clear-Host

# do this as admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    'we aint admin. Please provide Credentials:'
    $cred = Get-Credential
    'using Username {0} for ScheduledTask Creation' -f $cred.UserName
}

$batch = 'C:\repos\HR\PS\administration\scheduled-tasks-jobs\some-batch-file.bat'

try {
    # set the executor to the batch file provided
    # set working directory to its directory
    $Action = New-ScheduledTaskAction -Execute (Get-ChildItem -Path $batch).FullName.ToString() -WorkingDirectory (Get-ChildItem -Path $batch).Directory.ToString() -Verbose

    # trigger the action at 22:00 every day
    $Trigger = New-ScheduledTaskTrigger -At ([datetime]'2018-01-01 22:00:00') -Daily -Verbose

    # i assume this is the username
    $Principal = New-ScheduledTaskPrincipal -UserId $cred.UserName -LogonType Password -Verbose -RunLevel Highest

    # some settings
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -Verbose

    # create the task
    $task = New-ScheduledTask -Action $Action -Principal $Principal -Trigger $Trigger -Settings $Settings -Verbose

    #register the task
    Register-ScheduledTask -Verbose -TaskName 'Logrotate' -TaskPath '\northern-lights' -InputObject $task -User $cred -Description 'cleans the northern-lights directory (or directories) of service log files, import files, etc. on a daily schedule, using a CMD batch file'

}

catch {
    '{1}{0}' -f $_.Exception.Message, $_.task
}