@echo off

IF "%~1" == "--help" GOTO USAGE ELSE GOTO INVITE

:: ===================
:: Entry Point
:: ===================
:START

call :INVITE

:INVITE
echo --------------------------------------------------------------------
echo.
echo dislays this text on no args given
echo.
echo we do nothing, and exit after 5 secs.
echo.
echo possible args: --help
echo.
echo --------------------------------------------------------------------
GOTO END

:USAGE
echo --------------------------------------------------------------------
echo.
echo displays this text when "--help" is argsed
echo.
echo --------------------------------------------------------------------
GOTO END

:END
echo END has been called.
echo.
echo --------------------------------------------------------------------
timeout /t 5 
