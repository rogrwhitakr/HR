
# get available parameter attributes and types stuff
# If you ever wondered what your choices are with these attributes, here is how. All you need to know is the true name of the type that represents an attribute. PowerShell’s own attributes all reside in the System.Management.Automation namespace. Here are the two most commonly used:
#
# [Parameter()] = [System.Management.Automation.ParameterAttribute] 
# [CmdletBinding()] = [System.Management.Automation.CmdletBindingAttribute]

[System.Management.Automation.ParameterAttribute]::new() |  Get-Member -MemberType *Property | Select-Object -ExpandProperty Name

# hidden parameters
function Test-Something {
    param
    (
        [string]
        [Parameter(Mandatory)]
        $Name,
       
        [Parameter(DontShow)]
        [Switch]
        $Internal
    )
} 

function Test-SomethingElse {
    [CmdletBinding()]
    Param
    (
        [string]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $MailConfig,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $PopUp,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")]
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "File/Directory to backup to")]
        [ValidateScript( { Test-Path $_ })]
        $BackupPath,

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
        $Duration = 1,

        [Int]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Port")] 
        [ValidateRange(0, 65123)]     
        $Port,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)] 
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9]\.exe$')]
        $Executable,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Action")] 
        [ValidateSet("Start", "Stop", "Pause", "Resume", "Reset")]     
        $another_Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "Virtual Machine Name")] 
        [ValidateNotNullOrEmpty()]     
        $VirtualMachine,

        [Switch]
        [Parameter(Mandatory = $false)]
        $Headless,

        [string]
        [ValidateNotNullOrEmpty()]  
        [ValidateScript({ (Test-Path $_) -and ((Get-Item $_).Extension -eq ".ini") })]  
        [Parameter(ValueFromPipeline = $True, Mandatory = $True)]  
        $FilePath  ,
        
        [System.IO.FileInfo]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ -include *.zip, *.7z })]
        $UploadPacket

    )
    return "imma hustela!"
}