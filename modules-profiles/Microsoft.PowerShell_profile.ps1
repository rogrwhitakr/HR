Write-Host "using profile..."

# initial setup:
# execute as admin
# $target = "C:\Users\<username>\<OneDrive-folder>\repos\HR\modules-profiles\Microsoft.PowerShell_profile.ps1"
# $profileLink = $PROFILE
# New-Item -ItemType SymbolicLink -Path $profileLink -Target $target

# source some things
# there is no easy way to source this script via 
# $PSScriptRoot / (Get-Location).Path
# dynamically correctly, as it is sourced via symbolic link interactively
# for the moment, i source hardcoded

# HR repository root on this computer is
$repo_path = "C:\Users\benno.osterholt\OneDrive - SEEFELDER GmbH\repos"

Import-Module (join-path -Path $repo_path -ChildPath "HR\modules-profiles\modules\Tooling\Tooling.psm1")

Import-Module (join-path -Path $repo_path -ChildPath "HR\modules-profiles\modules\m365\exchange.psm1")
