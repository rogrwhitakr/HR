Function New-DesktopShortcut {
    <#
        .SYNOPSIS
        Creates a Desktop Shortcut in a User's profile

        .PARAMETER Target
        [String]
        The full path of the executable/file to which you are creating a shortcut.

        .PARAMETER ShortcutPath
        The path name of the new Shortcut.
        
        .PARAMETER IconPath
        The full path to an icon for the shortcut.

        .EXAMPLE
        New-DesktopShortcut -TargetExecutable "C:\Program Files(x86)\SuperSoftware\SuperCool.exe" -ShortcutPath = "$env:Public\Desktop\SuperCool.lnk"
        
        .EXAMPLE
        New-DesktopShortcut -TargetExecutable "C:\Program Files(x86)\SuperSoftware\SuperCool.exe" -ShortcutPath = "$env:Public\Desktop\SuperCool.lnk" -IconPath 'C:\icons\fancy.ico'
    
    #>
    [cmdletBinding()]
    Param(
        
        [Parameter(Mandatory, Position = 0)]
        [String]$Target,
        [parameter(Mandatory, Position = 1)]
        [String]$ShortcutPath,
        [Paramter(Mandatory = $false, Position = 2)]
        [String]$IconPath
        
    )

    $Shell = New-Object -ComObject Wscript.Shell
    $DesktopShortcut = $Shell.CreateShortcut($ShortcutPath)
    $DesktopShortcut.TargetPath = $Target
    $DesktopShortcut.WorkingDirectory = Split-Path -Path $Target
    
    If($IconPath){
        
        $DesktopShortcut.IconLocation($IconPath,0)
    
    }
    
    $DesktopShortcut.Save()

}