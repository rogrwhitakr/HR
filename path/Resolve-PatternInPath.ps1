function Resolve-PatternInPath {

    <#
    .SYNOPSIS
      Resolve-PatternInPath
    
    .DESCRIPTION
      This function validates a path, to check against a subset of path.
    
    .PARAMETER
      Path    = path to check
      Pattern = pattern to check against
        
    .OUTPUTS
      returns resolved path
    
    .NOTES
      Version:        1.1
      
    .EXAMPLE
      ckeck if path contains pattern 
      Resolve-PatternInPath -Path 'D:\Engine\service\log' -Pattern 'service\log' | fl
    #>
    
        [CmdletBinding()]
        param
            (
            [String]
            [Parameter( Mandatory=$true, ValueFromPipeline = $true)]
            $Path,
            [String]
            [Parameter( Mandatory=$true, ValueFromPipeline = $true)]
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