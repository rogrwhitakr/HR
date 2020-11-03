$files = Get-ChildItem -Path . 

function Remove-Annotations {
    param (
        [System.String]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        $FileDirectory
    )

    $files = Get-ChildItem -Path $FileDirectory -File *.xml

    foreach ($file in $files){

        $new_name = $file.Directory.FullName + '\new\' + $file.BaseName+ '-' + (Get-Date -Format yyyy-MM-dd_HH-mm) + $file.Extension
        $newest_name = $file.Directory.FullName + '\new\' + $file.BaseName + $file.Extension

        # remove annoation fields
        Get-Content -Path $file -Encoding utf8|`
            Select-String -Pattern "<annotation" -notmatch | `
            Out-File $new_name -Encoding utf8 
        
        # remove empty lines
        Get-Content -Path $new_name -Encoding utf8 | Where-Object {$_.trim() -ne "" } | set-content -Encoding utf8 $newest_name
        Remove-Item -Path $new_name

        # remove grp
        Get-Content -Path $newest_name -Encoding utf8 | ForEach-Object {$_ -replace "grp1=`"`"","" } | set-content $new_name -Encoding utf8       
        Remove-Item -Path $newest_name        
        
        # remove grp
        Get-Content -Path $new_name -Encoding utf8 | ForEach-Object {$_ -replace "grp2=`"`"","" } | set-content $newest_name -Encoding utf8       
        Remove-Item -Path $new_name

    }
}

Remove-Annotations -FileDirectory C:\repos\HR\files-folders-executables\