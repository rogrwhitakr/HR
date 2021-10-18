# one-liner

Get-ChildItem *.failed | Rename-Item -NewName { $_.name -Replace '\.failed$','' }

Get-ChildItem | rename-item -newname {  $_.name  -replace ".failed",""  }