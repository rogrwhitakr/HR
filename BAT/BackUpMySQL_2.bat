@echo off

rem ==========================================================
rem Script | backup of MySQL database(s)
rem	* erstellt einen MySQL-dump
rem	* erstellt ein Backup - Verzeichnis
rem	* zippt das backup mit 7Zip und verschiebt es
rem ==========================================================
rem Variables
rem * mysql_path = Pfad der MySQL - Installation
rem * zip_path = Pfad der 7Zip - Installation
rem * db_name = Name DB
rem * db_backup = Name der Backup - Datei 
rem * angeben, wenn MEHRERE Datenbanken (z.B. PRODUKTIV
rem	  und TEST) in BackUp - Datei sollen
rem * time_var = Anzahl Monate, die behalten werden sollen
rem	  Achtung! Nur die Zahl anpassen!
rem ==========================================================

set mydate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
set mysql_path=C:\OPTITOOL\005_MySQL\MySQL Server 5.6\
set data_path=data\
set bin_path=bin\
set zip_path=C:\Program Files\7-Zip

set backup_path=C:\OPTITOOL\010_db_backup\test\
set db_name_0=ot_energie
set db_name_1=ot_bak
set db_name_2=ot_danone
set db_name_3=ot_hk
set db_backup=ot_mysql
set time_var=skip=8

rem =====================================================
rem Execute Backup | write error to logfile
rem =====================================================

if not exist "%backup_path%%db_backup%_backup_error.log" echo. 2> "%backup_path%%db_backup%_backup_error.log"
echo %date% - %time% >> %backup_path%%db_backup%_backup_error.log
echo Backup of OPTITOOL database %db_name% >> %backup_path%%db_backup%_backup_error.log

cd /D %mysql_path%%bin_path%
mysqldump -u root -popti --databases %db_name_0% %db_name_1% %db_name_2% %db_name_3% > %backup_path%%mydate%_%db_backup%.sql  2>> %backup_path%%db_backup%_backup_error.log

rem ==========================================================
rem zips the Backup using 7zip | write error to log
rem  * if 7Zip is not used, comment out 7z line(s) 
rem  * rename move file *.7z --> *.sql 
rem ==========================================================

cd /D %zip_path%
7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup_error.log

rem ==========================================================
rem create 12 directories | months
rem moves files to the directory
rem remove old backup | write error to log
rem ==========================================================

cd /D %backup_path%

setlocal
if not exist "%date:~-4%-%date:~-7,2%" mkdir "%date:~-4%-%date:~-7,2%" 2>> %backup_path%%db_backup%_backup_error.log
move /Y %backup_path%%mydate%_%db_backup%.7z %date:~-4%-%date:~-7,2%\ 2>> %backup_path%%db_backup%_backup_error.log
del /F %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup_error.log
for /F "%time_var%" %%a in ('dir /ad /o-n /b') do (rd /s /q %%a & echo Directory %%a was deleted. >> %backup_path%%db_backup%_backup_error.log)
echo Backup of datebase(s) %db_name_0%, %db_name_1%, %db_name_2%, %db_name_3% finished. >> %backup_path%%db_backup%_backup_error.log
echo. >> %backup_path%%db_backup%_backup_error.log
exit