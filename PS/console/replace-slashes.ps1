
function Set-ForwardSlashes {
    [CmdletBinding()]
    param
    (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "the string to change")]
        [ValidateNotNullOrEmpty()]
        [String] $String

    )

    return $string.Replace("\", "/")

}

function Set-BackwardSlashes {
    [CmdletBinding()]
    param
    (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "the string to change")]
        [ValidateNotNullOrEmpty()]
        [String] $String

    )

    return $string.Replace("/", "\")

}


Set-BackwardSlashes "\\path/with/slashes/and/more"

Set-ForwardSlashes -String "\\path\with\slashes\and\northern-lights"

# get to path like so. works in a pipeline also
Invoke-Item -Path "\\path\with\slashes\and\northern-lights"
