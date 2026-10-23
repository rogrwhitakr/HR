function Get-MsiPackageInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$Path
    )

    process {
        $fullPath = (Resolve-Path -LiteralPath $Path).ProviderPath

        $installer = $null
        $database  = $null
        $view      = $null

        try {
            $installer = New-Object -ComObject WindowsInstaller.Installer

            # OpenReadOnly mode = 0
            $database = $installer.GetType().InvokeMember(
                'OpenDatabase',
                [System.Reflection.BindingFlags]::InvokeMethod,
                $null,
                $installer,
                @($fullPath, 0)
            )

            # Query all properties without WHERE clause to avoid parser errors
            $query = "SELECT Property, Value FROM Property"
            $view = $database.GetType().InvokeMember(
                'OpenView',
                [System.Reflection.BindingFlags]::InvokeMethod,
                $null,
                $database,
                $query
            )

            $view.GetType().InvokeMember(
                'Execute',
                [System.Reflection.BindingFlags]::InvokeMethod,
                $null,
                $view,
                $null
            )

            $properties = @{}
            while ($record = $view.GetType().InvokeMember('Fetch', [System.Reflection.BindingFlags]::InvokeMethod, $null, $view, $null)) {
                $propName  = $record.GetType().InvokeMember('StringData', [System.Reflection.BindingFlags]::GetProperty, $null, $record, 1)
                $propValue = $record.GetType().InvokeMember('StringData', [System.Reflection.BindingFlags]::GetProperty, $null, $record, 2)
                $properties[$propName] = $propValue
                [System.Runtime.InteropServices.Marshal]::ReleaseComObject($record) | Out-Null
            }

            [PSCustomObject]@{
                ProductCode    = $properties['ProductCode']
                ProductName    = $properties['ProductName']
                ProductVersion = $properties['ProductVersion']
                Manufacturer   = $properties['Manufacturer']
                UpgradeCode    = $properties['UpgradeCode']
            }
        }
        finally {
            if ($null -ne $view)      { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($view) | Out-Null }
            if ($null -ne $database)  { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($database) | Out-Null }
            if ($null -ne $installer) { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($installer) | Out-Null }
            [System.GC]::Collect()
        }
    }
}
export-modulemember -function Get-MsiPackageInfo -Verbose