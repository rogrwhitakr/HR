
$result = "$home\Desktop\Dokumentation.txt" 
$gna = "txt"
 
function Get-LogFiles {
    param (
        [string] $LoggingPath = '*',
        [string] $Extension = '*',
        [string] $ResultPath = '*'
        )
   
    Get-ChildItem -Path $LoggingPath -Include *.$Extension -Exclude ".\PowerShell" -Recurse -ErrorAction SilentlyContinue | Out-File -FilePath $ResultPath
    }
 
Get-LogFiles -LoggingPath $asder -Extension $gna -ResultPath $result
