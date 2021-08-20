echo off
set DOW=

for /f %%g in ('wmic path win32_localtime get dayofweek^|findstr /v /r "^$"') do (
set DOW=%%g)

if %DOW%==0 set DOW=Sonntag
if %DOW%==1 set DOW=Montag
if %DOW%==2 set DOW=Dienstag
if %DOW%==3 set DOW=Mittwoch
if %DOW%==4 set DOW=Donnerstag
if %DOW%==5 set DOW=Freitag
if %DOW%==6 set DOW=Samstag

echo %DOW%
pause




