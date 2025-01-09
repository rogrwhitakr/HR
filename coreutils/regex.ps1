# check sting for illegal CHARS

$mail = 'thomas.börsenberg@test.com'

$pattern = '[^a-z0-9\.@]'

if ($mail -match $pattern) {
    ('Invalid character in email address: {0}' -f $matches[0])
}

else {
    'Email address is good.'
}

############################################################################
### Finding Multiple Illegal Characters
############################################################################
# some email address
$mail = 'THOMAS.börßen_senbÖrg@test.com'
# list of legal characters, inverted by "^"
$pattern = '[^a-z0-9\.@]'

# find all matches, case-insensitive
$allMatch = [regex]::Matches($mail, $pattern, 'IgnoreCase')
# create list of invalid characters
$invalid = $allMatch.Value | Sort-Object -Unique

'Illegal characters found: {0}' -f ($invalid -join ', ')

############################################################################
### Check File Names for Illegal Characters
############################################################################
# check path:
$pathToCheck = 'c:\test\<somefolder>\f|le.txt'

# get invalid characters and escape them for use with RegEx
$illegal = [Regex]::Escape( -join [System.Io.Path]::GetInvalidPathChars())
$pattern = "[$illegal]"

# find illegal characters
$invalid = [regex]::Matches($pathToCheck, $pattern, 'IgnoreCase').Value | Sort-Object -Unique

$hasInvalid = $invalid -ne $null
if ($hasInvalid) {
    "Do not use these characters in paths: $invalid"
}
else {
    'OK!'
}


hostname

$data = ipconfig | select-string 'IPv4'
[regex]::Matches($data, "\b(?:\d{1,3}\.){3}\d{1,3}\b") | Select-Object -ExpandProperty Value

$data = "2390"
$data = "23,90"
$data = "21233,11"
$data = "2123344,11"
$data = "24,011"
$data = "some text"

$data.Replace(",", ".")

$pattern = '^\d{1,6}($|.\d{1,2})'
$pattern = '^[0-9]{1-6}'
$pattern = "\d[0-9]{1,5}(,\d[0-9]{2}|)"
[regex]::Matches($data, $pattern) | Select-Object -ExpandProperty Value


# match a digit

function Test-Input {

    [CmdletBinding()]

    param
    (
        [string]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $data
    )

    $data = $data.Replace(",", ".")
    $pattern = '^\d{1,7}($|.\d{2}$)'

    if (([regex]::Matches($data, $pattern)).Success -eq $true) {
        return [double]([regex]::Matches($data, $pattern)).Value
    }

    else {
        return [string] "please insert a number, maximum 7 digits, optionally 2 Nachkommastellen"
    }
}

$data = "2390"
$data = "23,90"
$data = "21233,11"
$data = "2123344,11"
$data = "24,011"
$data = "some text"
$data = "4587.15"

Test-Input -data $data

[regex]::Matches('APGFKLALKLEJKALKLKGEALGKGNLKA', ".{3}").Value -join ' '

#match a string with a pattern
function New-BuildName {
    [CmdletBinding()]
    param
    (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "the string to change")]
        [ValidateNotNullOrEmpty()]
        [String] $String

    )

    $pattern = '[^a-zA-Z0-9]'
    $index = $string.IndexOf("Customer")
    return ($string -replace ($pattern, '-')).Substring($index)

}

# match subnet and return its assigned location information (that we provide manually)

function Get-SubnetLocation {

    [CmdletBinding()]

    param
    (
        [string]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $data
    )

    switch -Regex ($data) {
        '^(10\.20\.210\.\d{1,3})$' { return "GRAZ" }
        '^(192\.168\.17\.\d{1,3})$' { return "WELS" }
        '^(192\.168\.102\.\d{1,3})$' { return "WIENER NEUSTADT" }
        '^(192\.168\.3\.\d{1,3})$' { return "HALL IN TIROL" }
        default { return "UNBEKANNTER STANDORT $data" }
    }
}

