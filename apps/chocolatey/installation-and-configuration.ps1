# install (from privileged prompt)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# upgrade
choco upgrade chocolatey

# install package
choco install package
choco install pgadmin4

# get the current in cache config
choco list -lo -r -y | Foreach-Object { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" }

choco list -lo -r -y | Foreach-Object { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" />" }


# get the currently installed list without added firleyfans
choco list -lo -r -y | Foreach-Object {$($_.SubString(0, $_.IndexOf("|")))}

# use the configuration
choco install {path-to-file.config} --yes

# install from configuration file
choco install packages.config

# update all installed things
choco upgrade all