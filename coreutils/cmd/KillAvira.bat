@echo off

set exist=false
set process=ipmgui.exe
set log=%userprofile%\Desktop\ipm.log 

:loop

tasklist /FI "STATUS eq running" /FI "IMAGENAME eq %process%" |find /i "%process%" && set exist=true

if /i "%exist%"=="false" (
	timeout /t 5 1>NUL
	goto loop
)

if /i "%exist%"=="true" (
	echo %date% %time% >> %log%
	taskkill /f /im %process% >> %log%
	echo. >> %log%
	timeout /t 15 1>NUL
	set exist=false
	goto loop
)
