# usage: 
# Convert-Vmdk -source 'G:\northern-lights.vmdk' -DestinationPath 'C:\VM\Windows7\'

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "VMDK File")] 
        [ValidateScript( {Test-Path $_ })]
        [ValidateScript( {Test-Path $_ -include *.vmdk})]
        [ValidateNotNullOrEmpty()]     
        $source,
        
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "destination")]
        [ValidateScript( {Test-Path $_ })]
        [ValidateNotNullOrEmpty()]     
        $DestinationPath
    )

    $MVMC_path = 'C:\Program Files\Microsoft Virtual Machine Converter\'

    if (Test-Path -Path $MVMC_path) {
        Import-Module (Join-Path -Path $MVMC_path -ChildPath 'MvmcCmdlet.psd1' ) -Verbose
    }
    else {
        'Path {0} does not exist.' -f $MVMC_path
        'please install the Microsoft Machine Converter.'
        'https://www.microsoft.com/en-us/download/details.aspx?id=42497'
        exit
    }

    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        'we aint admin. go check that level!!!' 
        exit
    }

    # we are checking for the command we are using...
    if (Get-Command ConvertTo-MvmcVirtualHardDisk -errorAction SilentlyContinue) {
        'converting the VMDK into VHDX'
        ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $source -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestinationPath -Verbose
        'finished converting source {0}' -f $source
        'results in {0}' -f $DestinationPath
    }

    else {
        'maybe importing the module did not work?'
        exit
    }

