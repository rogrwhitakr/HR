Write-Output "Powershell Profile Creation and Fill"

if ((Test-Path $profile) -eq $false) {
    New-Item -Path $profile -ItemType File -Force
} 

If ((Test-Path $Profile) -eq $true) {

   $profile_content = "

    "
    $profile_content >> $profile
}

########################################################################################################
# profile info in ~/profile/profile.config
########################################################################################################
