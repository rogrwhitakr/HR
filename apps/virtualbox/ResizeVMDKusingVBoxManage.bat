@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::		this batch resizes a vmdk using VirtualBox`s VBoxManage 
::		%source% - vmdk to resize
::		%target% - vmdk to create
::
::	Version History 
::  	1.0	
::			2017-06-13	rogrwhitakr	
::			initial version       
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=1.0
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	set variables
::		*size in GB
::		*source vmdk
::		*target vmdk
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=gnome
set source=Fedora 22 Workstn
set size=15
set loc=%cd%

set /a SizeInGB=%size%*1024
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	execute
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.
echo resizing VM %source% to %target% to %SizeInGB% Bytes / %size% GB

c:
cd "C:\Program Files\Oracle\VirtualBox"

echo.
echo cloning existing VM...
cmd /c VBoxManage clonehd "%loc%\%source%.vmdk" "%loc%\cloned.vdi" --format vdi
IF %ERRORLEVEL% NEQ 0 echo color 0C cloning: An error was found 
COLOR 

echo resizing cloned VM...
cmd /c VBoxManage modifyhd "%loc%\cloned.vdi" --resize %SizeInGB%
IF %ERRORLEVEL% NEQ 0 echo color 0C resizing: An error was found 
COLOR 

echo clone resized VM into new VMDK...
cmd /c VBoxManage clonehd "%loc%\cloned.vdi" "%loc%\%target%.vmdk" --format vmdk
IF %ERRORLEVEL% NEQ 0 echo color 0C cloning again: An error was found 
COLOR 

echo removing 
echo cloned.vdi file
echo %source%.vmdk remains, please remove at your own discretion

del %loc%\cloned.vdi
IF %ERRORLEVEL% NEQ 0 echo color 0C deleting: An error was found 

pause

exit 0