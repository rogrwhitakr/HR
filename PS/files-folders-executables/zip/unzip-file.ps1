# adjust this to a valid path to a ZIP file
$Path = "$Home\Desktop\Test.zip"

# load the ZIP types
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($Path )
$zip.Entries

$zip.Dispose()

# Extract Specific Files from ZIP Archive

# change $Path to a ZIP file that exists on your system!
$Path = "$Home\Desktop\Test.zip"

# change extension filter to a file extension that exists
# inside your ZIP file
$Filter = '*.wav'

# change output path to a folder where you want the extracted
# files to appear
$OutPath = 'C:\ZIPFiles'

# ensure the output folder exists
$exists = Test-Path -Path $OutPath
if ($exists -eq $false)
{
$null = New-Item -Path $OutPath -ItemType Directory -Force
}

# load ZIP methods
Add-Type -AssemblyName System.IO.Compression.FileSystem

# open ZIP archive for reading
$zip = [System.IO.Compression.ZipFile]::OpenRead($Path )

# find all files in ZIP that match the filter (i.e. file extension)
$zip.Entries |
Where-Object { $_.FullName -like $Filter } |
ForEach-Object {
# extract the selected items from the ZIP archive
# and copy them to the out folder
$FileName = $_.Name
[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, " $OutPath\$FileName", $true)
}

# close ZIP file
$zip.Dispose()