
########################################################################################################
#
########################################################################################################

function Get-LogTime {
    
    param (
        [string] $LogPath = '*',
        [string] $LogFile = '*'
        ) 
         
    $resultset = @()
    $resultfile = Join-Path -Path $LogPath -ChildPath "\analysis.log"  
    $logfiles = Get-ChildItem -Path $LogPath -Include $LogFile -Recurse
    
    foreach ($logfile in $logfiles) {
        
        $result = New-Object System.Object
        
        $entry = $logfile | Get-Content 

        try {
            $start = ($entry[0]).Substring(0,20)
        }
        catch {
            $start = "1970-01-01 00:00:00"
        }  
        try {
            $end = ($entry[-1]).Substring(0,20)
        }
        catch {
            $end = "1970-01-01 00:00:01"
        }
        
        $calc  = New-TimeSpan -Start $start -End $end -ErrorAction SilentlyContinue
        if($calc -lt 0) {$notation = "query incomplete"} else {$notation = ""}
 
        $result | Add-Member -MemberType "NoteProperty" -Name "SessionName" -Value ($logfile.Directory).Name
        $result | Add-Member -MemberType "NoteProperty" -Name "StartTime" -Value $start
        $result | Add-Member -MemberType "NoteProperty" -Name "EndTime" -Value $end
        $result | Add-Member -MemberType "NoteProperty" -Name "Duration (in Seconds)" -Value ($calc).TotalSeconds
        $result | Add-Member -MemberType "NoteProperty" -Name "Notation" -Value $notation
 
        $resultset += $result
        
    }
    
    $resultset | Format-Table | Out-File -FilePath $resultfile -Encoding Unicode
    
}

### execution

Get-LogTime -LogPath "path" -LogFile "log.txt"

########################################################################################################
########################################################################################################
