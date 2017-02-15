@echo off
REM killProc.bat - J. Greg Mackinnon, 2010-04-09
REM uses "taskkill.exe" to terminate the process specified by the first input argument
REM PROVIDES: the return code of the "taskkill" process, or "100" if a process name was not provided as input
REM REQUIRES: "tasklist.exe", "taskkill.exe", cmd.exe running under Windows 2000 or later.

set exitCode=0
set proc=%1
if NOT DEFINED proc goto error

tasklist.exe /FI "IMAGENAME eq %proc%" 2>NUL | find /I "%proc%" >NUL
if %ERRORLEVEL% EQU 0 (
   taskkill /f /im %proc%
   set exitCode=%errorlevel%
)

goto end

:error
echo You must provide a valid process image name as an argument to this script.
set exitCode=100
goto end

:end
exit /B %exitCode%