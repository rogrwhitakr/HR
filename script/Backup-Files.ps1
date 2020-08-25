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
  Resolve-PatternInPath -Path 'D:\002_OptEngine\rvoptservice\log' -Pattern 'rvoptservice\log' | fl
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
function Write-Log {

<#
.Synopsis
   Write-Log writes a message to a specified log file with the current time stamp.

.DESCRIPTION
   The Write-Log function is designed to add logging capability to other scripts.
   In addition to writing output and/or verbose you can write to a log file for
   later debugging.

.NOTES
   Created by: Jason Wasser @wasserja
   Modified: 11/24/2015 09:30:19 AM  

   Changelog:
    * Code simplification and clarification - thanks to @juneb_get_help
    * Added documentation.
    * Renamed LogPath parameter to Path to keep it standard - thanks to @JeffHicks
    * Revised the Force switch to work as it should - thanks to @JeffHicks

   To Do:
    * Add error handling if trying to create a log file in a inaccessible location.
    * Add ability to write $Message to $Verbose or $Error pipelines to eliminate
      duplicates.

.PARAMETER Message
   Message is the content that you wish to add to the log file. 

.PARAMETER Path
   The path to the log file to which you would like to write. By default the function will 
   create the path and file if it does not exist. 

.PARAMETER Level
   Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational)

.PARAMETER NoClobber
   Use NoClobber if you do not wish to overwrite an existing file.

.EXAMPLE
   Write-Log -Message 'Log message' 
   Writes the message to c:\Logs\PowerShellLog.log.

.EXAMPLE
   Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log
   Writes the content to the specified log file and creates the path and file specified. 

.EXAMPLE
   Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error
   Writes the message to the specified log file as an error message, and writes the message to the error pipeline.

.LINK
   https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0
#>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$true)]
        [Alias('LogPath')]
        [string]$Path,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process
    {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {

            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return

        }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {

            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File

        }

        else {
            # Nothing to see here yet.
        }

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
    
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
             }
    
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
             }
    
            'Info' {
                Write-Verbose $Message
                $LevelText = 'INFO:'
             }
    
            }
        
        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End
    {
    }
}

#TODOS:
# ability to exclude files / orders!
# maybe based on size...

### Variables

# using 7zip creates 

$compression = '7Z'
$compression = 'Zip'
$logname = 'Administrator_ManualBackup'
$BackupPath = 'H:\Backup'
$BackupName = 'Manual_backup'
$saves = @(
    'C:\MyScripts',
    'C:\Users\Administrator\Documents\WindowsPowerShell',
    'C:\Users\Administrator\Pictures',
    'D:\004_sql',
    'D:\100_demofiles\xml\_template',
    'D:\103_Powerpoint',
    'D:\105_Word',
    'D:\300_Geoserver_documentation',
    'D:\401_TallyDrucker',
    'D:\AF-Bauer\_Dokumente',
    'D:\northern-lights\DK\_admin',
    'D:\northern-lights\UK\_documents',
    'D:\northern-lights\_CE_docs',
    'D:\northern-lights\_Dokumente',
    'D:\BurkKauffmann\_admin',
    'D:\FirestiXX\_documentation',
    'D:\Kronenbrot\_documentation',
    'D:\LITRA\_admin',
    'D:\MOL\_admin',
    'D:\Meggle\_dokumente',
    'D:\Neurauter\_Dokumente',
    'D:\Riemeier\_documentation',
    'D:\Sales\BEV\_docs',
    'D:\Sales\MLK\_Dokumente',
    'D:\Sales\OIL\_admin',
    'D:\Sales\TRP\_admin',
    'D:\Sales\_admin',
    'D:\Suez\_Dokumentation',
    'D:\Ten\_admin',
    'D:\Total\_Server',
    'D:\Varo\_admin',
    'D:\Vitogaz\_admin',
    'D:\Zwettl\_admin'
    )
$saves = @(
    'C:\MyScripts',
    'C:\Users\Administrator\Documents\WindowsPowerShell',
    'C:\Users\Administrator\Pictures',
    'D:\004_sql',
    'D:\100_demofiles\xml\_template',
    'D:\103_Powerpoint',
    'D:\105_Word',
    'D:\300_Geoserver_documentation',
    'D:\northern-lights\DK\_admin',
    'D:\northern-lights\UK\_documents',
    'D:\northern-lights\_CE_docs',
    'D:\northern-lights\_Dokumente',
    'D:\Meggle\_dokumente'
    )


### Exec

#   param (
#       [String]
#       [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")] 
#       [ValidateSet("7Z", "Zip")]     
#       $Method,
#       [String]
#       [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
#       [ValidateScript({Test-Path $_ })]
#       $Path,
#       [String]
#       [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)] 
#        [ValidateScript({Test-Path $_ -include *.zip,*.7z})]
#       $Archive
#   )

if ((Test-Path -Path $BackupPath) -eq $true) {
    
    $logfile = (Join-Path -Path $BackupPath -ChildPath ($logname + '.log'))
    Write-Log -Path $logfile -Level Info -Message 'Backup of ' $PSScriptRoot
    Write-Log -Path $logfile -Level Info -Message 'Backup Path validated.'
} 

else {
    Write-Log -Path $logfile -Level Error -Message 'could not validate the backup path!'
    exit 1
}

foreach ( $save in $saves ) {
    
    if ((Test-Path -Path $save) -eq $true) {

        Write-Log -Path $logfile -Level Info -Message ('Path of directory to be backed up ('+ $save + ') validated.') 

        switch ($compression){

            {$compression -eq '7Z'}
            
            {
            
                try {

                    Use-7ZipCompression -Method Add -Path $save -Archive ( Join-Path -Path $BackupPath -ChildPath $BackupName) 
                    Write-Log -Path $logfile -Level Info -Message ('Compression using 7Zip Executable successful.')

                }
                catch {
    
                    $ErrorMessage = $_.Exception.Message
                    Write-Log -Path $logfile -Level Error -Message "An Error occurred"
                    Write-Log -Path $logfile -Level Error -Message $ErrorMessage

                }

            }

            {$compression -eq 'Zip'}

            {

                try {

                    Write-Log -Path $logfile -Level Info -Message ('Adding file ' + $save + ' to ' + ( Join-Path -Path $BackupPath -ChildPath $BackupName))
                    Compress-Archive -CompressionLevel Optimal -Path $save -DestinationPath ( Join-Path -Path $BackupPath -ChildPath $BackupName) -Update
                    Write-Log -Path $logfile -Level Info -Message ('Compression using PowerShell Compress-Archive successful.')

                }
                catch {
    
                    $ErrorMessage = $_.Exception.Message
                    Write-Log -Path $logfile -Level Error -Message "An Error occurred"
                    Write-Log -Path $logfile -Level Error -Message $ErrorMessage

                }            
            
            }  
        }
    }

    else {

        Write-Log -Path $logfile -Level Warn -Message ('Path of directory '+ $save + ' does not exist.')  

    }
}

Write-Log -Path $logfile -Level Info -Message ('Backup Complete.')

#Set-Location $env:OTDIR

#$all = Get-ChildItem -Depth 2 -Directory -filter _*

#$all | Select-Object FullName