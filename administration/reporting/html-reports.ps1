# there is the most bestest powershell module available for such a thing:

# install comme ca
Install-Module PSWriteHTML -Force
Install-Module PSWriteHTML -Force -Scope CurrentUser

# call like this
Get-Process | Out-htmlview -First 5 -FuzzySearchSmartToggle

# has eveything build into the html file
# - pagination
# - etc

get-service | Where-Object {$_.Status -eq "running"} | Select-Object Name, DisplayName,StartType| Out-htmlview -Title "all running services" -EnableColumnReorder