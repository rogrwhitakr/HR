PARAM (
  $Path = 'D:\',
  $report = '.\ACLs.csv'
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
              Select-Object $HostName, Name, Directory, $LastWrite, $Owner, Length   | 
              Export-Csv -NoTypeInformation $Report