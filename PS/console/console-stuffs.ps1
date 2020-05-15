
function Line {

    param (

        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 0, HelpMessage = "the line is made up of...")] 
        [ValidateNotNullOrEmpty()]     
        $Separator = '*'
    )

    $WindowsSize = $Host.UI.RawUI.BufferSize.Width
    $buffer = $Separator * $WindowsSize

    if (($buffer.Length) -gt $WindowsSize) {
        $buffer = $buffer.Remove($WindowsSize)
    }

    $stringBuilder = New-Object System.Text.StringBuilder
    $stringBuilder.Append($buffer).ToString()
}

line -Separator northern-lights*

line


function Write-ConsoleMessage {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "the line is made up of...")] 
        [ValidateNotNullOrEmpty()]     
        $Message = '*',

        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 1, HelpMessage = "the color of the line")] 
        [ValidateSet('RED', 'YELLOW', 'GREEN')]     
        $ForegroundColor = (Get-Host).UI.RawUI.ForegroundColor,

        [INT]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 2, HelpMessage = "how long should the message display?")] 
        [ValidateScript( {
                if (($_.getType()).name -eq 'Int32') {
                    $true
                }
                else {
                    $false
                }
            })]     
        $Duration = 1

    )


    $esc = [char]27
    $consoleWidth = [Console]::BufferWidth
    $outputText = $Message.PadRight($consoleWidth) 
    $gotoFirstColumn = "$esc[0G"
    Write-Host "$gotoFirstColumn$outputText" -NoNewline -ForegroundColor $ForegroundColor
    Start-Sleep -Seconds $Duration
}
 

Write-ConsoleMessage -Message 'Starting...' -Duration 2
Write-ConsoleMessage -Message 'Doing important processing work !!!' -ForegroundColor YELLOW 
$versions = Get-ChildItem -Recurse -Include 'VERSION' -Path $env:COMPUTERNAME
Write-ConsoleMessage -Message $versions.FullName.ToString() -ForegroundColor GREEN	

$ColoredName = @{
    Name       = "Name"
    Expression = {
        switch ($_.Extension) {
            '.exe' { $color = "255;0;0"; break }
            '.log' { $color = '0;255;0'; break }
            '.ini' { $color = "0;0;255"; break }
            default { $color = "255;255;255" }
        }
        $esc = [char]27
        "$esc[38;2;${color}m$($_.Name)${esc}[0m"
    }
}
 
Get-ChildItem $env:windir |
    Select-Object -Property Mode, LastWriteTime, Length, $ColoredName 
