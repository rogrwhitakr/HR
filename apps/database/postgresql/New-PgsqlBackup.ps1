function New-DatabaseBackupName {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database")] 
        [ValidateNotNullOrEmpty()]
        $Database

    )

    $name = $Database + '_' + (get-date).DayOfWeek + '.sql'
    Write-Verbose -Message "using backup-name $name"
    return $name

}

function Set-PostgresqlParameters {
    param (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database")] 
        [ValidateNotNullOrEmpty()]
        $Database,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Compression Method")] 
        [ValidateNotNullOrEmpty()]
        $User,

        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Compression Method")] 
        $DatabaseServerHost,

        [Int]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Port")] 
        [ValidateRange(0, 65123)]     
        $Port   


    )
        # normalize stuffs
        if (!$DatabaseServerHost) {
            $DatabaseServerHost = 'localhost'
        }

        if (!$Port) {
            $Port = 5432
        }        

    # writing verbose the set datas
    foreach($k in $psql.Keys){Write-Verbose -Message "setting $k -> $($psql[$k])"}

    # map to local var, maybe this is useful later
    return @{
            host                = $DatabaseServerHost;
            user                = $User;
            database            = $Database;
            port                = '5432';
        }
}

function Backup-Postgresql {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database")] 
        [ValidateNotNullOrEmpty()]
        $Database,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database User")] 
        [ValidateNotNullOrEmpty()]
        $User,

        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Compression Method")] 
        $DatabaseServerHost,

        [Int]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Port")] 
        [ValidateRange(0, 65123)]     
        $Port,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "File/Directory to backup to")]
        [ValidateScript( {Test-Path $_ })]
        $BackupPath

    )
    try {

        # first we get the backup tool
        Write-Verbose -Message ("starting Backup-Process")
        $psql_path_exe = Get-ChildItem -Path $psql_path -file "pg_dump.exe"
        Write-Verbose -Message "using pg_dump: $psql_path_exe"

        # construct a path
        $backup = Join-Path -Path $BackupPath -ChildPath (New-DatabaseBackupName -Database $Database -Verbose)
        Write-Verbose -Message "Backup @ $backup"

        # set the args
        $psql = Set-PostgresqlParameters -Database $Database -User $User -Port $Port -DatabaseServerHost $DatabaseServerHost -Verbose
                  
        # do the backup
        Start-Process -FilePath $psql_path_exe.FullName -ArgumentList `
            '--host', $psql.host, `
            '--port', $psql.port, `
            '--username', $psql.user, `
            '--dbname', $psql.database, `
            '-v' `
            -RedirectStandardOutput $backup `
            -WorkingDirectory $psql_path `
            -Wait `
            -NoNewWindow `
            -Verbose

        Write-Verbose -Message "Backup-Process complete"   
        
    } 
    catch {
        Write-Warning -Message $error.ToString()
        Write-Warning -Message "Backup failed."
    }
    finally {
        Write-Verbose -Message "backup finished."  
    }
}

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
                $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -file "7z.exe" -Recurse  )
                Write-Warning "found installed executable 7zip @ $tool"                
            }
            else {
                $tool = Get-ChildItem -Path $Executable -file '7z.exe'
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
                    Start-Process -FilePath $tool.FullName -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path -Verbose -Wait -WindowStyle Hidden
                }

                Delete {
                    Write-Verbose -Message "deleting data from archive $archive"
                    Start-Process -FilePath $tool.FullName -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path -Verbose
                }

                Extract {
                    Start-Process -FilePath $tool.FullName -ArgumentList 'x', '-mx9','-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized -Verbose -Wait
                }

                Test {
                    Start-Process -FilePath $tool.FullName -ArgumentList 't', '-mx9','-scsUTF-8 ', $archive -Verbose

                }
                Update {
                    Write-Verbose -Message "updating data $Path on archive $archive"
                    Start-Process -FilePath $tool.FullName -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path -WindowStyle Hidden -Verbose -Wait

                }
                default {
                    Write-Error "No method selected."
                }
            }       
            }
    End {
        Write-Verbose -Message "done"
    }        
}