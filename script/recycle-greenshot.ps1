#require 3.0

# command line args
<# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 
-NonInteractive
-WindowStyle Hidden
-NoProfile
-ExecutionPolicy Bypass
-Command "& { Get-Process -ProcessName \"Greenshot\" | Stop-Process; Start-Process -FilePath \"C:\Program Files\Greenshot\Greenshot.exe\"}" #>



Get-Process -ProcessName "Greenshot" | Stop-Process -verbose
Start-Process -FilePath "C:\Program Files\Greenshot\Greenshot.exe" -verbose
#pause