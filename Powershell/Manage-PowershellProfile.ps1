 Write-Host -ForegroundColor Cyan "Powershell Profile Creation and Fill
 "

try {

    if ((Test-Path $profile) -eq $false) {
        New-Item -Path $profile -ItemType File -Force
    } 

    If ((Test-Path $Profile) -eq $true) {

        $a = Get-Content -Path C:\repos\HR\Powershell\conf\profile.conf

        Set-Content -Path $profile -Value $a

    Write-Host -ForegroundColor Green "Profile Creation complete
    "

    }
}

catch {

    $ErrorMessage = $_.Exception.Message
    Write-Host "An Error occurred. Please assign the Path to the Executable 7zip."
    Write-Host $ErrorMessage

}

Write-Host -ForegroundColor Cyan "current profiles"
$profile | Format-List -Force
Write-Host 
"Get-Help about_profiles 

==> full explanation of these paths. 
    The AllUsersAllHosts-profile is great if you want to 
    make a common set of functions or modules available to all users"