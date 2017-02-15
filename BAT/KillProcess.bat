@echo off

set present=NO
set process=ipmgui.exe

::	Search for Process

tasklist /FI "STATUS eq running" /FI "IMAGENAME eq %process%" |find /i "%process%" && set present=YES
echo Process running ? %present%
timeout /t 1 >nul

if /i "%present%"=="NO" (
goto ende
)

if %errorlevel% equ 0 (
	taskkill /f /im %process% > nul 1>&2 
	)

goto ende

:ende
echo.
echo Abgeschlossen
timeout /t 1 1>nul

exit

