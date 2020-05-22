$version = Get-Content -raw (Get-ChildItem -File D:\VERSION.file)

$json = $version | ConvertTo-Json | gm
$json = $version | Convertfrom-Json | gm

$json | gm

convertto-json $version | gm

$versioninfo = @{}

$num = 1


foreach ($line in $version) {
$versioninfo.Add($num,$line)
++$num
}




$saves = @(
    'C:\MyScripts',
    'C:\Users\Administrator\Documents\WindowsPowerShell',
    'C:\Users\Administrator\Pictures',
    'D:\004_sql',
    'D:\100_demofiles\xml\_template',
    'D:\103_Powerpoint',
    'D:\105_Word',
    'D:\northern-lights\DK\_admin',
    'D:\northern-lights\UK\_documents',
    'D:\northern-lights\_docs',
    'D:\northern-lights\_Dokumente',
    'D:\Sales\BEV\_docs',
    'D:\Sales\MLK\_Dokumente',
    'D:\Sales\OIL\_admin',
    'D:\Sales\TRP\_admin',
    'D:\Sales\_admin'
    )

$exclude = @{
    'C:\Users\Administrator' = 'AppData';
    'C:\Users' = 'AppData'

}