function Get-ErrorInfo {
    param
    (
        [Parameter(ValueFrompipeline)]
        [Management.Automation.ErrorRecord]$errorRecord
    )
 
 
    process {
        $info = [PSCustomObject]@{
            Exception = $errorRecord.Exception.Message
            Reason    = $errorRecord.CategoryInfo.Reason
            Target    = $errorRecord.CategoryInfo.TargetName
            Script    = $errorRecord.InvocationInfo.ScriptName
            Line      = $errorRecord.InvocationInfo.ScriptLineNumber
            Column    = $errorRecord.InvocationInfo.OffsetInLine
            Date      = Get-Date
            User      = $env:username
        }
    
        $info
    }
} 

try {
    Stop-Service -Name someservice -ErrorAction Stop
}  
catch {
    $_ | Get-ErrorInfo
} 


try {
        
    $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name "7z.exe" -Recurse  )     
    Write-Output "$Method files from/to $archive using $tool"

}

catch {

    $ErrorMessage = $_.Exception.Message
    Write-Output "An Error occurred. Please assign the Path to the Executable 7zip."
    Write-Output $ErrorMessage

}

########################################################################################################
# try/catch/fix and continue
########################################################################################################

$tries = 0
while ($tries -lt 2) {
    try {
        $tries++
        $ErrorActionPreference = ‘Stop’
        # code I am testing goes here – perhaps with a param argument that needs changing
        $tries++
    }
    catch {
        #fixup code goes here
        $ErrorActionPreference = ‘SilentlyContinue’ # and the loop will now retry.  
    }
}


########################################################################################################
# do proper error handling 
########################################################################################################

# the foreach loop assumes parallel execution of the wmi query on multiple computers simultaneously

try {
    get-wmiobject -class Win32_ComputerSystem -computername gil -ErrorAction SilentlyContinue -ErrorVariable Problems
}
catch {
    $err = $_
    write-verbose "Something went wrong : $err"
}
foreach ($errorRecord in $Problems) {
    write-verbose "An error occurred here : $errorRecord"
}

########################################################################################################
# from powershell.com
########################################################################################################

function ConvertFrom-ErrorRecord {
    [CmdletBinding(DefaultParameterSetName = "ErrorRecord")]
    param
    (
        [Management.Automation.ErrorRecord]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ErrorRecord", Position = 0)]
        $Record, 
    
        [Object]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Unknown", Position = 0)]
        $Alien
    )
  
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ErrorRecord') {
            [PSCustomObject]@{
                Exception = $Record.Exception.Message
                Reason    = $Record.CategoryInfo.Reason
                Target    = $Record.CategoryInfo.TargetName
                Script    = $Record.InvocationInfo.ScriptName
                Line      = $Record.InvocationInfo.ScriptLineNumber
                Column    = $Record.InvocationInfo.OffsetInLine
            }
        }
        else {
            Write-Warning "$Alien"
        } 
    }
} 


try {
    # this raises an error
    Get-Service -Name NonExisting -ErrorAction Stop
} 
catch {
    # pipe the errorrecord object through the new function
    # to retrieve all relevant error information
    # which you then could use to do error logging, or output
    # custom error messages
    $_ | ConvertFrom-ErrorRecord
 
} 
