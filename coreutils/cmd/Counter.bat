@echo off

::::::::::::::::::::::
::					::
::		Counter		::
::					::
::::::::::::::::::::::

set /a counter=50
echo die Zahl ist %counter%

:start
set /a counter-=1
echo counting down... %counter%

timeout /t 1 >nul

if %counter% gtr 0 goto start
else goto end 2>nul

:end
echo bis denn...
timeout /t 2 >nul
exit