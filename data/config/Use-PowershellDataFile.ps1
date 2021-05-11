function Get-Configuration {
	param()
	Import-PowerShellDataFile -Path "$PSScriptRoot\configuration.psd1"
	Import-PowerShellDataFile -Path "C:\repos\HR\apps\database\postgresql\database-config-prod.psd1"
}

$configuration = Get-Configuration

$configuration.DefaultServerConfig.ServerName

$configuration