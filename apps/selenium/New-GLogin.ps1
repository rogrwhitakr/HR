# load data
Import-PowerShellDataFile -Path "$PSScriptRoot\configuration.psd1"


# OPTION 1: Import Selenium to PowerShell using the Add-Type cmdlet.
Add-Type -Path "$($workingPath)\WebDriver.dll"

# OPTION 2: Import Selenium to PowerShell using the Import-Module cmdlet.
Import-Module "$($workingPath)\WebDriver.dll"

# OPTION 3: Import Selenium to PowerShell using the .NET assembly class.
[System.Reflection.Assembly]::LoadFrom("$($workingPath)\WebDriver.dll")

# Create a new ChromeDriver Object instance.
$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver

# Launch a browser and go to URL
$ChromeDriver.Navigate().GoToURL('<https://powershell.org/profile/login/>')