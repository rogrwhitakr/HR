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
