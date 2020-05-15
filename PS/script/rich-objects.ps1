function Get-TestData {

  # if a function is to return more than one information kind,
  # wrap it in a custom object
 
  [PSCustomObject]@{
      ID = 1
      Random = Get-Random
      Date = Get-Date
      Text = 'Hello'
      BIOS = Get-WmiObject -Class Win32_BIOS
      User = $env:username
    }
}

Get-TestData