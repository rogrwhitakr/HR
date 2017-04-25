Write-Output "Powershell Profile Creation and Fill"

try {

    if ((Test-Path $profile) -eq $false) {
        New-Item -Path $profile -ItemType File -Force
    } 

    If ((Test-Path $Profile) -eq $true) {

        $a = Get-Content -Path C:\repos\HR\Powershell\conf\profile.conf

        Set-Content -Path $profile -Value $a

    Write-Output "Profile Creation complete"

    }
}

catch {

    $ErrorMessage = $_.Exception.Message
    Write-Output "An Error occurred. Please assign the Path to the Executable 7zip."
    Write-Output $ErrorMessage

}

