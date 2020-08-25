
############################################################################
# Progress bar - does this work???
############################################################################

# Get-ChildItem -Path {$env:windir}

$seconds = 60
1..$seconds |
    ForEach-Object { $percent = $_ * 100 / $seconds;

    Write-Progress -Activity Break -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

    Start-Sleep -Seconds 1
}

Read-Host -Prompt 'finished with the first demo...'


1..100 | ForEach-Object {
    Write-Progress -Activity 'Counting' -Status "Processing $_" -PercentComplete $_
    Start-Sleep -Milliseconds 100
}


############################################################################
# should be:

$min = 1
$max = 10000

$start = Get-Date

# update progress bar every 0.1 %
$interval = $max / 1000

$min..$max | ForEach-Object {
    $percent = $_ * 100 / $max

    if ($_ % $interval -eq 0) {
        Write-Progress -Activity 'Counting' -Status "Processing $_" -PercentComplete $percent
    }
}

$end = Get-Date

($end - $start).TotalMilliseconds