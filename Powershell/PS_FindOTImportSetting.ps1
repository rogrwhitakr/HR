
function Find-OPTITOOLImportSetting {

<#
.SYNOPSIS
  Find Import Settings by keyword

.DESCRIPTION
  This function, if provided with the proper OPTITOOL Application Server path and a keyword will return the names, directories and settings of all files containing settings with the specified keyword. Best used in conjunction with Cmdlet "Out-GridView"

.PARAMETER <Parameter_Name>
    <OptitoolServerPath = mandatory; OPTITOOL Server Directory OptitoolSetting = Mandatory; settings keyword
    >

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
  Version:        1.0
  
.EXAMPLE
  Find-OPTITOOLImportSetting -OptitoolServerPath "C:\Customer\Server\apache-tomee-plus-1.7.4\updateScripts\update" -OptitoolSetting "Contingent" ---  Lists all files containing settings regarding contingents.

  Find-OPTITOOLImportSetting -OptitoolServerPath "apache-tomee-plus-1.7.4\updateScripts\db-setup-components" -OptitoolSetting "ot.action.Show" --- Lists all Database setup component files containing a "show" - action.
#>

    [CmdletBinding()]

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
        if ($setting) {
            $result = New-Object System.Object
            $result | Add-Member -MemberType "NoteProperty" -Name "Directory" -Value $file.Directory
            $result | Add-Member -MemberType "NoteProperty" -Name "Filename" -Value $file.Name
            $result | Add-Member -MemberType "NoteProperty" -Name "Setting" -Value $setting.Line
        }
 
        $resultset += $result
    }

    $resultset
        
}
    
Find-OPTITOOLImportSetting -OptitoolServerPath "D:\Arla\DK\Server\apache-tomee-plus-1.7.4\updateScripts\update" -OptitoolSetting "Price"  | Out-GridView
