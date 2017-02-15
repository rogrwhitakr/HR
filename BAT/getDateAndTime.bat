@echo off

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set filename=%year%-%month%-%day%

echo %year%
echo %month%
echo %day%
echo %filename%

pause