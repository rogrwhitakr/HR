$logpath = "C:\OPTITOOL\Suez\opt\tsp_osm\log\app" 
$result = "C:\Users\bosterholt\Desktop\Suez\test"  
$gna = "html"



function get-Logfiles {
    param (
        [string] $LoggingPath = '*',
        [string] $Extension = '*'
        )
    
    Get-ChildItem -Path $LoggingPath -Include *.$Extension
    }

get-Logfiles -LoggingPath $logpath -Extension $gna