
# this one splits the byte tream
# is fast
# needs additional andling of files, the first and last line need be cut

# add source file
$file = Get-ChildItem 'C:\Users\Youngblood\Desktop\csv'

# from source we get some specifics
$rootName = $file.Directory.FullName
$ext = $file.Extension

# remove everything, if already in place
set-location -Path $rootName
'removal of files:'
Remove-Item -Path 'csv-*' -Force -Verbose

# future file size
$upperBound = 1MB

$fromFile = [io.file]::OpenRead($file.FullName)
$buff = new-object byte[] $upperBound

$count = $idx = 0
try {
    do {
        "Reading $upperBound"
        $count = $fromFile.Read($buff, 0, $buff.Length)
        if ($count -gt 0) {
            $to = "{0}\csv-{1:d4}{2}" -f ($rootName, $idx, $ext)
            $toFile = [io.file]::OpenWrite($to)
            try {
                "Writing $count to $to"
                $tofile.Write($buff, 0, $count)
            }
            finally {
                $tofile.Close()
            }
        }
        $idx ++
    } while ($count -gt 0)
}
finally {
    $fromFile.Close()
}

'doing the first line last line removal'
$files = Get-ChildItem 'C:\Users\Youngblood\Desktop\csv'  -Filter "csv-*"

foreach ($file in $files) {
    'processing file {0}' -f $file
    $from = Get-Content $file
    $to = $from | Select-Object -Skip 1 | Select-Object -SkipLast 1
    Set-Content -Path $file -Value $to
}