
function Clean-Directory {

}

$file = Get-ChildItem -Include 20160829* -Recurse

Set-Location -Path D:\Musik\Verzeichnis

$files = Get-ChildItem -Include *.xml -Recurse


$importname = 'getScenario'

foreach ($file in $files) {

    if (($file).Name.Contains($importname) -eq $true) {

        $datefolder = ($file.creationtime)
 
         if ((Test-Path -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($importname) -ChildPath $datefolder.ToString('yyyy-MM-dd')))) -eq $false) {

            $final_directory = New-Item -ItemType Directory -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($importname) -ChildPath $datefolder.ToString('yyyy-MM-dd')))
    
            Move-Item -Path $file -Destination $final_directory

        }
    
    }

}

function Sort-WSBackup {

    param
        (
        
            [String]
            [Parameter(Mandatory)]
            $Path
        
        )

    # set variables

        $importname = "getScenarios"

        Set-Location -Path $Path

        $files = Get-ChildItem -Include *.xml -Recurse

    #begin

    foreach ($file in $files) {

        if (($file).Name.Contains($importname) -eq $true) {
  
            $folderdate = ($file.creationtime)

            if ((Test-Path -Path (Join-Path ($file.DirectoryName) -ChildPath ($importname))) -eq $false) {

                $import_directory = New-Item -ItemType Directory -Path (Join-Path ($file.DirectoryName) -ChildPath ($importname))

                if ((Test-Path -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($importname) -ChildPath $folderdate.ToString('yyyy-MM-dd')))) -eq $false) {
 
                    $final_directory = New-Item -ItemType Directory -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($importname) -ChildPath $folderdate.ToString('yyyy-MM-dd')))
   
                    Move-Item -Path $file -Destination $final_directory

                }
 
            }
 
        }
  
    }

}

Sort-WSBackup -Path "path"