
## vmware services

Get-Service -ComputerName gil | Where-Object { $_.status -match 'stopped' -and $_.starttype -match 'Automatic'} | select name,RequiredServices