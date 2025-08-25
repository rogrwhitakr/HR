
# get paths of specific software
Get-ItemProperty -Path "HKLM:SOFTWARE" -Name "Path64", 'path'

Get-ItemProperty -Path "HKLM:SOFTWARE\7-Zip" -Name "Path64", 'path'

# get OS version ID
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object -ExpandProperty ReleaseId

# get metadata of a file
get-itemproperty '..\data\csv\demo_data.csv' | format-list

get-itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\'

Get-childItem -Path "registry::HKLM\SOFTWARE" | Select-Object *

foreach ($name in ((Get-childItem -Path "registry::HKLM\SOFTWARE").Name)) {
    Get-ItemProperty -Path $name -Name Name, Path64, path
}


$searchTerm = "Zabbix"
$paths = @(
    "HKLM:\SOFTWARE",
    "HKCU:\SOFTWARE"
)

foreach ($path in $paths) {
    Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $key = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
            foreach ($property in $key.PSObject.Properties) {
                if ($property.Value -match $searchTerm) {
                    Write-Output "Match found in: $($_.PSPath)"
                    Write-Output "Property: $($property.Name) = $($property.Value)"
                    Write-Output "----------------------------------------"
                }
            }
        }
        catch {
        }
    }
}
                                                            