function Get-Software
{
    param
    (
        [string]
        $DisplayName='*',
 
        [string]
        $UninstallString='*'
    )
 
    $keys = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    
    Get-ItemProperty -Path $keys |
      Where-Object { $_.DisplayName } |
      Select-Object -Property DisplayName, DisplayVersion, UninstallString |
      Where-Object { $_.DisplayName -like $DisplayName } |
      Where-Object { $_.UninstallString -like $UninstallString }
} 
