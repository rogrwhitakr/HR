
$zip_directory = 'C:\Users\<user>\Desktop\<service>\backup'
$destination_directory = 'C:\Users\<user>\Desktop\<service>\new'
$zip_backups = 'C:\Users\<user>\Desktop\<service>\original'
$zipfiles = Get-ChildItem -Path $zip_directory -Filter *.zip -Attributes Archive

ForEach ($zipfile in $zipfiles) {
    Expand-Archive -Path $zipfile.FullName -DestinationPath $destination_directory -Force
    # when complete we could move the zip file
    Move-Item -Path $zipfile.FullName -Destination $zip_backups
}