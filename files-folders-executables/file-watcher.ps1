#requires -version 5.1

$watcher = New-Object System.IO.FileSystemWatcher

$watcher.Path = 'C:\Tools\database'

$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.Filter = "*.csv"


$Action = {
    $details = $event.SourceEventArgs
    $Name = $details.Name
    $FullPath = $details.FullPath
    $OldFullPath = $details.OldFullPath
    $OldName = $details.OldName
    $ChangeType = $details.ChangeType
    $Timestamp = $event.TimeGenerated

    $text = "{0} was {1} at {2}" -f $FullPath, $ChangeType, $Timestamp
    Write-Host -message $text

    # Define change types
    switch ($ChangeType) {
        'Changed' { "CHANGE" }
        'Created' {
            $text = "File {0} was created. we can now move it" -f $Name
            Write-Warning -Message $text
            Move-Item -Path $FullPath -Destination "C:\tools\database\copies" -verbose
        
        }
        'Deleted' {
            Write-Host "Deletion Started" -ForegroundColor Gray
            Write-Warning -Message 'Deletion complete'
        }
        'Renamed' {
            $text = "File {0} was renamed to {1}" -f $OldName, $Name
            Write-Host $text -ForegroundColor Yellow
        }
        default { 
            Write-Host $_ -ForegroundColor Red -BackgroundColor White 
        }
    }
}

# Set event handlers
$handlers = . {
    Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $Action -SourceIdentifier FSChange
    Register-ObjectEvent -InputObject $watcher -EventName Created -Action $Action -SourceIdentifier FSCreate
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

while ($true) { start-sleep 5 }

#Register-ObjectEvent $filewatcher "Created" -Action $writeaction
#Register-ObjectEvent $filewatcher "Changed" -Action $writeaction
#Register-ObjectEvent $filewatcher "Deleted" -Action $writeaction
#Register-ObjectEvent $filewatcher "Renamed" -Action $writeaction
#while ($true) {sleep 5}