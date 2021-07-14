

# works in principle, needs some cleanup
function New-HtmlReport {
    [cmdletBinding()]
    Param(    
        [Parameter(Mandatory, Position = 0)]
        [string] $ComputerName,
        [Parameter(Position = 1)]
        [string] $ReportName
    )

    if (!$ReportName) {

        $ReportName = $ComputerName + '_report'
        Write-Verbose -Message "using reportname $ReportName"

    }

    $css = '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">'
    $js = '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>'

    $reporturl = "C:\repos\HR\administration\reporting\" + $ReportName + ".html"
    $reportcontent = get-service | Where-Object {$_.Status -eq "running"} | ConvertTo-Html -Property Name, BinaryPathName -Fragment
    ## | Add-Content $report
    ConvertTo-Html -Title $ReportName -CssUri $css -Body $reportcontent | Out-File -path $reporturl

}

New-HtmlReport -ComputerName $env:COMPUTERNAME -Verbose

