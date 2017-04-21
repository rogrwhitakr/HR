﻿Function Use-7ZipCompression {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")] 
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress")]
        [ValidateScript({Test-Path $_ })]
        $Path,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)] 
        #[ValidateScript({Test-Path $_ -PathType ‘Container’})]
        $Destination
    )

    BEGIN {

        $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name "7z.exe" -Recurse  )
        
        Write-Output "Method is $Method "

        $archive = New-Item -ItemType File -Path $Destination -Name ((Get-Date -format 'yyyy-MM-dd') + '7z')

        Write-Output "output file is $archive "
    }

    PROCESS {
        
        Read-Host "gay?"

        switch ($Method) 
            { 
                Add {
                    & $tool a -mx9 -scsUTF-8 $archive $Path 
                } 
                Delete {
                    & $tool d -mx9 -scsUTF-8 $archive $Path 
                } 
                Extract {
                    & $tool e -mx9 -scsUTF-8 -o $output_dir $archive
                } 
                Test {
                    & $tool t -mx9 -scsUTF-8 $archive
                } 
                Update {
                    & $tool u -mx9 -scsUTF-8 $archive $Path 
                } 
                default {
                    Write-Output "No method selected."
                }
            }

    }

}

Use-7ZipCompression

$DestinationPath = "C:\Users\HaroldFinch\Desktop\test.zip"

$archive = Get-ChildItem -Path $DestinationPath\* -Include *.zip,*.7z

if ( ($archive).count -gt 1 ) {
    Write-Output $archive.Name
}


























$tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name "7z.exe" -Recurse  )

& $tool

$file = gci -Recurse -Name "C:\Users\HaroldFinch\workspace\NorthernLights\indigo\Person.java"


switch ($Method) 
    { 
        Add {
            & $tool a -mx9 -scsUTF-8
        } 
        Delete {
            & $tool d -mx9 -scsUTF-8
        } 
        Extract {
            & $tool e -mx9 -scsUTF-8 -o $output_dir
        } 
        Test {
            & $tool t -mx9 -scsUTF-8 ## no file!!!
        } 
        Update {
            & $tool u -mx9 -scsUTF-8
        } 
        default {"No method selected."}
    }

7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup.log

$file = gci -Path "C:\Users\HaroldFinch\workspace\NorthernLights\indigo\Person.java"
$file1 = gci -Path "C:\Users\HaroldFinch\workspace\NorthernLights\indigo\Person.class"

& $tool x -mx9 -scsUTF-8 "C:\Users\HaroldFinch\Desktop\zipfile.zip" "C:\Users\HaroldFinch\Desktop\"
& $tool a -mx9 -scsUTF-8 "C:\Users\HaroldFinch\Desktop\zipfile.zip" $file1

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