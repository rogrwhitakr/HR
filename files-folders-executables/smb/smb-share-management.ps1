# get local shares
Get-SmbShare | ForEach-Object {

    [PSCustomObject]@{
        Name = ($_.name)
        Path = ($_.Path)
        Host = $env:COMPUTERNAME
        Call = "\\" + $env:COMPUTERNAME + "\" + ($_.name) + "\"
      }
  }
  