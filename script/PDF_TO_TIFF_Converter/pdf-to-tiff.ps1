Function Convert-PdfToTiff {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
 #       [ValidateScript( {Test-Path $_ -include *.pdf })]
        $InputFile

    )

    try {
        # C:\Program Files\gs\gs9.23\bin

        $in = Get-ChildItem -Path $InputFile

        $out = $in.BaseName + ".tif"
        $outargs = '-sOutputFile=' + $out

        'converting file {0} to {1}' -f $in, $out
        if ($out) {
            Start-Process -FilePath $tool -ArgumentList '-dNOPAUSE', '-sDEVICE=tiffg4', $outargs.ToString(), $in.FullName , '-r1200', '-c quit' -NoNewWindow
        }
    }
    catch {

        $ErrorMessage = $_.Exception.Message
        'An Error occurred. Please assign the Path to the Executable gswin64c. {0}' -f $ErrorMessage

    }
}

function Get-Tool {
    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
        [ValidateNotNullOrEmpty()]
        $ToolName
    )
    try {
        $tool = Join-Path -Path ${env:ProgramW6432} -ChildPath ( Get-ChildItem -Path ${env:ProgramW6432} -Name $ToolName -Recurse  )
        return $tool
    }

    catch {

        $ErrorMessage = $_.Exception.Message
        'An Error occurred. Please assign the Path to the Executable gswin64c. {0}' -f $ErrorMessage

    }
}

# execution

Set-Location -Path '\\nssrv\share\Mitarbeiter\Osterholt Benno\northern-lights CE\northern-lights DE\report-tour\pdf'
Set-Location -Path 'D:\GAS_STATION\Client\northern-lights\reports'



$tool = Get-Tool -ToolName "gswin64c.exe"

'tool: {1}' -f $tool

$pdfs = Get-ChildItem -Filter '*.pdf'

foreach ($pdf in $pdfs) {
    'pdf zu konvertieren, gerade: {0}' -f $pdf
    Convert-PdfToTiff -InputFile $pdf.FullName
}


# if logfile is older then 30 days, rename it
if ((New-TimeSpan -Start ((Get-childItem -path $logfile).CreationTimeUtc).ToDateTime() -End (Get-Date)).Days -gt 30) {
    Rename-Item -Path $logfile -NewName ((Get-Date -Format 'yyyy-MM-dd') + $logfile)
}

# if logfile is older then 60 days, delete it
#if (((New-TimeSpan -Start ($logfile.CreationTimeUtc) -End (Get-Date)).Days > 60)

# end logging
Stop-Transcript