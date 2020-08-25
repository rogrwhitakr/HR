Get-Service -ComputerName 192.168.249.87 | `
    Where-Object {$_.Status -eq "running" -and $_.Name -like "Ora*"} | `
    Select-Object *