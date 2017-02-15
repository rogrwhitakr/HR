@echo off

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set filename=%year%-%month%-%day%

echo %year%
echo %month%
echo %day%
echo %filename%

set sql_path=C:\OPTITOOL\005_MySQL\MySQL Server 5.6\
set bin_path=bin\
set zip_path=C:\Program Files\7-Zip\

set backup_path=C:\OPTITOOL\010_db_backup\Suez\
set db_name=ot_suez
set db_backup=ot_suez

rem =====================================================
rem Execute Backup | write error to logfile
rem =====================================================

if not exist "%backup_path%%db_backup%_backup.log" echo. 2> "%backup_path%%db_backup%_backup.log"
echo %date% - %time% >> %backup_path%%db_backup%_backup.log
echo Backup of OPTITOOL database %db_name% >> %backup_path%%db_backup%_backup.log

cd /D %sql_path%%bin_path%
mysqldump -u root -popti %db_name% > %backup_path%%mydate%_%db_backup%.sql  2>> %backup_path%%db_backup%_backup.log
if %errorlevel% neq 0 ( set status_sql=Backup failed. MySQLdump.exe encountered a problem. ) else (set status_sql=SQL Backup OK. )

rem ==========================================================
rem zips the Backup using 7zip | write error to log
rem  * if 7Zip is not used, comment out 7z line(s) 
rem  * rename move file *.7z --> *.sql 
rem ==========================================================

cd /D %zip_path%
7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup.log
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. && set ExitCode=6) else (set status_7z=Compression OK. && set exitCode=3)

rem =====================================================
rem the delimiter looks for the "day" in filename
rem change where required | token is third part of date
rem =====================================================

for /f  "delims=-,_, tokens=3" %%a in ('dir %dir_var% /a /o-n /b') do ( set day_of=%%a)

if %day%==%day_of% ( del /f %dir_var%\%file_var% && echo File %file_var% in directory %dir_var% deleted. >> %backup_path%%db_backup%_backup.log ) 
if %day% gtr %day_of% ( del /f %dir_var%\%file_var% && echo File %file_var% in directory %dir_var% deleted. >> %backup_path%%db_backup%_backup.log )
if %day% lss %day_of% ( echo No Files deleted >>  %backup_path%%db_backup%_backup.log )

echo Backup of datebase %db_name%: %status_sql% %status_7z%>> %backup_path%%db_backup%_backup.log
echo. >> %backup_path%%db_backup%_backup.log

pause