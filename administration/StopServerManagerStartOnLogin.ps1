
# Windows Server 2019: Stop Server Manager loading at startup using a PowerShell command


Invoke-Command -ComputerName Exchange-2019 -ScriptBlock { New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" –Force }