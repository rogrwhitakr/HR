
# get the file
# prerequisite: all same lines!, no checking of xml validity occurs
$file = 'C:\Users\Administrator\Desktop\se_gas-station\alterations\gas-station-fills_no-header.xml'

# check if gettable
if (!(Get-ChildItem -Path $file)) {
    'no file gettable! file: {0}' -f $file
    break
}

# create that mother dir
New-Item -Path (Get-ChildItem -Path $file).Directory.FullName -Name 'import_files' -ItemType Directory -Force

# get that file content, length
$content = Get-Content -Path $file
$lines = $content.Count

# set that file size in length of lines
[int]$fut = 100
[int]$i = 1

do {
    # we must start at 1 + offset, bc we subtract this offset at the selection
    $i += $fut
    if ($i -gt $fut) {

        # make a new file, get the content to set
        $current_file = New-Item -Path (Get-ChildItem -Path $file).Directory.FullName -ItemType File  -Name ('import_files\alterations_{0:d8}.xml' -f $i) -Force
        $current_content = $content[($i - $fut)..$i]
        'adding lines {0} to line {1}' -f ($i - $fut),$i

        # adding the xml stuffs we need
        # it seems necessary to join content with a new line, bc i dont konw
        $stringBuilder = New-Object System.Text.StringBuilder
        $stringBuilder.Append("<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?>").ToString()
        $stringBuilder.Append("`n").ToString()
        $stringBuilder.Append("<northern-lights tenantExtId=`"GAS-STATION`">").ToString()
        $stringBuilder.Append("`n").ToString()
        $stringBuilder.Append("`n").ToString()
        $stringBuilder.Append($current_content -join "`n").ToString()
        $stringBuilder.Append("`n").ToString()
        $stringBuilder.Append("</northern-lights>").ToString()

        # put it in a file
        Set-Content -Path $current_file -Value $stringBuilder -Encoding UTF8
    }
    else {
        '{0}::{1}' -f $i, $fut
        continue
    }
} until ($i -ge $lines)

'finished'