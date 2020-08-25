### INCOMPLETE ###

$file = Get-Content $profile

$file | Select-String 'function' -List

$file -match '^function\s\w+?\s'

$content -match '^timestamp=\d{4}\-\d{2}}-\d{2}$'

if ($content -match '^timestamp=\d{4}\-\d{2}\-\d{2}\s') {
    $matches[1] -replace '^timestamp=\d{4}\-\d{2}\-\d{2}\s', '\d{4}\-\d{2}\-\d{2}'
    Write-Host $matches[1]
}

$content -match '\d{4}\-\d{2}\-\d{2}'

$content -replace '^timestamp=\d{4}\-\d{2}\-\d{2}\s', '\d{4}\-\d{2}\-\d{2}'


$dateTime = $dateTime.AddHours(1)

        $version_path = Match-Path -ServerPath $version.DirectoryName
        Write-Output "Version_path:" $version_path
        Write-Output "Version:" $version.LastWriteTimeUtc

      #  $version_path = Match-Path -ServerPath $version.DirectoryName -ErrorAction SilentlyContinue
       # Write-Output $version_path