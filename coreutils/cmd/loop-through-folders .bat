@echo off

set workingPath=%cd%

rem ==========================================================
rem Alle Verzeichnisse, die bereinigt werden sollen auflisten:
rem ==========================================================

set folders=log backup


rem ==========================================================
rem Alle Dateien, die bereinigt werden sollen
rem ==========================================================

set files=*.*

rem ============================
rem Exec
rem ============================

set mydate=%date:~-4%-%date:~-7,2%-%date:~-10,2%

for %%a in (%folders%) do (
  cd %workingPath%\%%a
  mkdir "%~d1%~p1%mydate%"
  for %%b in (%files%) do (move /Y %%b %~d1%~p1%mydate%\)
  for /F "skip=30" %%c in ('dir /AD /O-D /B') do (rd /s /q %%c)
  cd %workingPath%
)
