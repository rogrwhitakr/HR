

############################################################################
# create a new stopwatch 
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
 
# run a command 
Get-Hotfix
 
# stop the stopwatch, and report the milliseconds 
$stopwatch.Stop()
$stopwatch.Elapsed.Milliseconds
 
# continue the stopwatch
$stopwatch.Start()
# $stopwatch.Restart()  # <- resets stopwatch 
 
# run another command 
Get-ChildItem -Path $env:windir
 
# again, stop the stopwatch and report accumulated runtime in milliseconds 
$stopwatch.Stop()
$stopwatch.Elapsed.Milliseconds 

#########################################################################

# measure-script-speed
$loadtime = [System.Diagnostics.Stopwatch]::StartNew()
$loadtime.Stop()
Write-Host -ForegroundColor Cyan "Profile loading took" $loadtime.Elapsed.Milliseconds "Milliseconds"

#########################################################################
# measure-object

"{0:N2} GB" -f ((Get-ChildItem -Path 'C:\VM' | Measure-Object $_.Length -sum).Sum /1GB)

# get local dir stuffs
Get-ChildItem -Path . | Measure-Object -property length -average -sum -maximum -minimum

# any command will do, i hope
Get-ChildItem | Get-Member | Where-Object {$_.MemberType -eq 'Property'}
Get-ScheduledTask| Get-Member | Where-Object {$_.MemberType -eq 'Property'} 

Get-ChildItem -Path . | Measure-Object -property Exists -average -sum -maximum -minimum
Get-ChildItem -Path . | Measure-Object -property CreationTime -average -sum -maximum -minimum
Get-ChildItem -Path . | Measure-Object -property Attributes -average -sum -maximum -minimum

Get-ChildItem -Path 'C:\VM'| Get-Member | Where-Object {$_.MemberType -eq 'Property'} 

# measure object needs to be passed a sensible thing to measure against

