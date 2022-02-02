function Test-XMLFile {

    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory with xml files to check")]
        [ValidateNotNullorEmpty()]
        [ValidateScript( { Test-Path $_ -include *.xml })]
        $Path
    )

    # Check for Load or Parse errors when loading the XML file
    $xml = New-Object System.Xml.XmlDocument

    try {
        $xml.Load((Get-ChildItem -Path $Path).FullName)
        return $true
    }
    catch [System.Xml.XmlException] {
        return $false
    }
}

function Remove-InvalidXML {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "Directory with xml files to check")]
        [ValidateNotNullorEmpty()]
        $Path,
        [switch]
        [Parameter(Mandatory = $false, Position = 2, HelpMessage = "toggle if you want to remove the files. the default behaviour is to move invalid files")]
        $Remove
    )

    process {
        try {

            [int] $valid = 0
            [int] $invalid = 0
            $filepath = Get-ChildItem -Path  $Path | Where-Object { $_.Extension -eq '.xml' }

            foreach ($file in $filepath) {

                Set-Location -Path $file.DirectoryName
                $result = Test-XMLFile -Path $file.FullName -ErrorAction Continue

                if ($result -eq $false) {

                    if ($Remove -eq $true) {

                        Write-Output "Removing invalid file $file"
                        Remove-Item -Path $file
                        $invalid = $invalid + 1

                    }

                    else {

                        Write-Output "Moving file $file to backup directory"
                        $date = Get-Date -Format 'yyyy-MM-dd'
                        $folder = New-Item -ItemType Directory -Name $date -Force
                        Move-Item -Path $file -Destination $folder
                        $invalid = $invalid + 1

                    }
                }

                else {
                    Write-Output "$file is valid"
                    $valid = $valid + 1
                }
            }
            if ($Remove -eq $true) {
                Write-Output "there were $valid valid XML files, $invalid invalid XML files.`n$invalid XML files have been deleted."
            }

            else {
                Write-Output "there were $valid valid XML files, $invalid invalid XML files.`n$invalid XML files have been moved to a backup folder."
            }
        }

        catch {

            Write-Error $_.Exception.Message
            Write-Error $_.Exception.Details

        }
    }
}