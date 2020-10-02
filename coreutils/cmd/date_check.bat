@echo off

set workingPath=%cd%

set mydate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
echo this is a variable test to check the localisation of the date variable.
echo expected format: yyyy-MM-dd
echo actual:
echo.
echo %mydate%

pause

exit 0