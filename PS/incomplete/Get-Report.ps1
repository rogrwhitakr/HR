

# works in principle, needs some cleanup
function New-Report {
    param (
        [string] $ComputerName = '*'
    )
    $reportlocation = "C:\inetpub\wwwroot"
    $css = Get-Content -Path "$reportlocation\report.css"
    $reportname = "NorthernLights Status Report"
    $reporturl = "northernlights-report.html"
        
    $installedList = Get-EventLog -LogName System -ComputerName $ComputerName | Where-Object {$_.EventID -eq 7045} | Select-Object TimeGenerated, MachineName, Message
    $installedList | ConvertTo-Html -Title $reportname -Head "<style>$css</style>"  |         out-file $reporturl

}

New-Report -ComputerName "Env:COMPUTERNAME"

Read-Host -Prompt "somesin"