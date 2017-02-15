
function Find-OPTITOOLSetting {

    param
        (
        
        [String]
        [Parameter(Mandatory)]
        $OptitoolServerPath,
        [String]
        [Parameter(Mandatory)]
        $OptitoolSetting      
          
        )

### execution ###

        Set-Location -Path $OptitoolServerPath
        $files = Get-ChildItem -Include *.xml -Recurse

        $resultset = @()

    foreach ($file in $files) {

        $setting = Get-Content -Path $file | Select-String -Pattern $OptitoolSetting
        
        $result = New-Object System.Object
        $result | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value $file.DirectoryName
        $result | Add-Member -MemberType "NoteProperty" -Name "Setting" -Value $setting.Line
 
        $resultset += $result
    }

    $resultset | Format-list
        
}
    
Find-OPTITOOLSetting -OptitoolServerPath "D:\Arla\DK\Server\apache-tomee-plus-1.7.4\updateScripts\update" -OptitoolSetting "Contingent"




Set-Location -Path D:\Arla\DK\Server\apache-tomee-plus-1.7.4\updateScripts\update
$files = Get-ChildItem -Include *.xml -Recurse
$setting = Get-Content -Path $files | Select-String -Pattern $OptitoolSetting
$resultset = @()

    foreach ($file in $files) {

        $setting = Get-Content -Path $file | Select-String -Pattern $OptitoolSetting
        
        $result = New-Object System.Object
        $result | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value $file.DirectoryName
        $result | Add-Member -MemberType "NoteProperty" -Name "Setting" -Value $setting.Line
 
        $resultset += $result
    }

    Write-Host $resultset


        $setting = Get-Content -Path $files | Select-String -Pattern $OptitoolSetting



Write-Host Status Server : $as %{ $_.status }

    

    foreach ($file in $files) {

        $resultset = ,@()
        $resultset += ,@($file.DirectoryName, $setting.Line)

        $resultset[1][1]
                
    }








        
        $calc  = New-TimeSpan -Start $start -End $end -ErrorAction SilentlyContinue
        if($calc -lt 0) {$notation = "Optimisation incomplete"} else {$notation = ""}
 
        $result | Add-Member -MemberType "NoteProperty" -Name "SessionName" -Value ($logfile.Directory).Name
        $result | Add-Member -MemberType "NoteProperty" -Name "StartTime" -Value $start
        $result | Add-Member -MemberType "NoteProperty" -Name "EndTime" -Value $end
        $result | Add-Member -MemberType "NoteProperty" -Name "Duration (in Seconds)" -Value ($calc).TotalSeconds
        $result | Add-Member -MemberType "NoteProperty" -Name "Notation" -Value $notation
 
        $resultset += $result

