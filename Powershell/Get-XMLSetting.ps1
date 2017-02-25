
function Find-XMLSetting {

<#
.SYNOPSIS
  Find Import Settings by keyword

.DESCRIPTION
  This function, if provided with the proper  Application Server path and a keyword will return the names, directories and settings of all files containing settings with the specified keyword. Best used in conjunction with Cmdlet "Out-GridView"

.PARAMETER <Parameter_Name>
    <ServerPath = mandatory;  Server Directory Setting = Mandatory; settings keyword
    >

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
  Version:        1.0
  
.EXAMPLE

#>

    [CmdletBinding()]

    param
        (
        [String]
        [Parameter(Mandatory)]
        $ServerPath,
        [String]
        [Parameter(Mandatory)]
        $Setting      
          
        )

### execution ###

        Set-Location -Path $ServerPath
        $files = Get-ChildItem -Include *.xml -Recurse

        $resultset = @()

    foreach ($file in $files) {

        $setting = Get-Content -Path $file | Select-String -Pattern $Setting
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
    
Find-XMLSetting -ServerPath "path" -Setting "Price"  | Out-GridView
