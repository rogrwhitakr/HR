
#$files = Get-ChildItem -Path "D:\VMI\_admin" -Filter "*.xml"

#foreach ($file in $files) {
#  #  [regex]::Match("hu"|"sk"|"cr")
#    Rename-Item -Path -NewName -WhatIf
#}

$files = Get-ChildItem -Path "C:\MyScripts\northern-lights\CONF\_templates" -Filter "*.xml"

$curr_dir = Get-Location

Set-Location -Path $files.DirectoryName[0]

foreach ($file in $files) {
  $pattern = [Regex]::new('^\d\d*')
  $matches = $pattern.Matches($file)

  $newname = $file -replace '^\d\d*',''
  $newname = $newname -replace '([_-]TEMPLATE)',''

  $newname

  Rename-Item -Path $file.Name -NewName $newname -Force
}

Set-Location $curr_dir