
function Get-HDDFreeSpace {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $false )]
        [String]
        $Computer
    )
        Get-CimInstance win32_logicaldisk -filter "drivetype=3"  | `
            Format-Table -GroupBy PSComputername -Property DeviceID, Volumename, `
            @{Name = "SizeGB"; Expression = {[math]::Round($_.Size / 1GB)}}, `
            @{Name = "FreeGB"; Expression = {[math]::Round($_.Freespace / 1GB, 2)}}, `
            @{Name = "PercentFree"; Expression = {[math]::Round(($_.Freespace / $_.size) * 100, 2)}}

}

Get-HDDFreeSpace -Computer localhost