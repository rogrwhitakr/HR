
#$files = Get-ChildItem -Path "D:\VMI\_admin" -Filter "*.xml"

#foreach ($file in $files) {
#  #  [regex]::Match("hu"|"sk"|"cr")
#    Rename-Item -Path -NewName -WhatIf
#}

$files = Get-ChildItem -Path "$PSScriptRoot\master-data-templates" -Filter "*.xml"

$curr_dir = Get-Location

Set-Location -Path $files.DirectoryName[0]

foreach ($file in $files) {
  $pattern = [Regex]::new('^\d\d_*')
  if ($pattern.Matches($file)) {
    Write-Host "somesin"
  }

  # remove numbering scheme
  $newname = $file.Name -replace '^\d\d*',''
  
  # remove leading "_"
  $newname = $newname -replace '^_',''

  # remove something else
  $newname = $newname -replace '([_-]TEMPLATE)',''

  Write-Host $newname
  Rename-Item -Path $file -NewName $newname -Force
}

Set-Location $curr_dir