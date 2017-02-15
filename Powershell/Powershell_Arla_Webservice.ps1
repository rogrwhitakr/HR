
function Sort-WSBackup {

    param
        (
        
            [String]
            [Parameter(Mandatory)]
            $Path
        
        )

    # set variables

        $imports = @("getScenarios","addCustomer","updateCustomer","addRepositoriesWithOptions","updateOrderWithOptions","Maintain")

        Set-Location -Path $Path

        $files = Get-ChildItem -Include *.xml -Recurse

    #begin

    foreach ($file in $files) {

        foreach ($import in $imports) {

            if (($file).Name.Contains($import) -eq $true) {
  
                $folderdate = ($file.creationtime)

                if ((Test-Path -Path (Join-Path ($file.DirectoryName) -ChildPath ($import))) -eq $false) {

                    $import_directory = New-Item -ItemType Directory -Path (Join-Path ($file.DirectoryName) -ChildPath ($import))

                    if ((Test-Path -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($import) -ChildPath $folderdate.ToString('yyyy-MM-dd')))) -eq $false) {

                        $final_directory = New-Item -ItemType Directory -Path (Join-Path ($file.DirectoryName) -ChildPath (Join-Path ($import) -ChildPath $folderdate.ToString('yyyy-MM-dd')))

                        Move-Item -Path $file -Destination $final_directory

                    }
 
                }
 
            }

        }

    }

}

Sort-WSBackup -Path D:\Arla\DK\Server\apache-tomee-plus-1.7.4\backup_play



