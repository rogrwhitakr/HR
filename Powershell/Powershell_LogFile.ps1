
########################################################################################################
#
# Basisverzeichnis der Optimierung, Name der logfiles(extension)
#
########################################################################################################

function Get-OptimisationTime {
    
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
        if($calc -lt 0) {$notation = "Optimisation incomplete"} else {$notation = ""}
 
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

Get-OptimisationTime -LogPath "C:\OPTITOOL\002_OptEngine\log" -LogFile "log.txt"

########################################################################################################
########################################################################################################

    
    foreach ($logfile in $logfiles) {
        #construct
        $fileobj = "" | Select-Object -Property Directory, Name
        
        #fill
        $fileobj.Directory = $logfile
        $fileobj.Name = $logfile
        
        #add to set
        $resultset += $fileobj
        
        #wipe
        $fileobj = $null

    }
    Write-Host $resultset | Format-table
    
        finally {
            $duration
            
                if($calc -lt 0) {$notation = "Optimierung nicht vollständig"} else {$notation = ""}
              ($calc).TotalSeconds
                
             ($logfile.Directory).Name, $start, $end, ($calc).TotalSeconds.ToString, $notation
            $calc = ""
        }
