

# pop-up box
function Pop-Up {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $PopUp
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($PopUp, [System.Windows.Forms.MessageBoxButtons]::OK)
}

Pop-Up -PopUp ('TIME TO GO !!!{1}Es ist {0} !!!' -f (Get-Date).DateTime, [Environment]::NewLine)

# yes no message box
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Do you want to restart?','Restart','YesNo','Warning')
