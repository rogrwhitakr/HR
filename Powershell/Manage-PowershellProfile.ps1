Write-Output "Powershell Profile Creation and Fill"

if ((Test-Path $profile) -eq $false) {
    New-Item -Path $profile -ItemType File -Force
} 

If ((Test-Path $Profile) -eq $true) {

    $a = Get-Content -Path C:\repos\HR\Powershell\conf\profile.conf

    Set-Content -Path $profile -Value $a
}
########################################################################################################
# profile directrory 
########################################################################################################

$base_dir = Get-ChildItem $profile -Directory
$base_dir.DirectoryName

$a = Get-ChildItem -Path C:\repos\HR\Powershell\conf\profile.conf