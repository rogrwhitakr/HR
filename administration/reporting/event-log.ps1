Get-EventLog -log Application | Select-Object source -unique
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
