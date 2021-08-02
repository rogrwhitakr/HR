
PARAM (
  $Path = 'D:\'
)
$LastWrite = @{
  Name = 'Last Write Time'
  Expression = { $_.LastWriteTime.ToString('u') }
}
$Owner = @{
  Name = 'File Owner'
  Expression = { (Get-Acl $_.FullName).Owner }
}
$HostName = @{
  Name = 'Host Name'
  Expression = { $env:COMPUTERNAME }
}

Get-ChildItem -Recurse -Path $Path | 
              Select-Object $HostName, Name, Directory, $LastWrite, $Owner, Length 