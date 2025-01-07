$choco_logfile = "C:\ProgramData\chocolatey\logs\chocolatey.log"

Select-String -path $choco_logfile -Pattern 'Chocolatey upgraded' -Context 1
$logline = Select-String -path $choco_logfile -Pattern 'Chocolatey upgraded (\d.*)\/(\d*) packages\.'

$logline.Matches

Select-String -path $choco_logfile -Pattern 'Chocolatey upgraded (\d.*)\/(\d*) packages\.' | ForEach-Object {

    if ([int]$_.Matches.Groups[1].Value -ne 0) {
        $stringy = 'Chocolatey upgraded {0}/{1} packages.' -f $_.Matches.Groups[1].Value, $_.Matches.Groups[2].Value
        $thingy = Select-String -path $choco_logfile -Pattern $stringy -Context 0, ([int]$_.Matches.Groups[1].Value + 3)
        Write-Host $thingy
    }
}