# vars
$psql_path = 'C:\Program Files\PostgreSQL\12\bin'
$packup_path = 'C:\Tools\database'
$database_name = 'northern-lights'

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
        Write-Verbose -Message "finished. not sending an email. that would be overkill"  
    }
}

#construct log file path
$log = (Join-path -Path $packup_path -ChildPath ((New-DatabaseBackupName -Database $database_name).TrimEnd('.sql') + '_backup.log'))

# logging
#Remove-Item -Path $log -Force -ErrorAction SilentlyContinue
Start-Transcript -Path $log

# do the backup
Backup-Postgresql -Database $database_name -User 'northern-lights' -BackupPath $packup_path -Verbose
Write-Verbose -Message "finished wit it"

Stop-Transcript -Verbose
