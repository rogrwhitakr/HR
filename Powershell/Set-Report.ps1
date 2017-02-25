
### Provides a report on computers ###

# variables

$computer = "Server"

$reportname = "NorthernLights Status Report"
$reporturl = "northernlights-report.html"
$reportlocation = "C:\inetpub\wwwroot"

#exec

$css = Get-Content -Path "$reportlocation\report.css"
$report = Get-EventLog -LogName System -ComputerName $computer | Where-Object {$_.EventID -eq 7045} | 
    Select-Object TimeGenerated,MachineName,Message
$report | ConvertTo-Html -Title '$reportname' -Head "<style>$css</style>" | 
    out-file $reportlocation\$reporturl



# do some reporting via html-file
$css = Get-Content -Path "$reportlocation\report.css"
$reportlocation = "C:\inetpub\wwwroot"

Get-EventLog -LogName System | Where-Object {$_.EventID -eq 7045} | 
    Select-Object TimeGenerated,MachineName,Message | 
    ConvertTo-Html -Title "DOMAIN Server Report" -Head "<style>$css</style>"   | 
    out-file $reportlocation\indicators.html

$computerpath = "Z:\MyScripts\PowerShell"
$computers = "computers.csv"
if (Test-Path $computerpath != "true") {
    Write-Host "geht ned"
    }
#Get-Content -Path $computers