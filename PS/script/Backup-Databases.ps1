Function Use-7ZipCompression {

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

    Use-7ZipCompression -Method Extract -Path ".\Pictures" -Archive ".\Desktop\2017.7z"

        Extract archive ".\Desktop\2017.7z" to the directory ".\Pictures"

    Use-7ZipCompression -Method Update -Path ".\Pictures" -Archive ".\Desktop\2017.7z"

        Update archive ".\Desktop\2017.7z" with the contents of the directory ".\Pictures"
#>

    param (

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
#        [ValidateScript({Test-Path $_ -include *.zip,*.7z})]
        $Archive
    )

    BEGIN {

        try {
        
            $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name "7z.exe" -Recurse  )     
        
        }

        catch {

            $ErrorMessage = $_.Exception.Message
            Write-Log -Path $logfile -Level Error -Message 'An Error occurred. Please assign the Path to the Executable 7zip.'
            Write-Log -Path $logfile -Level Error -Message $ErrorMessage

        }
    }

    PROCESS {

        switch ($Method) 
            { 
                Add {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' to ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path
                } 
                
                Delete {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' from ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path
                } 
                
                Extract {
                    Write-Log -Path $logfile -Level Info -Message ($Method + 'ing file ' + $save + ' from ' + $archive)
                    Start-Process -FilePath $tool -ArgumentList 'x', '-mx9','-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized
                } 
                
                Test {
                    Start-Process -FilePath $tool -ArgumentList 't', '-mx9','-scsUTF-8 ', $archive

                } 
                Update {
                    Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path

                } 
                default {
                    Write-Log -Path $logfile -Level Warn -Message 'No Method selected!'
                }
            }
    }
}
function Resolve-PatternInPath {

<#
.SYNOPSIS
  Resolve-PatternInPath

.DESCRIPTION
  This function validates a path, to check against a subset of path.

.PARAMETER
  Path    = path to check
  Pattern = pattern to check against
    
.OUTPUTS
  returns resolved path

.NOTES
  Version:        1.1
  
.EXAMPLE
  ckeck if path contains pattern 
  Resolve-PatternInPath -Path 'D:\Engine\service\log' -Pattern 'service\log' | fl
#>

    [CmdletBinding()]
    param
        (
        [String]
        [Parameter( Mandatory=$true, ValueFromPipeline = $true)]
        $Path,
        [String]
        [Parameter( Mandatory=$true, ValueFromPipeline = $true)]
        $Pattern
        )

    try {      
    
        if ((Test-Path -Path $Path) -eq $true ) {
            if ( $Path.Contains($Pattern)) {
                $resolved = Resolve-Path -Path $Path
                return $resolved
            }
        }
    }

    catch {

        $ErrorMessage = $_.Exception.Message
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails

   }

}

function New-MySQLBackup() {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MySQLhost,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MySQLuser,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MySQLpassword,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MySQLDatabase,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MySQLBackupPath
    )

    # map to local var, maybe this is useful later
    $MySQLArgs = @{
        host                = $MySQLhost;
        user                = $MySQLuser;
        password            = '-p' + $MySQLpassword;
        database            = $MySQLDatabase;
        backupPath          = $MySQLBackupPath;
        protocol            = 'tcp';
        port                = '3306';
        defaultCharacterSet = 'utf8mb4';
    }


    # SE Variant: we take the provided one
    $tool = '.\mysqldump.exe'

    if (!(get-childItem -Path $tool) ) {
        $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath (Get-ChildItem -Path ${env:ProgramW6432} -Name "mysqldump.exe" -Recurse | Select-Object -first 1)
    }

    # compute backup name
    $backup = [string]::format("{0}\{1}_{2}.sql", $MySQLArgs.backupPath, $MySQLArgs.database, (get-date).tostring("yyyy-MM-dd"));
    try {
        if (get-childItem -Path $tool) {
            Start-Process `
                -FilePath $tool -ArgumentList `
                '--host', $MySQLArgs.host , `
                '--user', $MySQLArgs.user , `
                $MySQLArgs.password , `
                '--databases', $MySQLArgs.database `
                -RedirectStandardOutput $backup -NoNewWindow -PassThru -Wait
        }
    }
    catch {
        Write-Verbose -Message $_.Exception
    }
}

#New-MySQLBackup -MySQLhost localhost -MySQLuser user -MySQLpassword password -MySQLDatabase 'database' -MySQLBackupPath 'D:\db_backup'

$compression = '7Z'
$compression = 'Zip'
$logname = 'Administrator_ManualBackup'
$BackupPath = 'H:\Backup'
$BackupName = 'Manual_backup'
