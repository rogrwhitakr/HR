

Get-Service -ComputerName gil | Where-Object { $_.status -match 'stopped' -and $_.starttype -match 'Automatic'} | Select-Object *

Get-Process | Where-Object {$_.Name -eq "firefox"} | Stop-Process


