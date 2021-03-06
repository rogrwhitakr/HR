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

set sql_path=C:\Program Files\Microsoft SQL Server\MSSQL12.SQL_2014\MSSQL\
set zip_path=C:\Program Files\7-Zip\
set backup_path=D:\010_db_backup\MSSQL\

if not exist "%zip_path%" ( echo no ZIP-path defined && goto :error)
if not exist "%sql_path%" ( echo SQL path is not defined && goto :error)
if not exist "%backup_path%" ( echo backup_path is not defined && mkdir %backup_path% && goto :start)

:start

	cls
	set instance=%ComputerName%\SQL_2012
	echo.
	echo This batch script makes a backup of an MSSQL database and stores it in %backup_path%
	echo.
	cd %sql_path%
	sqlcmd -E -S %instance% -Q "sp_databases"
	set /p db_name="Enter database name: "
	set db_backup=%db_name%
	
	echo.
	echo "Backup of %db_name% on %instance%"
	echo.


rem =====================================================
rem Execute Backup | write error to logfile
rem =====================================================

if not exist "%backup_path%%db_backup%_backup.log" echo. > "%backup_path%%db_backup%_backup.log"
echo %date% - %time% >> %backup_path%%db_backup%_backup.log
echo Backup of database %db_name% >> %backup_path%%db_backup%_backup.log

cd /D %sql_path%
sqlcmd -E -S %instance% -d master -Q "BACKUP DATABASE [%db_name%] TO DISK = N'%backup_path%%mydate%_%db_backup%.bak' WITH INIT , NOUNLOAD , NAME = N'%mydate%_%db_backup%', NOSKIP , STATS = 10, NOFORMAT" 2>> %backup_path%%db_backup%_backup.log
if %errorlevel% neq 0 ( set status_sql=BackUp failed. SQLCMD encountered a problem.) else (set status_sql=SQL Backup OK.)

rem ==========================================================
rem zips the Backup using 7zip | write error to log
rem  * if 7Zip is not used, comment out 7z line(s) 
rem  * rename move file *.7z --> *.bak 
rem ==========================================================

cd /D %zip_path%
7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.bak 2>> %backup_path%%db_backup%_backup.log
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. ) else (set status_7z=Compression OK. )

rem ==========================================================
rem create 12 directories | months
rem moves files to the directory
rem remove old backup | write error to log
rem ==========================================================

cd /D %backup_path%

setlocal
if not exist "%year%-%month%" mkdir "%year%-%month%" 2>> %backup_path%%db_backup%_backup.log
move /Y %backup_path%%mydate%_%db_backup%.7z %year%-%month%\ 2>> %backup_path%%db_backup%_backup.log
del /F %backup_path%%mydate%_%db_backup%.bak 2>> %backup_path%%db_backup%_backup.log

rem =====================================================
rem Block to fuck wit files and directories
rem =====================================================

set /a monthsToDelete=%monthsToKeep% + 1
set del_file=skip=%monthsToKeep%
set del_dir=skip=%monthsToDelete%

rem echo deletes Directory that is %monthsToDelete% months old....
for /f "%del_dir%" %%a in ('dir /ad /o-n /b') do ( rd /s /q %%a && echo Directory %%a was deleted. >> %backup_path%%db_backup%_backup.log )

rem echo Finds directory that is %monthsToKeep% months old ... 
for /F "%del_file%" %%a in ('dir /ad /o-n /b') do ( set dir_var=%%a)

rem echo finds file in directory %dir_var%...
for /f %%a in ('dir %dir_var% /a /o-n /b') do ( set file_var=%%a)

rem =====================================================
rem the delimiter looks for the "day" in filename
rem change where required | token is third part of date
rem =====================================================

for /f  "delims=-,_, tokens=3" %%a in ('dir %dir_var% /a /o-n /b') do ( set day_of=%%a)

if %day%==%day_of% ( del /f %dir_var%\%file_var% && echo File %file_var% in directory %dir_var% deleted. >> %backup_path%%db_backup%_backup.log ) 
if %day% gtr %day_of% ( del /f %dir_var%\%file_var% && echo File %file_var% in directory %dir_var% deleted. >> %backup_path%%db_backup%_backup.log )
if %day% lss %day_of% ( echo No Files deleted >>  %backup_path%%db_backup%_backup.log )

echo Backup of database %db_name%: %status_sql% %status_7z%>> %backup_path%%db_backup%_backup.log
echo. >> %backup_path%%db_backup%_backup.log

exit

:error

timout /t 10 1>NUL
exit
