function Show-MessageBox {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $false )]
        [String]
        $Text,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false )]
        [String]
        $Caption,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false )]
        [Windows.MessageBoxButton]
        $Button,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false )]
        [Windows.MessageBoxImage]
        $Icon

    )

    process {
        try {
            [System.Windows.MessageBox]::Show($Text, $Caption , $Button, $Icon)
        }
        catch {
            Write-Warning "Error occured: $_"
        }
    }
}

Show-MessageBox