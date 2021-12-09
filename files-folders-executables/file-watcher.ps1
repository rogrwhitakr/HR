#requires -version 5.1

$watcher = New-Object System.IO.FileSystemWatcher

$watcher.Path = 'C:\Tools\database'
$import_path = 'C:\tools\database\copies'

$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true
$watcher.Filter = "*.csv"


$Action = {
    $details = $event.SourceEventArgs
    $Name = $details.Name
    $FullPath = $details.FullPath
    $OldName = $details.OldName
    $ChangeType = $details.ChangeType
    $Timestamp = $event.TimeGenerated

    # Define change types
    switch ($ChangeType) {
        'Changed' { "CHANGE" }
        'Created' {
            $text = "{0} was {1} at {2}." -f $FullPath, $ChangeType, $Timestamp
            Write-Warning -Message $text
            Move-Item -Path $FullPath -Destination $import_path -verbose
        }
        'Deleted' {
            $text = "{0} was {1} at {2}." -f $FullPath, $ChangeType, $Timestamp
            Write-Warning -Message $text
        }
        'Renamed' {
            $text = "{0} was {1} at {2} to {3}." -f $OldName, $ChangeType, $Timestamp, $Name
            Write-Warning -Message $text
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