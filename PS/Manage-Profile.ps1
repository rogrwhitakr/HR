#requires -version 2
<#
.SYNOPSIS
    script to automate profile and module stuff

.DESCRIPTION
    .VARIABLES
        [STRING]conf        = the "configuration" file containing script stuff you want in your profile
        [STRING]modules_dir = the repository containing Powershell scripts to be converted into Modules
        [BOOLEAN]recurse    = $true if modules_dir contains subdirectories
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
$modules_dir = "C:\repos\HR\Powershell"
$recurse = $false

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
        New-Item -Path $profile -ItemType File -Force | Out-Null
        $date = (Get-Date -Format 'yyyy-MM-dd')
        Set-Content -Path $profile -Value "#`n# Profile created on $date"
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

    $ErrorMessage = $_.Exception
    Write-Host "An Error occurred. "
    Write-Host $ErrorMessage

}


#---------------------------------------------------------[Modules]------------------------------------------------------------


Write-Host -ForegroundColor Cyan "Powershell Module Creation and Fill`n"

 If ((Test-Path $modules_dir) -ne $true) {
    
    Write-Error "
    Error:
    
        you must provide the path to the correct directory
        containing all files to be made into Modules:
        the path $modules_dir does not exist
        
        " 
    Exit 1
 
 }

#---------------------------------------------------------[ModulePath]------------------------------------------------------------

#############################################################################
#
#   TODO psmodulepath appending
#   not needed for my case, though
#
#############################################################################

Write-Host "Module-Paths:`n"${env:psmodulepath}.Replace(";","`n")
Write-Host "`nDo you need to append another path to this list? One that is " -NoNewline
Write-Host "NOT" -NoNewline -ForegroundColor Red -BackgroundColor Yellow
Write-Host " on the path?"

$read = Read-Host -Prompt "`n(yes|no)"

if (( $read.Length -ne 0 ) -and ( $read.ToUpper() -cmatch 'YES')) {
    
    Write-Host "Appending psmodulepath`ndo the appending....`netc"    

    # TODO appending
    #$mod_path = ${env:USERPROFILE} + "\Documents\WindowsPowerShell\"
    #$mod_path = "C:\Users\HaroldFinch\Documents\WindowsPowerShell\Modules"
    #$env:psmodulepath = $env:psmodulepath + ";" + $mod_path
    
    Write-Host -ForegroundColor Green "psmodulepath appended"
    Write-Host "Module-Paths:`n"${env:psmodulepath}.Replace(";","`n")
}

#---------------------------------------------------------[Modules]------------------------------------------------------------
# this block makes 1 (ONE) directory for 1 (ONE) module file taken from a repository
# modules in the directory NOT in the repo are left alone


#############################################################################
#
#    TODO Make a list of suitable scripts to copy?
#    TODO Execution Policies
#    TODO get the psmodulepath dynamically
#
#############################################################################
#
# 0 = userpath
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/
#
#############################################################################

$mod_path = ${env:psmodulepath}.Split(';')[0]

if ($recurse -eq $true ){  

    $modules = Get-ChildItem -Path $modules_dir -Filter "*.ps1" -Recurse
}
else {

    $modules = Get-ChildItem -Path $modules_dir -Filter "*.ps1"
}

if ((Test-Path -Path $mod_path) -ne $true ) {

    New-Item -Path $mod_path -ItemType Directory | Out-Null
    Write-Host -ForegroundColor Green "`nCreated Path "$mod_path
}

Write-Host "`nCreating Powershell Modules in $mod_path`n"

foreach ( $module in $modules ) {

   $container = New-Item -Path ( Join-Path -Path $mod_path -ChildPath $module.BaseName ) -ItemType Directory -Force
    
    if ((Test-Path -Path $container) -eq $true)  {   
     
        if (($container.EnumerateFiles().Extension) -eq '.psd1') {

            Remove-Item -Path $container.EnumerateFiles().fullname

        }   

        Copy-Item -Path $module.FullName -Destination $container
        Get-ChildItem -Path $container |`
        Rename-Item -NewName { $_.BaseName + $_.Extension.Replace('.ps1', '.psd1') } -Force

        Write-Host "Created Module "$container.Name
    }

    else {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Could not create directory and / or move files"
        Write-Host $ErrorMessage 
               
    }
}

Write-Host -ForegroundColor Green "`nModule Creation complete `n"
