# get the current in cache config
choco list -lo -r -y | Foreach-Object { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" }