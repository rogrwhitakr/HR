
function Get-OperationSystem{
    switch ($env:OS) {
        Windows_NT {
            Write-Host -ForegroundColor RED "WINDOOOS"
          }
        LINUX {
            Write-Host -ForegroundColor RED "LINUX. can this event work?"
          }
        Default {
            Write-Host -ForegroundColor RED "DEFAULT"
        }
    }
}    

Get-OperationSystem