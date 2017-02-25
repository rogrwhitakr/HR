
### Provides a report on computers ###

# variables

$rname = "NorthernLights Status Report"
$rurl = "northernlights-report.html"

$computers = "Z:\MyScripts\PowerShell\computers.csv"
#$css = Get-Content -Path "$reportlocation\report.css"
#$reportlocation = "C:\inetpub\wwwroot"

function Get-InstalledList {
    param (
       [string] $ComputerName = '*'
        )
        
        $installedList = Get-EventLog -LogName System -ComputerName $ComputerName | Where-Object {$_.EventID -eq 7045} | 
        Select-Object TimeGenerated,MachineName,Message

        #$installedList | ConvertTo-Html -Title $reportname -Head "<style>$css</style>"  | 
        #out-file $reportlocation\$reporturl
}

function Create-Report {
    param (
      #  [Object] $SendtoReport = '*',
        [String] $ReportName = '*',
        [String] $ReportUrl = '*'
        )

        $reportlocation = "C:\inetpub\wwwroot"
        $css = Get-Content -Path "$reportlocation\report.css"

        ConvertTo-Html -Title $ReportName -Head "<style>$css</style>"  | 
        out-file $reportlocation\$ReportUrl
        }

Get-InstalledList -ComputerName "Server" #| Create-Report -ReportName $rname -ReportUrl $rurl

