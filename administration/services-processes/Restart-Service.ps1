
$servicename = 'northern-lights thingy'


$service = Get-Service -Name $servicename -ComputerName $env:COMPUTERNAME

if ($service.Status -eq 'Running' ) {

    Write-Host -ForegroundColor Yellow 'Restarting '$service.DisplayName

    $ServicePID = (get-wmiobject win32_service | Where-Object { $_.name -eq $service.Name}).processID

    Write-Host  $ServicePID

    if ($ServicePID) {

        Restart-Service -Name $service
    
    }

}
# Stop-Process $ServicePID -Force