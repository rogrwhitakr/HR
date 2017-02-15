# Core settings - you will need to set these 
$mysql_server = "gil"
$mysql_user = "root" 
$mysql_password = "opti"
$backupstorefolder= "C:\OPTITOOL\010_db_backup" 
$dbName = "ot_bak"
$pathtomysqldump = "C:\OPTITOOL\005_MySQL\MySQL Server 5.6\bin\mysqldump.exe"

# Determine Today´s Date Day (monday, tuesday etc)
$timestamp = Get-Date -format yyyyMMddHHmmss
Write-Host $timestamp 

[void][system.reflection.Assembly]::LoadFrom("C:\OPTITOOL\005_MySQL\MySQL Server 5.6\bin\MySql.Data.dll")

# Connect to MySQL database 'information_schema'
[system.reflection.assembly]::LoadWithPartialName("MySql.Data")
$cn = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$cn.ConnectionString = "SERVER=$mysql_server;DATABASE=information_schema;UID=$mysql_user;PWD=$mysql_password"
$cn.Open()

# Query to get database names in asceding order
$cm = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
$sql = "SELECT DISTINCT CONVERT(SCHEMA_NAME USING UTF8) AS dbName, CONVERT(NOW() USING UTF8) AS dtStamp FROM SCHEMATA ORDER BY dbName ASC"
$cm.Connection = $cn
$cm.CommandText = $sql
$dr = $cm.ExecuteReader()
 
# Loop through MySQL Records
while ($dr.Read())
{
 # Start By Writing MSG to screen
 $dbname = [string]$dr.GetString(0)
 if($dbname -match $dbName)
 {
 write-host "Backing up database: " $dr.GetString(0)
 
 # Set backup filename and check if exists, if so delete existing
 $backupfilename = $timestamp + "_" + $dr.GetString(0) + ".sql"
 $backuppathandfile = $backupstorefolder + "" + $backupfilename
 If (test-path($backuppathandfile))
 {
 write-host "Backup file '" $backuppathandfile "' already exists. Existing file will be deleted"
 Remove-Item $backuppathandfile
 }
 
 # Invoke backup Command. /c forces the system to wait to do the backup
 cmd /c " `"$pathtomysqldump`" -h $mysql_server -u $mysql_user -p$mysql_password $dbname > $backuppathandfile "
 If (test-path($backuppathandfile))
 {
 write-host "Backup created. Presence of backup file verified"
 }
 }
 
 
# Write Space
 write-host " "
}
 
# Close the connection
$cn.Close()  

# etwas anderes noch

$d= Get-Date
$dString = $d.Year.ToString() + "-" + $d.Month.ToString() + "-" + $d.Day.ToString() + "_" + $d.Hour.ToString() + "-" + $d.Minute.ToString() + "-" + $d.Minute.ToString()
$backupFilePath = "C:\backups\mysql\swisschalet\ee\dev\backupFileName_" + $dString + ".sql"
$cmd = "& 'C:\Program Files\MySQL\MySQL Server 5.5\bin\mysqldump.exe' -u myusername -pMyPwNoSpaceAfterPparam datababase_name > " + $backupFilePath
Write-Host $cmd
invoke-expression $cmd | out-null