@echo on

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set filename=%year%-%month%-%day%

echo %year%
echo %month%
echo %day%
echo %filename%


for /f  "delims=-,_, tokens=3" %%a in ('%filename%') do ( set day_of=%%a)

exit
rem	return codes that are a power of 2
rem	If both SomeCommand.exe and OtherCommand.exe fail, the return code will be the bitwise combination of 0x1 and 0x2, or decimal 3. 
rem

SETLOCAL ENABLEEXTENSIONS

SET /A errno=0
SET /A ERROR_HELP_SCREEN=1
SET /A ERROR_SOMECOMMAND_NOT_FOUND=2
SET /A ERROR_OTHERCOMMAND_FAILED=4

SomeCommand.exe
IF %ERRORLEVEL% NEQ 0 SET /A errno^|=%ERROR_SOMECOMMAND_NOT_FOUND%

OtherCommand.exe
IF %ERRORLEVEL% NEQ 0 (
    SET /A errno^|=%ERROR_OTHERCOMMAND_FAILED%
)

EXIT /B %errno%


pause