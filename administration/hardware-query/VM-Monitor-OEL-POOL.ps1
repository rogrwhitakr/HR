function Get-CpuUtilisation {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 1)]
        $ComputerName = 'localhost'
    )

    return get-wmiobject -ComputerName $ComputerName -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average -Maximum
}

function Read-XMLConfig {

    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        $ConfigurationFile
            
    )

    $cfg = $ConfigurationFile 

    try {
        if ((Test-Path -Path $cfg) -eq $true) {
            $config = [xml] ( Get-Content -Path $cfg )
            return $config
        }   
        else {
            Write-Warning -Message ("Could not find or read configuration file {0}" -f $file)
            return 
        }
    }
    catch {

        $ErrorMessage = $_.Exception.Message
        Write-Error "ERROR: "$ErrorMessage"`n" $_.Exception.ErrorDetails
        Write-Error "DETAILS:" $_.Exception.ErrorDetails

    }
}

# vars
# mail config location
$config = 'C:\repos\OPTITOOL\mail-server\mailConfig.optitool.xml'
$average = @()

# main loop
while ($true) {

    # first we wait
    Start-Sleep 5

    # we measure
    $cpu = Get-CpuUtilisation -ComputerName 'localhost'
    $average = $average + $cpu.Average
    $measure = $average | Measure-Object -Average -Sum -Maximum

    # we tell
    Write-warning -Message ('{2} => AVG {0}/100, MAX => {1}/100' -f $measure.Average, $measure.Maximum, $measure.count)

    #   $average | Measure-Object -Average -Sum -Maximum
    if ($measure.Maximum -gt 85 ) {
        $config = Read-XMLConfig -ConfigurationFile $config 

        # the OT config is *special*
        [system.string]$stringdata = $config.ChildNodes.'#text'

        # convert to parsed data that can be used
        $values = ConvertFrom-StringData -StringData $stringdata


        # send the email
        $MailParams = @{
            From       = $values.'mail.smtp.from'
            To         = 'benno.osterholt@optitool.de'
            Subject    = ('Host {0} => CPU Utilisation is over 85 % => {1}' -f $env:COMPUTERNAME, $measure.Maximum)    
            Body       = ('Host {0} => CPU Utilisation is over 85 % => {1}{2}{3}' -f $env:COMPUTERNAME, `
                    $measure.Maximum, `
                    [Environment]::NewLine, `
                    'Action required')  
            SMTPServer = $values.'mail.smtp.host'
            Port       = $values.'mail.smtp.port'
            UseSsl     = if ($values.'mail.smtp.port' -ne '25') { $true } else { $false }
            Credential = New-Object System.Management.Automation.PSCredential -ArgumentList `
            ((ConvertTo-SecureString -string $values.'username' -AsPlainText -Force), `
                (ConvertTo-SecureString -string $values.'password' -AsPlainText -Force))
        }

        try {
            Send-MailMessage @MailParams -Verbose
        }
        catch {
            $_ | Write-Error
        }
    }
    else {
        continue
    }

}
