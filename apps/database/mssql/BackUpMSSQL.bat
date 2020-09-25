@echo off

rem ==========================================================
rem Script | backup of MSSQL database(s)
rem	* erstellt einen MSSQL-dump
rem	* erstellt ein Backup - Verzeichnis
rem	* zippt das backup mit 7Zip und verschiebt es
rem ==========================================================
rem Variables
rem * sql_path = Pfad der MSSQL - Installation
rem * zip_path = Pfad der 7Zip - Installation
rem * db_name = Name DB
rem * db_backup = Name der Backup - Datei 
rem ==========================================================

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set mydate=%year%-%month%-%day%
set monthsToKeep=6

set sql_path=C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\
set zip_path=C:\Program Files\7-Zip\
set backup_path=G:\backups\database\MSSQL\


cls

set instance=%ComputerName%\SQLSERVER
echo.
echo This batch script makes a backup of an MSSQL database and stores it in %backup_path%
echo.
cd %sql_path%
sqlcmd -E -S %instance% -Q "sp_databases"
set /p db_name="Enter database name: "
set db_backup=%db_name%
set /p reason="Backup reason: "
set backup_log=%backup_path%%db_name%_backup.log

cls
echo.
echo Backup of %db_name% on %instance%
echo.


rem =====================================================
rem Execute Backup | write error to logfile
rem =====================================================

if not exist "%backup_path%%db_backup%_backup.log" echo. > %backup_log%
echo %date% - %time% >> %backup_log%
echo Backup of database %db_name% >> %backup_log%
echo Backup reason: %reason%  >> %backup_log%

cd /D %sql_path%
sqlcmd -E -S %instance% -d master -Q "BACKUP DATABASE [%db_name%] TO DISK = N'%backup_path%%mydate%_%db_backup%.bak' WITH INIT , NOUNLOAD , NAME = N'%mydate%_%db_backup%', NOSKIP , STATS = 10, NOFORMAT, COPY_ONLY" 2>> %backup_log%
if %errorlevel% neq 0 ( set status_sql=BackUp failed. SQLCMD encountered a problem.) else (set status_sql=SQL Backup OK.)

rem ==========================================================
rem zips the Backup using 7zip | write error to log
rem  * if 7Zip is not used, comment out 7z line(s) 
rem  * rename move file *.7z --> *.bak 
rem ==========================================================

cd /D %zip_path%
7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.bak 2>> %backup_log%
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. ) else (set status_7z=Compression OK. )

rem ==========================================================
rem create 12 directories | months
rem moves files to the directory
rem remove old backup | write error to log
rem ==========================================================

cd /D %backup_path%

setlocal
if not exist "%year%-%month%" mkdir "%year%-%month%" 2>> %backup_log%
move /Y %backup_path%%mydate%_%db_backup%.7z %year%-%month%\ 2>> %backup_log%
del /F %backup_path%%mydate%_%db_backup%.bak 2>> %backup_log%

echo.
echo Backup of database %db_name%: %status_sql% %status_7z% >> %backup_log%

:EOF