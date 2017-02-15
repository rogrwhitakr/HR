
########################################################################################################
#
# Basisverzeichnis der Optimierung, Name der logfiles(extension)
#
########################################################################################################

function Get-OptimisationTime {
    
    param (
        [string] $LogPath = '*',
        [string] $LogFile = '*'
        ) 
         
    $resultset = @()
    $resultfile = Join-Path -Path $LogPath -ChildPath "\OptimisationTimeAnalysis.log"  
    $logfiles = Get-ChildItem -Path $LogPath -Include $LogFile -Recurse
    
    foreach ($logfile in $logfiles) {
        
        $result = New-Object System.Object
        
        $entry = $logfile | Get-Content 

        try {
            $start = ($entry[0]).Substring(0,20)
        }
        catch {
            $start = "1970-01-01 00:00:00"
        }  
        try {
            $end = ($entry[-1]).Substring(0,20)
        }
        catch {
            $end = "1970-01-01 00:00:01"
        }
        
        $calc  = New-TimeSpan -Start $start -End $end -ErrorAction SilentlyContinue
        if($calc -lt 0) {$notation = "Optimisation incomplete"} else {$notation = ""}
 
        $result | Add-Member -MemberType "NoteProperty" -Name "SessionName" -Value ($logfile.Directory).Name
        $result | Add-Member -MemberType "NoteProperty" -Name "StartTime" -Value $start
        $result | Add-Member -MemberType "NoteProperty" -Name "EndTime" -Value $end
        $result | Add-Member -MemberType "NoteProperty" -Name "Duration (in Seconds)" -Value ($calc).TotalSeconds
        $result | Add-Member -MemberType "NoteProperty" -Name "Notation" -Value $notation
 
        $resultset += $result
        
    }
    
    $resultset | Format-Table | Out-File -FilePath $resultfile -Encoding Unicode
    
}

### execution

Get-OptimisationTime -LogPath "C:\OPTITOOL\002_OptEngine\tspservice\log" -LogFile "log.txt"


########################################################################################################
########################################################################################################

Function Set-Compressor {

    $ZipTool = "$env:ProgramFiles\7-Zip\7z.exe"
    Set-Variable -Name alias -Scope global -Value zip 
      
    if (-not (test-path $ZipTool)) {
        throw "Correct path to 7z.exe needed."
    } 
    if (-not (Get-Alias | Where-Object {($_.Name -eq $alias) -and ($_.Definition -eq "C:\Program Files\7-Zip\7z.exe")})) { 
        set-alias $alias $ZipTool 
        Write-Host "Alias = $alias"
    }
    else {
        Write-Host "No Alias created"
    }
}

########################################################################################################

$Source = "c:\BackupFrom\backMeUp.txt" 
$Target = "C:\OPTITOOL\010_db_backup\PS"

zip a -mx=9 $Target $Source
$env:OT_DIR = "C:\OPTITOOL"

($ZipTool).Mode 
&$Ziptool | gm

########################################################################################################
########################################################################################################

function Clean-Optitool {

    $env:OT_CLIENT_DIR = "C:\OPTITOOL\Arla\Client\optitool"
           
        if ( -not (Test-Path -Path $env:OT_CLIENT_DIR) -eq $true ) {
            Set-Variable -Name OT_CLIENT_DIR -Value C:\OPTITOOL\Arla\Client\optitool
        }
 
    Set-Location -Path $env:OT_CLIENT_DIR
    
#-#-#-#-#-#-#    --- Get Directories that have log files in them ---    #-#-#-#-#-#-#

    $imports = @{ 1 = "csv_import"; 2 = "import"; 3 = "log"; 4 = "tdl_import"}
    $dirs = @{ 1 = "log" ; 2 = "archive"; 3 = "backup"; 4 ="failed"}
    
    $locations = @{}
    $counter = 100

    foreach($import in $imports.Values) { 
        $counter++
        foreach($dir in $dirs.Values) {
            $counter++
            if ( (Test-Path -Path ( Join-Path -Path $import -ChildPath $dir )) -eq $true ) {
                $tmp = ( Join-Path -Path $import -ChildPath $dir )
                $locations.add($counter,$tmp)
            }
        }
    } 
    $locations.GetEnumerator() | Sort-Object -Property Name 

            
#-#-#-#-#-#-#    --- Get Directories that have log files in them ---    #-#-#-#-#-#-#

    $imports = @("csv_import","import","log","tdl_import","csv_import_legacy")
    $dirs = @("log","archive","backup","failed","")
    $locations = @()
    
    foreach ( $import in $imports) {
        foreach ( $dir in $dirs) {
            if ((Test-Path -Path (Join-Path -Path $import -ChildPath $dir)) -eq $true) {
                $tmp = (Join-Path -Path $import -ChildPath $dir)
            }
            $locations += $tmp
        }    
    }
    
    
    $csv = ".\csv_import"
    $xml = ".\import"
    $client = ".\log"
    $tdl = ".\tdl_import"
    
    $log = ".\log"
    $archive = ".\archive"
    $backup = ".\backup"
    $failed = ".\failed"
    
    Test-Path -Path ( Join-Path -Path $csv -ChildPath $log)
    
    $locations = @()
    
    foreach ( $location in $locations ) {
        
        Test-Path -Path

        $directoires = New-Object System.Object
        $directoires | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value 
        $directoires | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value 
        
    }
    

#-#-#-#-#-#-#

    
    $executioners = Get-ChildItem -Path $env:OT_DIR -Filter $cleaner -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Fullname
    
    foreach ($executioner in $executioners) {
         cmd.exe /c ($executioner).FullName 
    }
}             
#         $log = New-Object System.Object
#         $cmdout = Start-Process -FilePath $executioner
#         $log | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value ($executioner).Fullname         
#         $log | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value $cmdout
#         $logging += $log
#    $logging = @()
     
