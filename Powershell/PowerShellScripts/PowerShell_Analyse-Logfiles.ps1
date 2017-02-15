#############################################
##
##   Analyse file contents
##
#############################################

$filedir = "C:\Program Files\7-Zip\Lang"
$logfileextension = @("*.ttt","*.log","*.txtr","*.txt")
$logfile = "C:\Users\Fusco\Desktop\Logfile-Analysis.log"
$SearchPattern = Read-Host -prompt "Bitte den gesuchten String eingeben"

# $SearchPattern = @("01000000")
# hier geht momentan kein array !!!
# noch verbessern

$files = @(get-childitem -Path $filedir -Include $logfileextension -Recurse | select -Property name )
Clear-Content $logfile

for($i = 0; $i -lt $files.length ; $i++) {

    $File = $files[$i]
    $Analyse = Join-Path -Path $filedir -ChildPath $File.Name

    Get-Content -Path $Analyse | Select-String -Pattern "$SearchPattern" |
    Out-File -Append -FilePath $logfile -Encoding unicode
    
    }

(Get-Content $logfile) | Where-Object {$_.trim() -ne "" } | Set-Content $logfile -Encoding Unicode
&notepad $logfile