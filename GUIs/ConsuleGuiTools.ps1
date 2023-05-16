# install
Install-Module -Name Microsoft.PowerShell.ConsuleGuiTools

# Import the module
Import-Module Microsoft.PowerShell.ConsoleGuiTools

# Load the Terminal.Gui assembly
$module = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -List).ModuleBase
Add-Type -Path (Join-path $module Terminal.Gui.dll)

# Initialise Terminal.Gui
[Terminal.Gui.Application]::Init()

# Create a message box and assign the result of a selection to a variable
$result = [Terminal.Gui.MessageBox]::Query("Important", "Do you love PowerShell?", @("Yes", "No"))

# Utilise the result of the selection
# Write output to the terminal window and close the message box
if ($result -eq 0)
{
    # Shutdown the GUI application gracefully
    [Terminal.Gui.Application]::shutdown()
    write-host("It's good you love PowerShell!")
}
if ($result -eq 1)
{
    # Shutdown the GUI application gracefully
    [Terminal.Gui.Application]::shutdown()
    write-host("Too bad, PowerShell is great. Give it a chance.")
}