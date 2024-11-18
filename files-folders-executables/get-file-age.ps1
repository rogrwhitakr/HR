
# returns the amount of files based on creation date (and not time)
Get-ChildItem -file | foreach-object {$_.CreationTimeUtc.ToString("yyyy-MM-dd")} | Group-Object