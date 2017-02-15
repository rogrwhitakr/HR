@echo on

rem ==========================================================
rem Script | backup of MySQL database(s)
rem	* erstellt einen MySQL-dump
rem	* erstellt ein Backup - Verzeichnis
rem	* zippt das backup mit 7Zip und verschiebt es
rem ==========================================================
rem Variables
rem * sql_path = Pfad der MySQL - Installation
rem * zip_path = Pfad der 7Zip - Installation
rem * db_name = Name DB
rem * db_backup = Name der Backup - Datei 
rem * angeben, wenn MEHRERE Datenbanken (z.B. PRODUKTIV
rem	  und TEST) in BackUp - Datei sollen
rem * time_var = Anzahl Monate, die behalten werden sollen
rem	  Achtung! Nur die Zahl anpassen!
rem ==========================================================

set zip_path=C:\Program Files\7-Zip\
set DirectoryToBackup=D:\OPTITOOL
set backup_name=NetworkShare
set backup_path=D:\Backup

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set mydate=%year%-%month%-%day%

rem =====================================================
rem Execute Backup 
rem =====================================================

cd /D %DirectoryToBackup%
echo %cd%
pause

rem ==========================================================
rem zips the Backup using 7zip | write error to log
rem  * if 7Zip is not used, comment out 7z line(s) 
rem  * rename move file *.7z --> *.sql 
rem ==========================================================

cd /D %zip_path%
echo %cd%
pause
7z a -rm9 %backup_name%_%mydate%.7z %DirectoryToBackup%
pause
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. && set ExitCode=6) else (set status_7z=Compression OK. && set exitCode=3)

rem ==========================================================
rem create 12 directories | months
rem moves files to the directory
rem remove old backup | write error to log
rem ==========================================================

cd /D %backup_path%

setlocal
if not exist "%year%-%month%" mkdir "%year%-%month%" 2>> %backup_path%%db_backup%_backup.log
move /Y %backup_path%%mydate%_%db_backup%.7z %year%-%month%\ 2>> %backup_path%%db_backup%_backup.log
del /F %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup.log

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

echo Backup of datebase %db_name%: %status_sql% %status_7z%>> %backup_path%%db_backup%_backup.log
echo. >> %backup_path%%db_backup%_backup.log
exit