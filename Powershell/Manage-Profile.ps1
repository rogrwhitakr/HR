#----------------------------------------------------------[Declarations]----------------------------------------------------------

$conf = "C:\repos\HR\Powershell\conf\profile.conf"

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#---------------------------------------------------------[UserProfile]------------------------------------------------------------


Clear-Host
Write-Host -ForegroundColor Cyan "Powershell Profile Creation and Fill`n"


 If ((Test-Path $conf) -ne $true) {
    
    Write-Error "
    Error:
        you must provide the path to the correct configuration file:
        the file $conf does not exist"
    Exit 1
 
 }

try {

    if ((Test-Path $profile) -eq $false) {
        New-Item -Path $profile -ItemType File -Force
    } 

    If ((Test-Path $profile) -eq $true) {

        $comp = Compare-Object -ReferenceObject $(Get-Content $profile) -DifferenceObject $(Get-Content -Path $conf)

        if ($comp.Count -ne 0) {

            Write-Host "The Powershell profile configuration file differs from the actual profile.`nThere are"$comp.Count "changes:"
            Compare-Object -ReferenceObject $(Get-Content $profile) -DifferenceObject $(Get-Content -Path $conf)
            Read-Host "Overwrite Powershell profile with profile.conf settings? Press Enter"
            Set-Content -Path $profile -Value $(Get-Content -Path $conf)

            Write-Host -ForegroundColor Green "Profile contents inserted"

        }
        else {

            Write-Host "no changes between the files`n"$conf "`n and `n"$profile "`n detected."

        }
        
    Write-Host -ForegroundColor Green "`nProfile Creation complete `n"
    }
}

catch {

    $ErrorMessage = $_.Exception.Message
    Write-Host "An Error occurred. "
    Write-Host $ErrorMessage

}


#---------------------------------------------------------[Modules]------------------------------------------------------------


Write-Host -ForegroundColor Cyan "Powershell Module Creation and Fill`n"

Write-Host "Module-Paths:`n" ${env:psmodulepath}

$read = Read-Host -Prompt 'Module? Yes / No'

if ( $read.Length -ne 0 ) {
    
    $mod_path = ${env:USERPROFILE} + "\Documents\WindowsPowerShell\" + $read
    $env:psmodulepath = $env:psmodulepath + ";" + $mod_path

}

Write-Host "Appended psmodulepath ?"

Write-Host $env:psmodulepath

${env:modulepath}