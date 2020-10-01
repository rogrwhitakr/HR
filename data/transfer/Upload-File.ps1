function Register-WINSCPdll {
    param (
        [System.String]
        [Parameter( Mandatory = $false,
            ValueFromPipeline = $true)]
        [ValidateScript( {Test-Path $_ })]
        $Path
    )

    if ($Path) {
        $env:WINSCP_PATH = $Path
    }
    else {
        $env:WINSCP_PATH = 'C:\Program Files (x86)\WinSCP'    
        Add-Type -Path (Join-Path $env:WINSCP_PATH 'WinSCPnet.dll')
    }
}

function Register-FTPServer {
    param (
        [System.String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "the FTP Server to Upload to")] 
        [ValidateSet('FTP', 'UPLOAD', 'DOWNLOAD')]
        $UploadOption   
    )
    Register-WINSCPdll
    # using winscp 

    switch ($UploadOption) {
        FTP {
            return $FTP = @{
                SessionOptions = @{
                    Protocol              = [WinSCP.Protocol]::Sftp
                    HostName              = 'u119042.your-storagebox.de'
                    UserName              = 'u119042'
                    Password              = 'wVprfeRDpZP0x1Fp'    
                    SshHostKeyFingerprint = "ssh-rsa 2048 3d:7b:6f:99:5f:68:53:21:73:15:f9:2e:6b:3a:9f:e3"

                }
                Session        = @{
                    remotePath = "/FTP/Administrator/SE/SEOUT/"
                }
            }
        }
        DOWNLOAD {
            return $DOWNLOAD = @{
                SessionOptions = @{
                    Protocol              = [WinSCP.Protocol]::Sftp
                    HostName              = 'northern-lights.one'
                    UserName              = 'optito_0'
                    Password              = 'BuSiNeSs1FtP!'      
                    SshHostKeyFingerprint = "ssh-rsa 2048 66:46:7f:61:92:26:f0:11:4f:a6:de:c6:b2:79:18:e6"
                }
                Session        = @{
                    remotePath = "/Mitarbeiter/Administrator/"
                }
            }
        }
        UPLOAD {
            return $UPLOAD = @{
                SessionOptions = @{
                    Protocol              = [WinSCP.Protocol]::Sftp
                    HostName              = 'northern-lights.one'
                    UserName              = 'optito_2'
                    Password              = 'Nif5zEg8'      
                    SshHostKeyFingerprint = "ssh-rsa 2048 66:46:7f:61:92:26:f0:11:4f:a6:de:c6:b2:79:18:e6"
                }
                Session        = @{
                    remotePath = "/"
                }
            }
        }
    }
}

function Send-Remote {
    param (
        [System.Collections.Hashtable]
        [ValidateNotNullOrEmpty()]
        $Options
        ,
        [System.IO.FileInfo]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {Test-Path $_ -include *.zip, *.7z})]
        $UploadPacket
    )
    try {
    
        Register-WINSCPdll

        # Setup session options
        $sessionOptions = New-Object WinSCP.SessionOptions -Property $Options.SessionOptions
        $session = New-Object WinSCP.Session
    
        

        try {
            # Connect
            $session.Open($sessionOptions)

            # Upload files
            $transferOptions = New-Object WinSCP.TransferOptions
            $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
            
            # notify 
            'Uploading {0} to {1}' -f $UploadPacket, $Options.Session.remotePath
            $transferResult =
            $session.PutFiles($UploadPacket, $Options.Session.remotePath, $False, $transferOptions)
 
            # Throw on any error
            $transferResult.Check()
 
            # Print results
            foreach ($transfer in $transferResult.Transfers) {
                Write-Host "Upload of $($transfer.FileName) succeeded"
            }
        }
        finally {
            # Disconnect, clean up
            $session.Dispose()
        }
 
        exit 0
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }
}

function Send-Build {

    param (
        [System.String]
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = 'resource location, like \\JENKINS/BuildResults/Customer-Neurauter/release/v3.5.8')]
        [ValidateScript( {Test-Path $_ })]
        [ValidateNotNullOrEmpty()]
        $BuildSourcePath,

        [System.String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "the FTP Server to Upload to")] 
        [ValidateSet('FTP', 'UPLOAD', 'DOWNLOAD')]
        $UploadOption
    )
    try {  
        
        $Option = (Register-FTPServer -UploadOption $UploadOption)
        $build = New-OTBuild -BuildSourcePath $BuildSourcePath 
        Send-Remote -Options $Option -UploadPacket $build.FullName

    }
    catch {
        'Error: {0}' -f $_.Exception.Message
        exit 1
    }
}

#Send-tonorthern-lightsFTP -Options (Register-FTPServer -UploadOption 'DOWNLOAD') -UploadPacket (Get-ChildItem -Path 'C:\Users\Administrator\Desktop\se_all\timer-all.7z')
Start-Transcript -Path 'C:\MyScripts\windows\PS\file-type-operations\transfer\log.log'
Send-Build -BuildSourcePath '\\JENKINS/BuildResults/Customer-northern-lights-CE/release/v3.5.8' -UploadOption 'FTP'
Stop-Transcript