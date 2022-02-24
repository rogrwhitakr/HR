@echo off

set exist=false
set process=greenshot.exe

tasklist /FI "STATUS eq running" /FI "IMAGENAME eq %process%" |find /i "%process%" && set exist=true

if /i "%exist%"=="false" (
	exit 0
)

if /i "%exist%"=="true" (
	taskkill /f /im %process% 
	timeout /t 1 1>NUL
	set exist=false
	%process%
)

pause