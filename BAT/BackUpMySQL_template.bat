@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::		Script for backing up of MySQL database(s)
::		* erstellt einen MySQL-dump
::		* erstellt ein Backup - Verzeichnis
::		* zippt das backup mit 7Zip und verschiebt es
::		Variables
::		* mysql_path = Pfad der MySQL - Installation
::		* zip_path = Pfad der 7Zip - Installation
::		* db_name = Name DB
::		* db_backup = Name der Backup - Datei 
::		* angeben, wenn MEHRERE Datenbanken (z.B. PRODUKTIV und TEST) in 
::		  BackUp - Datei sollen
::		* time_var = Anzahl Monate, die behalten werden sollen
::		  Achtung! Nur die Zahl anpassen!
::
::	Version History 
::  	1.0	
::			2017-02-17	Benno Osterholt	
::			add description, template stuff 
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=1.0
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	insert guest name, separated by space
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set mydate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
set mysql_path=C:\MySQL\MySQL Server 5.6\
set data_path=data\
set bin_path=bin\
set zip_path=C:\Program Files\7-Zip

set backup_path=C:\db_backup\
set db_name_0=prod_1
set db_name_1=prod_2
set db_name_2=prod_3
set db_name_3=prod_4
set db_backup=prod_all
set time_var=skip=8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Execute Backup | write error to logfile
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not exist "%backup_path%%db_backup%_backup_error.log" echo. 2> "%backup_path%%db_backup%_backup_error.log"
echo %date% - %time% >> %backup_path%%db_backup%_backup_error.log
echo Backup of database %db_name% >> %backup_path%%db_backup%_backup_error.log

cd /D %mysql_path%%bin_path%
mysqldump -u root -popti --databases %db_name_0% %db_name_1% %db_name_2% %db_name_3% > %backup_path%%mydate%_%db_backup%.sql  2>> %backup_path%%db_backup%_backup_error.log

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: zips the Backup using 7zip | write error to log
::  * if 7Zip is not used, comment out 7z line(s) 
::  * rename move file *.7z --> *.sql 
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cd /D %zip_path%
7z a -mx9 %backup_path%%mydate%_%db_backup%.7z %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup_error.log

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: create 12 directories | months
:: moves files to the directory
:: ::ove old backup | write error to log
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cd /D %backup_path%

setlocal
if not exist "%date:~-4%-%date:~-7,2%" mkdir "%date:~-4%-%date:~-7,2%" 2>> %backup_path%%db_backup%_backup_error.log
move /Y %backup_path%%mydate%_%db_backup%.7z %date:~-4%-%date:~-7,2%\ 2>> %backup_path%%db_backup%_backup_error.log
del /F %backup_path%%mydate%_%db_backup%.sql 2>> %backup_path%%db_backup%_backup_error.log
for /F "%time_var%" %%a in ('dir /ad /o-n /b') do (rd /s /q %%a & echo Directory %%a was deleted. >> %backup_path%%db_backup%_backup_error.log)
echo Backup of datebase(s) %db_name_0%, %db_name_1%, %db_name_2%, %db_name_3% finished. >> %backup_path%%db_backup%_backup_error.log
echo. >> %backup_path%%db_backup%_backup_error.log
exit