#     $logging | Format-Table | Out-File -FilePath $FILE
    


Start-Process C:\Path\file.bat
$out = Start-Process -FilePath C:\OPTITOOL\ErikWalther\Client\optitool\!cleanLogs.bat
cmd.exe /c '\my-app\my-file.bat'

########################################################################################################
########################################################################################################

# MAL ANSEHEN !!!

$reader = new-object System.IO.StreamReader("C:\Exceptions.log")
$count = 1
$fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
while(($line = $reader.ReadLine()) -ne $null)
{
    Add-Content -path $fileName -value $line
    if((Get-ChildItem -path $fileName).Length -ge $upperBound)
    {
        ++$count
        $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
    }
}

$reader.Close()

########################################################################################################
########################################################################################################

$reader = new-object System.IO.StreamReader("$env:XML_IN\FF - Kunden_mit_1_Zeitfenster_template.xml")
$andere = [xml](Get-Content "$env:XML_IN\_Kunden_2_Zeitfenster_frametour.xml")
$env:XML = "C:\OPTITOOL\100_files\xml"
$template = @(Get-Content "$env:XML\_template\customer.xml")
$in = ( $env:XML_IN = "C:\OT_Vertrieb\FreshFoods\Import_neueDaten")
$out = ($env:XML_OUT = "C:\OT_Vertrieb\FreshFoods\Import_neueDaten\xml_out")


$env:XML_IN = "C:\OT_Vertrieb\FreshFoods\Import_neueDaten"

#function am anfang, hier geht es los {

$xmldata = New-Object Xml
$xmldata.Load("$env:XML_IN\demo.xml")

$xmldata | gm

$target = New-Object system.object


$xmldata.optitool.$element
$count = 1
#$elements = @("customer", "order")
$element = "customer"

$Nodes = ($xmldata.optitool.$element[$count])


foreach ( $Node in $Nodes) {
    #datei erzeugen
    $filetarget = "{0}_{1}.{2}" -f ((Get-Date -Format "yyyy-MM-dd"),($xmldata.optitool.$element[$count].GetAttribute("extId")),"xml") 
    New-Item -Path $env:XML_OUT -Name $filetarget -type file -ErrorAction silentlycontinue
    
    #fill file
    $targetdata = $xmldata.optitool.$element[$count]
    $destinationdata = New-Object Xml
    $destinationdata | gm
    $destinationdata.ImportNode($targetdata)


$file = "$env:XML_IN\demo.xml"
$XmlWriter = New-Object System.XMl.XmlTextWriter($file, $null)
$xmlWriter.Formatting = "Indented"
$xmlWriter.Indentation = "4"
 
# Write the XML Decleration
$xmlWriter.WriteStartDocument()
 
# Set the XSL
$XSLPropText = "encoding='UTF-8' standalone='yes'"
$xmlWriter.WriteProcessingInstruction("xml-stylesheet", $XSLPropText)
 
# Write Root Element
$appendix1 = "http://www.w3.org/2001/XMLSchema-instance"
$appendix2 = "http://www.optitool.de/otinterface.xsd"

$xmlWriter.WriteStartElement("optitool", $appendix1)
 
# Write the Document
$xmlWriter.WriteStartElement("Servers")
$xmlWriter.WriteElementString("Name","SERVER01")
$xmlWriter.WriteElementString("IP","10.30.23.45")
$xmlWriter.WriteEndElement # <-- Closing Servers
 
# Write Close Tag for Root Element
$xmlWriter.WriteEndElement # <-- Closing RootElement
 
# End the XML Document
$xmlWriter.WriteEndDocument()
 
# Finish The Document
$xmlWriter.Finalize
$xmlWriter.Flush
$xmlWriter.Close()


    $count++
}   



$XmlWriter | gm | Format-List