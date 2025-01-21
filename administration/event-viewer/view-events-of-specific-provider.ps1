
while ($true) {
    Clear-Host
    Get-WinEvent -FilterHashtable @{ProviderName='Lasernet Cloud Print Connector'; Level=1..3} -MaxEvents 2 | Sort-Object TimeCreated -Descending | Select-Object TimeCreated,LevelDisplayName,Message | Format-List
    Start-Sleep -Seconds 2
}


$processName = "LasernetCloudPrintConnectorService"

while ($true) {
    $process = Get-Process -Name $processName
    $cpuUsage = ($process | Measure-Object -Property CPU -Sum).Sum
    Write-Output "CPU usage for $processName : $cpuUsage seconds"
    Start-Sleep -Seconds 1
}