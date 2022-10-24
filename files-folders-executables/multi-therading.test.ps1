# location of some stuffs

$localpath = 'C:\OPTITOOL\_test_'

$basepath = '\\nssrv\Sales-Environment\SE\__db__'

$files = Get-ChildItem -Path $basepath -Recurse

ForEach ($file in $files){
    Copy-Item -Verbose -Path $file.FullName -Destination $localpath
}