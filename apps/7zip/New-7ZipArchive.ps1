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
    7Zip:
    <Commands>
          a: Add files to archive
          b: Benchmark
          d: Delete files from archive
          e: Extract files from archive (without using directory names)
          l: List contents of archive
          t: Test integrity of archive
          u: Update files to archive
          x: eXtract files with full paths
    <Switches>
          -ai[r[-|0]]{@listfile|!wildcard}: Include archives
          -ax[r[-|0]]{@listfile|!wildcard}: eXclude archives
          -bd: Disable percentage indicator
          -i[r[-|0]]{@listfile|!wildcard}: Include filenames
          -m{Parameters}: set compression Method
          -o{Directory}: set Output directory
          -p{Password}: set Password
          -r[-|0]: Recurse subdirectories
          -scs{UTF-8 | WIN | DOS}: set charset for list files
          -sfx[{name}]: Create SFX archive
          -si[{name}]: read data from stdin
          -slt: show technical information for l (List) command
          -so: write data to stdout
          -ssc[-]: set sensitive case mode
          -ssw: compress shared files
          -t{Type}: Set type of archive
          -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName]: Update options
          -v{Size}[b|k|m|g]: Create volumes
          -w[{path}]: assign Work directory. Empty path means a temporary directory
          -x[r[-|0]]]{@listfile|!wildcard}: eXclude filenames
          -y: assume Yes on all queries

.EXAMPLE
    New-7ZipArchive -Executable 'C:\Program Files\7-Zip\7z.exe' -method Update -Path 'C:\tools\database\database.sql' -Archive 'C:\tools\database\database.7z' -Verbose
    New-7ZipArchive -method Update -Path 'C:\tools\database\database.sql' -Archive 'C:\tools\database\database.7z' -Verbose
#>

Function New-7ZipArchive {

    param (

        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")]
        [ValidateScript({Test-Path $_ })]
        $Executable,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")]
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
        [ValidateScript({Test-Path $_ })]
        $Path,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)]
        $Archive
    )

    BEGIN {

        try {
            if (!$Executable){
                $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name "7z.exe" -Recurse  )
                Write-Warning "found installed executable 7zip @ $tool"                
            }
            else {
                $tool = Get-ChildItem -Path $Executable -Name '7z.exe'
            }
            Write-Verbose -Message "using provided 7Zip executable: $tool"    
        }

        catch {
           $ErrorMessage = $_.Exception.Message
            Write-Error "An Error occurred. Please assign the Path to the Executable 7zip."
            Write-Error $ErrorMessage
        }
    }

    PROCESS {

        Write-Verbose -Message "selecting method for archive action"
        switch ($Method)
            {
                Add {
                    Write-Verbose -Message "adding data $Path to archive $archive"
                    Start-Process -FilePath $tool -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path -Verbose -Wait -WindowStyle Hidden
                }

                Delete {
                    Write-Verbose -Message "deleting data from archive $archive"
                    Start-Process -FilePath $tool -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path -Verbose
                }

                Extract {
                    Start-Process -FilePath $tool -ArgumentList 'x', '-mx9','-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized -Verbose -Wait
                }

                Test {
                    Start-Process -FilePath $tool -ArgumentList 't', '-mx9','-scsUTF-8 ', $archive -Verbose

                }
                Update {
                    Write-Verbose -Message "updating data $Path on archive $archive"
                    Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path -WindowStyle Hidden -Verbose -Wait

                }
                default {
                    Write-Error "No method selected."
                }
            }       
            }
    End {

    }        
}