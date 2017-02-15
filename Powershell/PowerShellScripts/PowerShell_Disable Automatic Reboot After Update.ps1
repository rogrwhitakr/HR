$code = 
{
  $key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' 
  $name = 'NoAutoRebootWithLoggedOnUsers' 
  $type = 'DWord' 
  $value = 1 
 
  if (!(Test-Path -Path $key))
  {
    $null = New-Item -Path $key -Force 
  }
  Set-ItemProperty -Path $key -Name $name -Value $value -Type $type 
}
 
Start-Process -FilePath powershell.exe -ArgumentList $code -Verb runas -WorkingDirectory c:\ 
