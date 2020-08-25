# lets do some service polling...
# todo
# - get specified scheduled task that does something in an northern-lights installation
# - get its return status on a regulr basis
# - trigger email alert in the event of retrun status != 0
# 


function Get-FailedScheduledTasks {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 0, HelpMessage = "the container the scheduled task is in. defaults to . if created in default directory, supply '*''")] 
        [ValidateNotNullOrEmpty()]     
        $TaskPath = '\'
    )

    # task to check
    # we can still work on the taskpath parameter...

    if ($TaskPath.Length -gt 1) {
        # we build it correctly
        $Path = New-Object System.Text.StringBuilder
        $Path.Append("\" + $TaskPath + "\")
        $TaskPath = $Path.ToString()
        $Path.Clear
    }

    # we get the tasks
    try {
        $tasks = Get-ScheduledTask -TaskPath $TaskPath
    }

    catch {
        'gay ninja: ${0}' -f $tasks.exception
    }

    if ($tasks) {

        foreach ($task in $tasks) {

            $taskdetail = Get-ScheduledTaskInfo -TaskPath $TaskPath -TaskName $task.TaskName
            if ($taskdetail.LastTaskResult -ne 0) {

                # filter out the ones that are newly created
                if ($taskdetail.LastTaskResult -ne 267011) {
                    return [Microsoft.Management.Infrastructure.CimInstance]$taskdetail
                }
            }
        }
    }
    else {
        return
    }

}

Get-FailedScheduledTasks
Get-FailedScheduledTasks -TaskPath 'northern-lights'