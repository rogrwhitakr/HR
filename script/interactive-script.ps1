function Hide-PowerShell { 
    [void]$showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 2) 
}

function Show-PowerShell { 
    [void]$showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 10) 
}

$GO_NO_GO = Read-Host -Prompt 'Continue (y/n)' 
$Age = Read-Host "Please enter your age"

if (($GO_NO_GO) -and ($GO_NO_GO.ToLower() -eq 'y')) {
    'the age of {0}' -f $Age
    Start-Sleep 5
    Hide-PowerShell
    Start-Sleep 5
    Show-PowerShell
}
else {
    'we dont continue?....{0}' -f $GO_NO_GO
}