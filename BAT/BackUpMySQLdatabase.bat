@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::			Script | backup of MySQL database(s)
::			* erstellt einen MySQL-dump
::			* erstellt ein Backup - Verzeichnis
::			* zippt das backup mit 7Zip und verschiebt es
::		
::		Variables
::			* sql_path = Pfad der MySQL - Installation
::			* zip_path = Pfad der 7Zip - Installation
::			* db_name = Name DB
::			* db_backup = Name der Backup - Datei 
::		
::	Version History 
::  	1.0	
::			2017-03-02	rogrwhitakr
::			initial version      
::  	2.0	
::			2018-11-27	rogrwhitakr
::			pass database name as an argument
::			pass dumping ground as an argument      
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=2.0
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	variables
::		*	log file stuff
::		*	paths
::		*	database specifics
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: if parameters are empty, go away
IF [%1] == [] GOTO :EOF
IF [%2] == [] GOTO :EOF

set backup_path=%2
set db_name=%1

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set mydate=%year%-%month%-%day%

set sql_path=C:\Program Files\MySQL\MySQL Server 5.7\bin\
set zip_path=C:\Program Files\7-Zip\

set instance=MySQL
set port=3306

set db_backup=%db_name%
set backup_log=D:\backup\%db_name%_backup.log

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Execute Backup | write error to logfile
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not exist "%backup_path%%db_backup%_backup.log" echo Logfile for script %title% - Version: %version% > %backup_log%
echo. >> %backup_log%
echo %date% - %time% :: Starting Backup of database %db_name% >> %backup_log%

cd /D %sql_path%
mysqldump.exe --hex-blob --user=root -popti --protocol=tcp --port=%port% --default-character-set=utf8 --single-transaction=TRUE --routines --skip-triggers %db_name% > %backup_path%%db_backup%.sql 2>> %backup_log%
if %errorlevel% neq 0 ( set status_sql=BackUp failed. MySQLdump.exe encountered a problem.) else (set status_sql=SQL Backup OK.)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	zips the Backup using 7zip | write error to log
::		* if 7Zip is not used, comment out 7z line(s) 
::		* rename move file *.7z --> *.sql 
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


cd /D %zip_path%
7z.exe a -mx9 %backup_path%%db_backup%.7z %backup_path%%db_backup%.sql 2>> %backup_log%
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. ) else (set status_7z=Compression OK. )

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	remove old backup | write error to log
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal
cd /D %backup_path%
del /F %backup_path%%db_backup%.sql 2>> %backup_log%

echo %date% - %time% :: Backup of database %db_name%: %status_sql% %status_7z% >> %backup_log%
echo.

:EOF