function Test-ForDuplicateProcess {

    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        $ProcessPath,
		
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        $ProcessCommandLine
    )

	$process = (Get-CimInstance -ClassName win32_process | `
		Where-Object {$_.path -eq $ProcessPath -and $_.commandline -match $ProcessCommandLine})

	$count = ($process | Measure-Object).count

	if ($count > 1) {
		Write-Output "more than one $ProcessCommandLine processes. Killing processes. does that even work?"
		
		foreach ($proc in $process) {
			Write-Output "Killing process $proc"
			get-process -Id ($proc).ProcessId | stop-process
		}
	}
	
	else {
		Write-Output "one or none $ProcessCommandLine process running. All fine"
	}
}

test-ForDuplicateProcess -ProcessPath 'D:\Optitool\Client\jre64\bin\java.exe' -ProcessCommandLine 'Actualdata Service PACKED'