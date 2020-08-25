
# READ THROUGH LARGE FILE QUICKLY. OR NOT...

# make sure this file exists, or else 
# pick a different text file that is very large
$path = 'C:\Windows\Logs\DISM\dism.log'
# SLOW 
# filtering text file via pipeline (low memory usage) 
Measure-Command {
  $result = Get-Content -Path $Path | Where-Object { $_ -like '*Error*' }
}
 
# FAST 
# filtering text by first reading in all 
# content (high memory usage!) and then 
# using a classic loop 
 
Measure-Command {
  $lines = Get-Content -Path $Path -ReadCount 0
  $result = foreach ($line in $lines)
  {
    if ($line -like '*Error*') { $line }
  }
}