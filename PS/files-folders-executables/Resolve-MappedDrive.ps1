

# Resolving Mapped Drives

# make sure the below drive is a mapped network drive
# on your computer

function Resolve-MappedDrive {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 1, HelpMessage = "DrivePath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $MappedDrivePath
    )

    $drive = $MappedDrivePath.Substring(($MappedDrivePath.indexOf(':') + 1) , ($MappedDrivePath.Length - $MappedDrivePath.indexOf(':') - 1))
    $result = (Get-PSDrive -Name $MappedDrivePath.Substring(0, 1) | Select-Object -ExpandProperty DisplayRoot) + $drive

    if (Test-Path $result) {
        return $result
    }
}

Resolve-MappedDrive -MappedDrivePath 'Y:\JIRA\#293'
Resolve-MappedDrive -MappedDrivePath 'M:\Documentation'