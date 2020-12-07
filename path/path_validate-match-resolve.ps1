function Resolve-UncPath {
    
    param (
    
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Path")] 
        [ValidateNotNullOrEmpty()]     
        $Path
    )
    
    if ([bool]([uri]$Path).IsUnc -and $Path -notmatch '\\\\\w+\\\w+') {
    
        Throw "The UNC path should be of the form \\server\share."
        
    }
        
    else {
    
        if ((Test-Path $Path -PathType Container -IsValid) -and ((Get-Item $Path).PSProvider.Name -eq 'FileSystem')) {
            return $true
        }
        else {
            return $false
        }
    }
}

# example
Resolve-UncPath -Path <unc_path>

######################################################################################################################################################################################
function Resolve-PatternInPath {
        
    <#
        .SYNOPSIS
          Resolve-PatternInPath
        
        .DESCRIPTION
          This function validates a path, to check against a subset of path.
        
        .PARAMETER
          Path    = path to chcek
          Pattern = pattern to check against
            
        .OUTPUTS
          returns resolved path
        
        .NOTES
          Version:        1.1
          
        #>
        
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $Path,
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $Pattern
    )
        
    try {      
            
        if ((Test-Path -Path $Path) -eq $true ) {
            if ( $Path.Contains($Pattern)) {
                $resolved = Resolve-Path -Path $Path
                return $resolved
            }
        }
    }
        
    catch {
        
        $ErrorMessage = $_.Exception.Message
        Write-Output "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        
    }
        
}

# example
Resolve-PatternInPath -Path "D:\service\log" -Pattern "service\log"