function Backup-Postgresql {
    param (

    [String]
    [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Compression Method")] 
    [ValidateNotNullOrEmpty()]
    $DatabaseServerHost,

    [Int]
    [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Port")] 
    [ValidateRange(1,65123)]     
    $Port,

    [String]
    [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Database")] 
    [ValidateNotNullOrEmpty()]
    $Database,

    [String]
    [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "File/Directory to backup to")]
    [ValidateScript({Test-Path $_ })]
    $BackupPath

)
    try {

        # we first look in 64 bit program files
        $backup_tool = Get-ChildItem -Path ${env:ProgramFiles} -Name "pg_dump.exe" -Recurse | Select-Object -First 1

        # if it is not empty, we assume we found it and prepend the full path
        If ($backup_tool){
            $backup_tool = Join-Path -Path ${env:ProgramW6432} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles} -Name "pg_dump.exe" -Recurse | Select-Object -First 1)
            Write-Verbose "found backup tool: $backup_tool in Program files"
        }
        # now we look in 32 bit programs
        else {
            $backup_tool = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "pg_dump.exe" -Recurse | Select-Object -First 1
            If ($backup_tool){
                $backup_tool = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name "pg_dump.exe" -Recurse | Select-Object -First 1)
                Write-Verbose "found backup tool: $backup_tool in Program files"
            }
            else {
                break
            }
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "Could not find the pg_dump binary! make sure it is installed (Program Files). $ErrorMessage"
        break
    }
    finally {

        # normalize stuffs
        if (!$Port) {
            Write-Verbose "using PostgresQL default Port (5432)"
            $Port = 5432
        }

        # construct a path
        $date = (get-date).tostring("yyyy-MM-dd")
        $backup = (Get-ChildItem -Path $BackupPath).DirectoryName
        $backup = $backup + $date + "_" + $Database + ".sql"
        Write-Verbose "Backup @ $backup"

        # do the backup
        Start-Process -FilePath $backup_tool -ArgumentList "--host=$DatabaseServerHost",  "--port=$Port", "--username=postgres", "--dbname=$Database", "--verbose", ">", "$backup"
    } 
}

Backup-Postgresql -DatabaseServerHost '192.168.0.200' -Database 'redmine' -BackupPath 'C:\Tools\database' -Verbose
#pg_dump.exe --host=192.168.0.200 --username=postgres --dbname=redmine --verbose > C:\Tools\database\redmine.sql
