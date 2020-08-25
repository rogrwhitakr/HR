
$src = './result'

set-location -Path "C:\Users\Administrator\Desktop\se_opti4cast"

$files = Get-ChildItem -Path $src
$count = ($files).count
'there are {0} files in {1}' -f $count, $src

$current = New-Item -ItemType Directory -Name ('4cast_1')

for ($i = 1; $i -le $count; $i++) {
    if ($i % 100000 -eq 0) {
        $current = New-Item -ItemType Directory -Name ('4cast_' + $i)
        'we got {0}. file {1}' -f $i, $files[$i]
        'copy file {0} to {1}' -f $files[$i], $current
        Move-Item -Path $files[$i].FullName -Destination $current -ErrorAction Stop
    }
    else { 
        Move-Item -Path $files[$i].FullName -Destination $current -ErrorAction Stop
    }
}
