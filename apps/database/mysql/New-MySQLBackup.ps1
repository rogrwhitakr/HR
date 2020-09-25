
# do the dump of the existing things
# requires mysqldump.exe

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

        [securestring]
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


    # Variant 1: we take the provided one
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
                '--verbose' `
                -RedirectStandardOutput $backup -NoNewWindow -PassThru -Wait
        }
    }
    catch {
        Write-Verbose -Message $_.Exception
    }
}

Set-Location -LiteralPath $PSScriptRoot
New-MySQLBackup -MySQLhost localhost -MySQLuser northernlights.one -MySQLpassword (ConvertTo-SecureString "northernlights.one" -AsPlainText -Force) -MySQLDatabase 'northernlights.database' -MySQLBackupPath 'D:\_databases\MySQL'