@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::			* backup of PostgreSQL database
::			* creates PostgreSQL-dump
::			* creates backup directory
::			* zips backup using 7Zip
::		
::	Args
::			* sql_path = path to bin folder, PostgreSQL installation
::			* zip_path = path to 7Zip
::			* db_name = Name DB
::		
::  Example
::          * .\Create-Database-Backup.bat northernlights.database D:\_databases\pgsql\
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Variables to set

set sql_path=C:\Program Files\PostgreSQL\12\bin\
set zip_path=C:\Program Files\7-Zip\

set dialect=postgresql
set port=5432
set user=northernlights
set PGPASSWORD=northernlights

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=1.41294
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

:: if parameters are empty, go away
if [%1] == [] echo No argument given for database && GOTO :EOF
IF [%2] == [] echo No argument given for backup path && GOTO :EOF

:: set the date like this to avoid localisation issues
set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set mydate=%year%-%month%-%day%

set db_name=%1
set backup_path=%2
set db_backup=%db_name%
set backup_log=%backup_path%%db_name%_backup.log

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Execute Backup | write error to logfile
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not exist "%backup_path%%db_backup%_backup.log" echo Logfile for script %title% - Version: %version% > %backup_log%
echo. >> %backup_log%
echo %date% - %time% :: Starting Backup of database %db_name%, using dialect %dialect% >> %backup_log%

cd /D %sql_path%
pg_dump.exe --username=%user% --no-password --host=localhost --port=%port% --dbname=%db_name% --file=%backup_path%%db_backup%.sql 2>> %backup_log%
if %errorlevel% neq 0 ( set status_sql=BackUp failed. pg_dump.exe encountered a problem.) else (set status_sql=SQL Backup OK.)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	zips the Backup using 7zip | write error to log
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


cd /D %zip_path%
7z.exe a -mx9 %backup_path%%db_backup%.7z %backup_path%%db_backup%.sql 2>> %backup_log%
if %errorlevel% neq 0 (	set status_7z=Compression failed. 7z.exe encountered a problem. ) else (set status_7z=Compression OK. )

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	remove backup, leave zipped file | write error to log
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal
cd /D %backup_path%
del /F %backup_path%%db_backup%.sql 2>> %backup_log%

echo %date% - %time% :: Backup of database %db_name%: %status_sql% %status_7z% >> %backup_log%