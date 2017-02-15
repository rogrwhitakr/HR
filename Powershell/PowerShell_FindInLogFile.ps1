
### variables

$logpath = "C:\OPTITOOL\Suez\opt\tsp_osm\log" 
$result = "C:\OPTITOOL\Suez\opt\tsp_osm\logging-analysis.log"  
$extension = "*.txt"
$pattern = "Moves per second:"
$moves = @()

### functions

function getLogEntry {
    Get-ChildItem -Path $logpath -Include $extension -Recurse | 
    Select-String -Pattern $pattern | 
    Select-Object -Property Line 
    
}
    
### execution

getLogEntry($moves) | Out-File -FilePath $result -Encoding unicode