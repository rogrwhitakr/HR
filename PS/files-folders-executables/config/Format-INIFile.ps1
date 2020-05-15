function Format-IniFile {
    write-host 'ys'
}

# get content
$ini = Get-Content -Path (Get-ChildItem -Path  '.\key-value-pairs.ini')

# set a counter
$offset = @()

# loop through lines
foreach ($line in $ini) {
    'line content: {0}, indexOf(=): {1}' -f $line, $line.indexOf('=')
    if ($line.indexOf('=') -gt '1') {
        $offset += $line.indexOf('=') 
    }
}
'max offset: {0}' -f ($offset | Measure-Object -Maximum).Maximum

$offset | Measure-Object -Maximum -Minimum -Average

# now we can set some things
foreach ($line in $ini) {
    if ($line.indexOf('=') -gt '1') {
        $offset += $line.indexOf('=') 
    }
}

#$ini | gm