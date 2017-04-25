#requires -version 2
<#
.SYNOPSIS
    script to automate profile and module stuff

.DESCRIPTION
    

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.REQUIRED INPUTS
    configuration files for profile and modules

.OUTPUTS
    $profile file and modules in user directory

.NOTES
    Version:        1.0
    Author:         rogrwhitakr
    Creation Date:  2017-05
    Purpose/Change: PS set-up should be the same everywhere
  
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$conf = "C:\repos\HR\Powershell\conf\profile.conf"
$module = "C:\Users\HaroldFinch\Documents\WindowsPowerShell\Modules"

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
            
            Read-Host -Prompt "Overwrite Powershell profile with profile.conf settings? Press Enter"
            Set-Content -Path $profile -Value $(Get-Content -Path $conf)

            Write-Host -ForegroundColor Green "`$Profile contents modified"

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
Write-Host "Module-Paths:`n"${env:psmodulepath}.Replace(";","`n")

Write-Host "`nDo you need to append another path to this list? One that is " -NoNewline
Write-Host "NOT" -NoNewline -ForegroundColor Red -BackgroundColor Yellow
Write-Host " on the path?"

$read = Read-Host -Prompt "`nyes/no "

if (( $read.Length -ne 0 ) -and ( $read.ToUpper() -cmatch 'YES')) {
    
    Write-Host "Appending psmodulepath`ndo the appending....`netc"    

    # TODO appending
    #$mod_path = ${env:USERPROFILE} + "\Documents\WindowsPowerShell\"
    #$mod_path = "C:\Users\HaroldFinch\Documents\WindowsPowerShell\Modules"
    #$env:psmodulepath = $env:psmodulepath + ";" + $mod_path
    
    Write-Host -ForegroundColor Green "psmodulepath appended"
    Write-Host "Module-Paths:`n"${env:psmodulepath}.Replace(";","`n")
}


#Write-Host $env:psmodulepath[17]
#Write-Host $env:psmodulepath[2]
#Write-Host $env:psmodulepath[3]
#Write-Host $env:psmodulepath[4]
#Write-Host $env:psmodulepath[5]
#Write-Host $env:psmodulepath.Length
#Write-Host $env:psmodulepath.Split(";")
Write-Host $env:psmodulepath.Contains(${env:USERPROFILE})
#${env:psmodulepath}.Replace(";","`n")


echo $module

#---------------------------------------------------------[Modules]------------------------------------------------------------
