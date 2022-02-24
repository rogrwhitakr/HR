# change the creationtime of a file

function New-FileTime {

    [CmdletBinding()]
    param (
        [string]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $File,

        [System.DateTime]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $DatetimeSet
    )

    $file = Get-ChildItem -Path $File

    (Get-Item $File).creationtime = $DatetimeSet
    (Get-Item $File).lastaccesstime = $DatetimeSet
    (Get-Item $File).lastwritetime = $DatetimeSet

}

$a = Get-Date
$a = $a.AddDays(-45)

New-FileTime -File 'C:\OPTITOOL\Adolf_Roth\01_AS\apache-tomee-plus-7.0.4\LICENSE' -DatetimeSet $a