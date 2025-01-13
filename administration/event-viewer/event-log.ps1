# get the services? that write a query-able event 
Get-EventLog -log Application | Select-Object source -unique

# query that service
Get-EventLog -LogName Application -Source service-name

# query system stuff
Get-EventLog -log system | Select-Object source -unique

Get-EventLog -LogName System -InstanceId 44 -Source Microsoft-Windows-WindowsUpdateClient |
ForEach-Object { 
  
  $hash = [Ordered]@{ }
  $counter = 0
  foreach ($value in $_.ReplacementStrings) {
    $counter++
    $hash.$counter = $value
  }
  $hash.EventID = $_.EventID
  $hash.Time = $_.TimeWritten
  [PSCustomObject]$hash
  
} 

# display events of specific severity on specific log
while ($true) {
  Clear-Host
  Get-WinEvent -FilterHashtable @{ProviderName='Lasernet Cloud Print Connector'; Level=1..3} -MaxEvents 2 | Sort-Object TimeCreated -Descending | Select-Object TimeCreated,LevelDisplayName,Message | Format-List
  Start-Sleep -Seconds 2
}

#There are five event IDs that are reserved for power up, power down and uptime events.
# 1074 -> System has been shutdown by a process/user
# 6005 -> The Event log service was started
# 6006 -> The Event log service was stopped
# 6008 -> The previous system shutdown at time on date was unexpected
# 6013 -> The system uptime is number seconds

Get-WinEvent -FilterHashtable @{logname = 'System'; id = 1074} | Format-Table -wrap

Get-WinEvent -FilterHashtable @{logname = 'System'; id = 1074, 6005, 6006, 6008} -MaxEvents 6 | Format-Table -wrap

# get installed 
Get-WinEvent -FilterHashtable @{
  LogName='Application'
  ProviderName='MsiInstaller'
  StartTime=(Get-Date).AddMonths(-1)
}

# locally installed
get-ciminstance Win32_Product | Sort-Object -Property Name | Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize