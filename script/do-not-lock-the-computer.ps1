$wshell = New-Object -ComObject wscript.shell;
$wshell.SendKeys(' ')
pause
exit(0)


# loop
while ($true) {
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys(' ')
    Start-Sleep -Seconds 180
}


function att {

    while ($true) {
        $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('  ')
        Start-Sleep -Seconds 180
    }
}