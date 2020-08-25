@echo off
taskkill /f /fi "imagename eq outlook.exe" 2>&1
pause
cd "C:\Program Files (x86)\Microsoft Office\Office14\"
outlook.exe /safe