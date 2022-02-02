
# get paths of specific software
Get-ItemProperty -Path "HKLM:SOFTWARE" -Name "Path64",'path'

Get-ItemProperty -Path "HKLM:SOFTWARE\7-Zip" -Name "Path64",'path'

# get OS version ID
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object -ExpandProperty ReleaseId

# get metadata of a file
get-itemproperty '..\data\csv\demo_data.csv' | format-list

get-itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\'

Get-childItem -Path "registry::HKLM\SOFTWARE" | select *

foreach ($name in ((Get-childItem -Path "registry::HKLM\SOFTWARE").Name)){
    Get-ItemProperty -Path $name -Name Name,Path64,path
}

