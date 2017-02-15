#Construct an out-array to use for data export
$OutArray = @()
#The computer loop you already have
$serverlist = Get-ChildItem -Path "C:\OPTITOOL\Suez\opt\tsp_osm\log" -Recurse -Include "*.txt"
foreach ($server in $serverlist) {
    $tempObj = ($server).ToString()
    $OutArray += $tempObj 
    $tempObj = $null
    }
    #$server | gm

#After the loop, export the array to CSV
$outarray

$server = ""


    {
        #Construct an object
        $myobj = "" | Select "computer","Speed","Regcheck"
        $myobj | gm
        #fill the object
        $myobj.computer = $computer
        $myobj.speed = $speed
        $myobj.regcheck = $regcheck

        #Add the object to the out-array
        $outarray += $myobj

        #Wipe the object just to be sure
        $myobj = $null
    }
 
########################################################################################################
########################################################################################################
    
$colAverages = @()

$colStats = Import-CSV C:\Scripts\Test.txt

foreach ($objBatter in $colStats)
  {
    $objAverage = New-Object System.Object
    $objAverage | Add-Member -type NoteProperty -name Name -value $objBatter.Name
    $objAverage | Add-Member -type NoteProperty -name BattingAverage -value ("{0:N3}" -f ([int] $objBatter.Hits / $objBatter.AtBats))
    $colAverages += $objAverage
  }

$colAverages | Sort-Object BattingAverage -descending

########################################################################################################
########################################################################################################

Get-EventLog -log Application | select source -unique
Get-EventLog -log system | select source -unique

########################################################################################################
########################################################################################################

Get-Service -ComputerName gil | Where-Object { $_.status -match 'stopped' -and $_.starttype -match 'Automatic'} | select *


Get-NetTCPConnection -RemoteAddress 138.201.14.51