# location of some stuffs

$localpath = 'C:\_test_'

$basepath = '\\fileshare\subpath\more-subpath\__db__'

$files = Get-ChildItem -Path $basepath -Recurse

ForEach ($file in $files){
    Copy-Item -Verbose -Path $file.FullName -Destination $localpath
}