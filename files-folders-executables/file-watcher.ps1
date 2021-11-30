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
    $OldFullPath = $details.OldFullPath
    $OldName = $details.OldName
    $ChangeType = $details.ChangeType
    $Timestamp = $event.TimeGenerated

    $text = "{0} was {1} at {2}." -f $FullPath, $ChangeType, $Timestamp
    Write-Warning -Message $text

    # Define change types
    switch ($ChangeType) {
        'Changed' { "CHANGE" }
        'Created' {
            Move-Item -Path $FullPath -Destination $import_path -verbose
        }
        'Deleted' {
            $text = "File {0} was deleted/moved." -f $Name
            Write-Warning -Message $text
        }
        'Renamed' {
            $text = "File {0} was renamed to {1}" -f $OldName, $Name
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