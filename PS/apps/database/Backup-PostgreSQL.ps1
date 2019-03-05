function Find-Executable {
    param (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)] 
        [ValidateNotNullOrEmpty()]
        #        [ValidatePattern('*exe$')]
        $Executable
    )
    # 1st we would look in the path
    # if itrs there, awesome:
    try {
        if (get-command $Executable -ErrorAction SilentlyContinue) {
            Write-Verbose "Found executable on environment paths (env:)"
            return [System.IO.FileInfo] (get-command $Executable).Definition 
        }
        else {
            # we first look in 64 bit program files
            $exec = Get-ChildItem -Path ${env:ProgramFiles} -Name $Executable -Recurse | Select-Object -First 1

            # if it is not empty, we assume we found it and prepend the full path
            If ($exec) {
                $exec = Join-Path -Path ${env:ProgramFiles} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles} -Name $Executable -Recurse | Select-Object -First 1)
                Write-Verbose "found executable (64-bit): $exec"
                return [System.IO.FileInfo] $exec
            }
            # now we look in 32 bit programs
            else {
                $exec = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name $Executable -Recurse | Select-Object -First 1
                If ($exec) {
                    $exec = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name $Executable -Recurse | Select-Object -First 1)
                    Write-Verbose "found executable (32-bit): $exec"
                    return [System.IO.FileInfo] $exec
                }
                else {
                    Write-Warning "no executable Found!"
                    break
                }
            }
        }
    }
    catch {
        Write-Error "$_"
    }
}


function Backup-Postgresql {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Compression Method")] 
        [ValidateNotNullOrEmpty()]
        $DatabaseServerHost,

        [Int]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Port")] 
        [ValidateRange(1, 65123)]     
        $Port,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database")] 
        [ValidateNotNullOrEmpty()]
        $Database,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "File/Directory to backup to")]
        [ValidateScript( {Test-Path $_ })]
        $BackupPath

    )
    try {

        # first we get the backup tool
        $backup_tool = Find-Executable -Executable "pg_dump.exe"

        # normalize stuffs
        if (!$Port) {
            Write-Verbose "using PostgresQL default Port (5432)"
            $Port = 5432
        }

        # construct a path
        $date = (get-date).tostring("yyyy-MM-dd")
        $backup = $BackupPath + "\" + $date + "_" + $Database + ".sql"
        Write-Verbose "Backup @ $backup"

        # do the backup
        Start-Process -FilePath $backup_tool.FullName -ArgumentList '-h', $DatabaseServerHost, '-p', $Port, '-U' , 'postgres', '-d', $Database, '-v' -RedirectStandardOutput $backup -WorkingDirectory $backup_tool.Directory -Wait -WindowStyle minimized
        Write-Verbose -Message "backup complete"
    } 
    catch {
        "what"
    }
}

Backup-Postgresql -DatabaseServerHost '192.168.0.200' -Database 'redmine' -BackupPath 'C:\Tools\database' -Verbose