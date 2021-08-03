@echo off

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Discription
::		what does this batch file do?
::		
::	Version History 
::  	1.0	
::			2017-02-14	author
::			initial version, changes      
::  	1.1	
::			2017-02-15	author
::			more changes      
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set version=1.0
set version=1.1
set version=%version: =%
set title=%~n0
title %title% - Version: %version%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	variable edits
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set var=do

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	execution
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::









:end

for /l %%a in (5,-1,1) do (title %title% - closing in %%as&ping -n 2 -w 1 127.0.0.1>NUL)