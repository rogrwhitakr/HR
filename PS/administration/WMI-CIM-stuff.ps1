
function Find-WmiClass {
    param([Parameter(Mandatory)] $Keyword)

    Write-Progress -Activity "Finding WMI Classes" -Status "Searching"

    # find all WMI classes...
    Get-WmiObject -Class * -List |
        # that contain the search keyword
    Where-Object {
        # is there a property or method with the keyword?
        $containsMember = ((@($_.Properties. Name) -like "*$Keyword*").Count -gt 0) -or ((@($_.Methods. Name) -like "*$Keyword*").Count -gt 0)
        # is the keyword in the class name, and is it an interesting type of class?
        $containsClassName = $_.Name -like "*$Keyword*" -and $_.Properties -like 'Count' -gt 2 -and $_. Name -notlike 'Win32_Perf*'
        $containsMember -or $containsClassName
    }
    Write-Progress -Activity "Find WMI Classes" -Completed
}

$classes = Find-WmiClass

$classes |
    # let the user select one of the found classes
Out-GridView -Title "Select WMI Class" -OutputMode Single |
    ForEach-Object {
    # get all instances of the selected class
    Get-CimInstance -Class $_.Name |
        # show all properties
    Select-Object -Property * |
        Out-GridView -Title "Instances"
}

############################################################################
# Finding Hidden Autostart Programs
############################################################################

Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property Command, Description, User, Location | Out-GridView

############################################################################
#Finding Operating System Architecture Information
############################################################################

Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property *OS*

############################################################################
# Get last Boot time
############################################################################

Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL=’LastBootUpTime’;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

Get-WmiObject Win32_OperatingSystem | Select-Object LastBootUpTime

########################################################################################################
# get windows licence key
########################################################################################################
(Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey


Get-WmiObject -Class Win32_Share -ComputerName sr0710
Get-CimInstance -ClassName Win32_Share -ComputerName sr0710
# (both calls require local Administrator privileges on the target computer, so you may want to add the parameter -Credential and submit a valid account name if your current user does not meet these requirements).
# While Get-WmiObject always uses DCOM as a transport protocol, Get-CimInstance uses WSMan (a webservice-type of communication). Most modern Windows systems support WSMan, but if you need to contact older servers, they may only respond to DCOM, thus Get-CimInstance may fail.
# Get-CimInstance can use session options, however, that provide great flexibility, and allow you to choose the transport protocol. In order to use DCOM (just like Get-WmiObject), do the following:

$options = New-CimSessionOption -Protocol Dcom
$session = New-CimSession -ComputerName sr0710 -SessionOption $options
Get-CimInstance -ClassName Win32_Share -CimSession $session
Remove-CimSession -CimSession $session