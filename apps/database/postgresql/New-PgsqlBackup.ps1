
# do the dump of the existing things
# requires pgsqldump.exe

function New-pgsqlBackup() {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $pgsqlhost,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $pgsqluser,

        [securestring]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $pgsqlpassword,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $pgsqlDatabase,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $pgsqlBackupPath
    )

    # map to local var, maybe this is useful later
    $pgsqlArgs = @{
        host                = $pgsqlhost;
        user                = $pgsqluser;
        password            = $pgsqlpassword;
        database            = $pgsqlDatabase;
        backupPath          = $pgsqlBackupPath;
        protocol            = 'tcp';
        port                = '5432';
        defaultCharacterSet = 'utf8mb4';
    }

    # we input the executable using the commandline?
    pg_dump = $1
    if (!(get-childItem -Path $tool)) {
        Write-Error "no path to pg_dump executable found!"      
        exit 1
    }

    # compute backup name
    $backup = New-BackUpFileName -DatabaseName $pgsqlArgs.pgsqlDatabase

    # execute
    try {
        if (get-childItem -Path $tool) {
            Start-Process `
                -FilePath $tool -ArgumentList `
                '--host', $pgsqlArgs.host , `
                '--user', $pgsqlArgs.user , `
                $pgsqlArgs.password , `
                '--databases', $pgsqlArgs.database `
                '--verbose' `
                -RedirectStandardOutput $backup -NoNewWindow -PassThru -Wait
        }
    }
    catch {
        Write-Verbose -Message $_.Exception
    }
}

#New-pgsqlBackup -pgsqlhost localhost -pgsqluser northernlights.one -pgsqlpassword northernlights.one -pgsqlDatabase 'northernlights.database' -pgsqlBackupPath 'D:\010_db_backup\sales'
#Set-Location -LiteralPath $PSScriptRoot
#New-pgsqlBackup -pgsqlhost localhost -pgsqluser northernlights.one -pgsqlpassword (ConvertTo-SecureString "northernlights.one" -AsPlainText -Force) -pgsqlDatabase 'northernlights.database' -pgsqlBackupPath 'D:\_databases\pgsql'


# we return an name with the weekday, so we can have 7 different backups

function New-BackUpFileName {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $DatabaseName
    )

    return [string]::format("{0}_{1}.{2}", $DatabaseName, (get-date).DayOfWeek, "sql");
}

New-BackUpFileName -DatabaseName ot_test


    # Variant 1: we take the provided one
    $tool = '.\pgsqldump.exe'

    if (!(get-childItem -Path $tool) ) {
        $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath (Get-ChildItem -Path ${env:ProgramW6432} -Name "pgsqldump.exe" -Recurse | Select-Object -first 1)
    }