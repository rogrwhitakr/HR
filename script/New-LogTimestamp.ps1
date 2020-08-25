function  New-Timestamp {
    return [string] "[ "+ (Get-Date -Format 'yyyy-hh-dd HH:mm:ss') + " ] "
}

New-Timestamp

filter New-LogTimeStamp { 
    "[ "+ (Get-Date -Format 'yyyy-hh-dd HH:mm:ss') + " ] :: "+ $_
}

# send output to the filter via the pipeline, comme ca:

Write-Output "hello world" | New-TimeStampFilter

# filter does not seem to work with the write-warning / -error / -verbose things
Write-Warning -Message ('thingy {0} is of some state: {1}' -f "chingadera", "DA BOMB !!!") | New-LogTimeStamp

# this could work. but ist hardly more handy
Write-Output -InputObject ('thingy {0} is of some state: {1}' -f "chingadera", "DA BOMB !!!")| New-TimeStampFilter
