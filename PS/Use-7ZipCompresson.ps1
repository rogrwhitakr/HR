#requires -version 2
<#
.SYNOPSIS
    use the 7zip utility for file compression and extraction

.DESCRIPTION
    makes (some) 7zip functionality available 

.PARAMETER <Method>
    provide one of 
    Add, Update, Extract, Delete, Test

.PARAMETER <Path>
    provide to the Path variable a File or directory you want to compress 
    provide to the Path variable a directory you want to extract to

.PARAMETER <Archive>
    provide to the Archive variable a valid archive file 
    the function checks the file extension (*.zip or *.7z)

.NOTES
    Version:        1.0
    Author:         rogrwhikar
    Creation Date:  2017-04-21
    Purpose:        used in a script to be run daily 
  
.EXAMPLE

    Use-7ZipCompression -Method Extract -Path ".\Pictures" -Archive ".\Desktop\2017.7z"

        Extract archive ".\Desktop\2017.7z" to the directory ".\Pictures"

    Use-7ZipCompression -Method Update -Path ".\Pictures" -Archive ".\Desktop\2017.7z"

        Update archive ".\Desktop\2017.7z" with the contents of the directory ".\Pictures"
#>

Function Use-7ZipCompression {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")] 
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
        [ValidateScript( {Test-Path $_ })]
        $Path,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)] 
        [ValidateScript( {Test-Path $_ -include *.zip, *.7z})]
        $Archive
    )

    BEGIN {
        try {
            $tool = find-executable -executable '7z.exe' -Verbose
            Write-Verbose "$Method files from/to $archive using 7zip"
        }

        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Verbose "An Error occurred. Please assign the Path to the Executable 7zip."
            Write-Error $ErrorMessage
        }
    }

    PROCESS {
        switch ($Method) { 
            Add {
                Start-Process -FilePath $tool -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path
            } 
            Delete {
                Start-Process -FilePath $tool -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path
            } 
            Extract {
                Start-Process -FilePath $tool -ArgumentList 'x', '-mx9', '-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized
            } 
            Test {
                Start-Process -FilePath $tool -ArgumentList 't', '-mx9', '-scsUTF-8 ', $archive
            } 
            Update {
                Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path
            } 
            default {
                Write-Error "No method selected."
            }
        }
    }
}