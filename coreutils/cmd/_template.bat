@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::		this batch file starts all virtual machine instances named in the 
::		%guests% - variable
::		
::
::	Version History 
::  	1.0	
::			2017-02-14	rogrwhitakr	
::			initial version for starting VirtualBox VMs      
::  	1.1	
::			2017-02-15	rogrwhitakr	
::			template batch file with title enabled      
::  	1.2	
::			2017-02-15	rogrwhitakr	
::			add description, some documentation      
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=1.0
set version=1.1
set version=1.2
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	insert guest name, separated by space
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set guests=gnome KDE server DNS-Server

set type=headless
set virtualbox_lcation=C:\Program Files\Oracle\VirtualBox\

cd %virtualbox_lcation%

set count=0
for /f "delims={}" %%b in ('cmd /c vboxmanage list runningvms ^| find /c /n "{"') do set count=%%b

if not %count%==0 goto :end

for %%c in (%guests%) do (
	@ping -n 1 localhost> nul
	echo.
	echo Starting VM %%c
	echo.
	cmd /c vboxmanage startvm "%%c" --type %type% 
)

echo.
echo VMs %guests% successfully started.
timeout /t 5 > nul

:end
for /l %%a in (5,-1,1) do (title %title% - closing in %%as&ping -n 2 -w 1 127.0.0.1>NUL)

