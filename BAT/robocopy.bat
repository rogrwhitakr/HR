@echo on

set home=MyScripts
set path=..\%home%
echo %path%
pause
set ziel=%path%\Google Drive\MyScripts

cd %path%
echo dir
pause
xcopy *.* %ziel%\*.*

pause