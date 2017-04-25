 # set conf location
 
 $conf = "C:\repos\HR\Powershell\conf\profile.conf"
 
 If ((Test-Path $conf) -ne $true) {
    
    Write-Error "
    Error:
        you must provide the path to the correct configuration file:
        the file $conf does not exist"
    Exit 1
 
 }

 Clear-Host
 Write-Host -ForegroundColor Cyan "Powershell Profile Creation and Fill
 "

try {

    if ((Test-Path $profile) -eq $false) {
        New-Item -Path $profile -ItemType File -Force
    } 

    If ((Test-Path $profile) -eq $true) {

        $a = Get-Content -Path $conf

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

$comp = Compare-Object -ReferenceObject $(Get-Content $profile) -DifferenceObject $(Get-Content -Path $conf)if ($comp.Count -ne 0) {    Write-Host "do copy action here, because there are " $comp.count "changes"    Read-Host "Overwrite Powershell profile with profile.conf setting? Press Enter"}else {    Write-Host "do the regular thing"}