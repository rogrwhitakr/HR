$service = @{}
$Process = @{
  Name = 'Name'
  Expression = {
    $id = $_.OwningProcess
    $name = (Get-Process -Id $id).Name 
    if ($name -eq 'svchost')
    {
      if ($service.ContainsKey($id) -eq $false)
      {
        $service.$id = Get-WmiObject -Class win32_Service -Filter "ProcessID=$id" | Select-Object -ExpandProperty Name
      }
      $service.$id -join ','
    }
    else
    {
      $name
    }
  }
}
 
Get-NetTCPConnection | Select-Object -Property LocalPort, OwningProcess, $Process | Sort-Object -Property LocalPort, Name -Unique 
