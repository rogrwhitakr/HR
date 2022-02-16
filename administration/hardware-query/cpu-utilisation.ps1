function Get-CpuUtilisation {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 1)]
        $ComputerName = 'localhost'
    )

    return get-wmiobject -ComputerName $ComputerName -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average -Maximum
}

$average = @()

while($true) {

    # first we wait
    Start-Sleep 5

    # we measure
    $cpu = Get-CpuUtilisation -ComputerName 'localhost'
    $average = $average + $cpu.Average
    $measure = $average | Measure-Object -Average -Sum -Maximum

    # we tell
    Write-warning -Message ('{2} => AVG {0}/100, MAX => {1}/100' -f $measure.Average, $measure.Maximum, $measure.count)

 #   $average | Measure-Object -Average -Sum -Maximum
    if ($measure.Maximum -gt 85 ){
        Write-warning -Message "OVER"
    }
    else{
        
        Write-warning -Message "DIDNT HAPPEN"
    }

}

