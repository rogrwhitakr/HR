read-host -Prompt "not further!!!"

######################################################################################

while(($line = $reader.ReadLine()) -ne $null)
{
    Add-Content -path $fileName -value $line
    if((Get-ChildItem -path $fileName).Length -ge $size)
    {
        ++$count
        $fileName = "{0}{1}.{2}" -f ($rootName, $count, $extension)
    }
}

$reader.Close()

######################################################################################

Remove-Item D:\Ten\admin\csv\*

$csv = Get-ChildItem 'C:\Users\Administrator\desktop\TEN_QT2.csv'
$destination = 'D:\Ten\admin\csv\'

Copy-Item -Path $csv -Destination $destination

$file = Get-ChildItem 'D:\Ten\admin\csv\TEN_QT2.csv'

Set-Location $file.Directory

$rootName = ($file.BaseName)
$extension = ($file.Extension)

$reader = new-object System.IO.StreamReader( $file )

$count = $idx = 0
$file_index = 0
$size = 1000

$fileName = "{0}_{1}{2}" -f ($rootName, $file_index, $extension)

try {
    while(($line = $reader.ReadLine()) -ne $null) {
        ++$count
        Write-Output "Reading line $count for $filename"
        Add-Content -path $fileName -value $line

        if ($count -gt $size) {

            ++$file_index

            $fileName = "{0}_{1}{2}" -f ($rootName, $file_index, $extension)
            Write-Output "Created new file $filename"
            $count = 0
            Write-Output "Reset count to $count"
        }
    }
}

catch {
        $ErrorMessage = $_.Exception.Message
        Write-Output "New-Hint Error: $ErrorMessage"
}

finally {
    $reader.Close()
}