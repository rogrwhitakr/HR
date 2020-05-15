$file = "Lieferanten.csv"
$resulthashtable = @{ }
$arrayiterate = @()

$readfile = New-Object System.IO.StreamReader($file)

while (($line = $readfile.ReadLine()) -ne $null)
{
    $line
}