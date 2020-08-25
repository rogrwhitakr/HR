@echo off

echo ======================================================================
:: Align Right - Align text to the right i.e. to improve readability of number columns
set x=3000
set y=2
set x=        %x%
set y=        %y%
echo.X=%x:~-8%
echo.Y=%y:~-8%

echo ======================================================================
:: Left String - Extract characters from the beginning of a string
set str=politic
echo.%str%
set str=%str:~0,4%
echo.%str%

echo ======================================================================
:: Map and Lookup - Use Key-Value pair list to lookup and translate values
:: ---- Example 1: Translate name of month into two digit number ----
SET v=Mai
SET map=Jan-01;Feb-02;Mar-03;Apr-04;Mai-05;Jun-06;Jul-07;Aug-08;Sep-09;Oct-10;Nov-11;Dec-12
CALL SET v=%%map:*%v%-=%%
SET v=%v:;=&rem.%
ECHO.%v%

:: ---- Example 2: Translate abbreviation into full string ----
SET v=sun
set map=mon-Monday;tue-Tuesday;wed-Wednesday;thu-Thursday;fri-Friday;sat-Saturday;sun-Sunday
CALL SET v=%%map:*%v%-=%%
SET v=%v:;=&rem.%
ECHO.%v%

echo ======================================================================
:: Mid String - Extract a Substring by Position
:: return a specified number of characters from any position inside a string by specifying a substring for an expansion given a position and length using :~ while expanding a variable content.

echo.Date   : %date%
echo.Weekday: %date:~0,3%
echo.Month  : %date:~4,2%
echo.Day    : %date:~7,2%
echo.Year   : %date:~10,4%

set year=%date:~-4%
set month=%date:~-7,2%
set day=%date:~-10,2%
echo %year%-%month%-%day%


echo ======================================================================
:: Remove both Ends - Remove the first and the last character of a string
set str=politic
echo.%str%
set str=%str:~1,-1%
echo.%str%

echo ======================================================================
:: Remove Spaces - Remove all spaces in a string via substitution
set str=      word       &rem
echo."%str%"
set str=%str: =%
echo."%str%"

pause