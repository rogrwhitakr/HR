function Get-Configuration {
	param()
	Import-PowerShellDataFile -Path "$PSScriptRoot\configuration.psd1"
}

$configuration = Get-Configuration

