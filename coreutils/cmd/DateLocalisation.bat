@echo off
set path=.\test\

set mydate=%date:~-4%-%date:~-7,2%-%date:~-10,2%

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set filename=%year%-%month%-%day%

echo year
echo %year%

echo month
echo %month%

echo day
echo %day%

echo mydate
echo %mydate%

echo filename
echo %filename%

echo sysdate
echo %date%

pause

rem ===================================================

set hour=%TIME:~0,2%
set minute=%TIME:~3,2%

echo %hour%:%minute%

pause