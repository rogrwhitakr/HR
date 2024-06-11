
$servers = $env:COMPUTERNAME, 'gil.corp.optitool.de'
$result = @()
$credential = Get-Credential
$option = New-CimSessionOption -Protocol Wsman

foreach ($server in $servers) {

    Write-Warning "Working on Server $server"

    try {
        Write-Verbose "trying to connect to Server $server"
        Test-Connection $server -Count 2 -Quiet
        $session = New-CimSession -ComputerName $server -SessionOption $option -Credential $credential -ErrorAction Stop
    }
    catch {
        Write-Error $_.Exception
    }
    try {
        Write-Host "Working on Server $server" -BackgroundColor DarkGreen
        #Machine 
   #     $computerSystem = Get-CimInstance -Class CIM_ComputerSystem -ComputerName $server -Cimsession $session | Select-Object Manufacturer, Model -ErrorAction Continue #Win32_ComputerSystem 
        #serial Number
        $bios = Get-CimInstance -Class Win32_BIOS  -ComputerName $server -Verbose| Select-Object SerialNumber, SMBIOSBIOSVersion -ErrorAction Continue
        #Motherboad
        $baseBoard = Get-CimInstance -Class win32_baseboard -ComputerName $server -Verbose| Select-Object Manufacturer, Product, SerialNumber, Version -ErrorAction Continue
        #Operating System:
        $operatingSystem = Get-CimInstance -Class CIM_OperatingSystem -ComputerName $server -Verbose| select-Object Caption, OSArchitecture -ErrorAction Continue #win32_OperatingSystem
        #Processor:
        $processor = Get-CimInstance -Class CIM_Processor -ComputerName $server -Verbose| select-Object Name, OSArchitecture, NumberOfCores, NumberOfEnabledCore, NumberOfLogicalProcessors, ProcessorId, PartNumber -ErrorAction Continue #Win32_Processor
        #Memory
        $physicalMemory = Get-CimInstance -Class CIM_PhysicalMemory -ComputerName $server -Verbose| Select-Object DeviceLocator, SerialNumber, Capacity, @{N = "Speed"; Expression = { if (($_.speed -ge '1000000000')) { "$($_.Speed / 1000000000) Gb/s" } Elseif ($_.Speed -gt 0) { "$($_.Speed / 1000000) Mb/s" } } }, 
        PartNumber, Manufacturer -ErrorAction Continue
        #Video Card
        $videoController = Get-CimInstance -Class win32_VideoController -ComputerName $server -Verbose| Select-Object Name, VideoProcessor -ErrorAction Continue
        #Monitor
        $monitor = Get-CimInstance -Class WmiMonitorID -Namespace root\wmi -ComputerName $server -Verbose| Select-Object @{Label = 'ManufacturerName'; Expression = { ($_.ManufacturerName | Foreach-Object { [char]$_ }) -join "" } }, 
        @{Label = 'ProductCodeID'; Expression = { ($_.ProductCodeID | Foreach-Object { [char]$_ }) -join "" } }, 
        @{Label = 'UserFriendlyName'; Expression = { ($_.UserFriendlyName | Foreach-Object { [char]$_ }) -join "" } }, 
        @{Label = 'SerialNumberID'; Expression = { ($_.SerialNumberID | Foreach-Object { [char]$_ }) -join "" } }, 
        YearOfManufacture, WeekOfManufacture -ErrorAction Continue
        #https://www.lansweeper.com/knowledgebase/list-of-3-letter-monitor-manufacturer-codes/
        #Disk
        $diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $server | Select-Object Model, SerialNumber, Size, FirmwareRevision, InterfaceType, Index -ErrorAction Continue
        #Network Adapter
        $networkAdapter = Get-CimInstance -ClassName Win32_NetworkAdapter -ComputerName $server | Where-Object { $_.PhysicalAdapter -eq $true } | Select-Object Name, ProductName, DeviceID, Speed, AdapterType, InterfaceIndex, MACAddress -ErrorAction Continue
        $objInv = New-Object psobject
        $objInv | Add-Member -Name ComputerName -MemberType NoteProperty -Value $server
        $objInv | Add-Member -Name computerSystem -MemberType NoteProperty -Value $computerSystem
        $objInv | Add-Member -Name bios -MemberType NoteProperty -Value $bios
        $objInv | Add-Member -Name baseBoard -MemberType NoteProperty -Value $baseBoard
        $objInv | Add-Member -Name operatingSystem -MemberType NoteProperty -Value $operatingSystem
        $objInv | Add-Member -Name processor -MemberType NoteProperty -Value $processor
        $objInv | Add-Member -Name physicalMemory -MemberType NoteProperty -Value $physicalMemory
        $objInv | Add-Member -Name videoController -MemberType NoteProperty -Value $videoController
        $objInv | Add-Member -Name monitor -MemberType NoteProperty -Value $monitor
        $objInv | Add-Member -Name diskDrive -MemberType NoteProperty -Value $diskDrive
        $objInv | Add-Member -Name networkAdapter -MemberType NoteProperty -Value $networkAdapter
        $result += $objInv
    } 
    catch {
        Write-Host "Connection to server $server failed" -BackgroundColor DarkRed
    } 

    Write-Host $result
} 
#   return $result


$rawJson = (($result | ConvertTo-Json -Depth 3).replace('\u0000', '')) -split "`r`n"

# replace first line
$formatedJson = . {
    'var data = ['
    $rawJson | Select-Object -Skip 1
} 

#replace last Line
$formatedJson[-1] = '];' 
$formatedJson | Out-File $PSScriptRoot\data.js