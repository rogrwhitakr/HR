﻿####################################################################################################
#  Variables
####################################################################################################

$file = 

$FILE = 

$computers = @{1="REESE";2="CARTER";3="FINCH";4="SERVER";5="DOMAIN"}

$fileName = "gold-standard.xml"

$NetworkPath = "\\REESE\Netzlaufwerk\_sort\"

$XMLfile = "OutPut_{0:yyyy-MM-dd_HH-mm}.xml" -f (Get-Date) 

$reportlocation = "C:\inetpub\wwwroot"

$css = Get-Content -Path "$reportlocation\report.css"

$virtualbox = $env:VBOX_MSI_INSTALL_PATH

####################################################################################################
#  Session Variables
####################################################################################################

Set-Alias gh get-help

####################################################################################################
####################################################################################################

 
function Get-Cksum ($file) {
	$sum=0
	get-content -encoding byte -read 10kb $file | %{foreach ($byte in $_) { $sum += $byte }}
	write-host $sum
}

# output Information CSV | XML | HTML

Get-Service | ? {$_.Status -eq "running"} | 
    Select-Object -Property Name,DisplayName,Status | 
    ConvertTo-Csv -Delimiter "|" -NoTypeInformation | Out-File -Encoding ascii .\Desktop\services.csv 

Get-Service | ? {$_.Status -eq "running"} | 
    Select-Object -Property Name,Status,DisplayName | 
    ConvertTo-Xml | Out-File  .\Desktop\services.xml 

get-process | Select-Object -Property processname,id,ws | Sort-Object -Property cpu -Descending | 
    Export-Clixml  .\Desktop\processes.xml


# get all shortcuts in PowerShell ISE

$gps = $psISE.GetType().Assembly
$rm = New-Object System.Resources.ResourceManager GuiStrings,$gps
$rs = $rm.GetResourceSet((Get-Culture),$true,$true)
$rs | where Name -match 'Shortcut\d?$|^F\d+Keyboard' | Sort-Object Name | Format-Table -AutoSize

# comparing files , using network drive location to do biznez

$fileName = "gold-standard.xml"
$networtPath = "\\REESE\Netzlaufwerk\_sort\"

compare -ReferenceObject (Import-Clixml -Path $networtPath$filename) -DifferenceObject (Get-Process) -Property processname,company

# bulk-rename files

$i = 0 
ForEach-Object {
    $extension = $_.Extension
    $newName = 'pic_{0:800#}{1}' -f  $i , $extension 
    $i++ 
    Rename-Item -Path $_.FullName -NewName $newName 
}

#name file after daytime

$filename = "OutPut_{0:yyyy-MM-dd_HH-mm}.xml" -f (Get-Date) 

ps | ConvertTo-Xml | Out-File $path$filename   

# do some reporting via html-file
$css = Get-Content -Path "$reportlocation\report.css"
$reportlocation = "C:\inetpub\wwwroot"
Get-EventLog -LogName System | Where-Object {$_.EventID -eq 7045} | 
    Select-Object EventID,MachineName,TimeGenerated,Message | 
    ConvertTo-Html -Title "DOMAIN Server Report" -Head "<style>$css</style>" | 
    out-file $reportlocation\indicators.html

Get-EventLog -LogName System | Where-Object {$_.EventID -eq 7045} | 
    Select-Object EventID,MachineName,TimeGenerated,Message | 
    ConvertTo-Html -Title "DOMAIN Server Report" -Head "<style>TABLE{border-width: 1px; border-style: solid; border-color: black; border-collap
se: collapse;}TH,TR,TD{border-width: 1px;padding: 10px;border-style: solid;border-color: black;}</style>" | 
    out-file C:\inetpub\wwwroot\indicators.html

	Get-ChildItem -Path Z:\MyScripts -Recurse -Include *.*| Select-Object -Property name , lastwritetime , Extension  | 
    Sort-Object -Descending lastwritetime  | Out-File .\Desktop\files.txt

