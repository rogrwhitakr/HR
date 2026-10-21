
# Task:
 
# remove all folders TWO levels below the given path
Get-ChildItem -Path "D:\northern-lights\*\*\*\*\" -Directory -Recurse | Select-Object -ExpandProperty FullName
   # remove -WhatIf to actually delete
   # ATTENTION: test thoroughly before doing this!
   # you may want to add -Force to Remove-Item to forcefully delete
   Remove-Item -Recurse -WhatIf


# Find All Files Two Levels Deep
Get-ChildItem -Path c:\windows -Filter *.log -Recurse -Depth 2 -File -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName   
Get-ChildItem -Path c:\windows -Filter *.log -Recurse -Depth 2  2  -File -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName   

$pattern = '^[0-9]{1-6}'
Get-ChildItem -Path 'D:\*\' -Directory | where-Object -Property {$_.Name -notmatch $pattern }

# get all paths tha have the folder name "signal" in it
 Get-ChildItem 'E:\IRISXtract' -Directory -Recurse | Where-Object { $_.Name -eq 'signal' } | Select-Object -ExpandProperty FullName

# get the oldest files in these directories
Get-ChildItem 'E:\IRISXtract' -Directory -Recurse | Where-Object { $_.Name -eq 'signal' } | ForEach-Object { Get-ChildItem $_.FullName -File | Sort-Object CreationTime | Select-Object -First 1 @{Name='SignalPath';Expression={$_.DirectoryName}}, FullName, CreationTime }

Get-ChildItem 'E:\IRISXtract' -Directory -Recurse | Where-Object { $_.Name -eq 'data' } | ForEach-Object { Get-ChildItem $_.FullName -File | Sort-Object CreationTime | Select-Object -First 1 @{Name='SignalPath';Expression={$_.DirectoryName}}, FullName, CreationTime }

# get the oldest Mailxy directory within these data directories
Get-ChildItem 'E:\IRISXtract' -Directory -Recurse | Where-Object { $_.Name -eq 'data' } | ForEach-Object { Get-ChildItem $_.FullName -Directory | Sort-Object CreationTime | Select-Object -First 1 FullName, CreationTime }

*x&L9mRFbfO!eCA3hHDk