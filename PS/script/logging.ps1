$logfile = 'PDF_TO_TIFF_CONVERTER.log'
if (!(Get-ChildItem -Path 'PDF_TO_TIFF_CONVERTER.log')) {
    New-Item -Path $logfile
}

Start-Transcript -Path $logfile -Append -Verbose



# if logfile is older then 30 days, rename it
if ((New-TimeSpan -Start ((Get-childItem -path $logfile).CreationTimeUtc).ToDateTime() -End (Get-Date)).Days -gt 30) {
    Rename-Item -Path $logfile -NewName ((Get-Date -Format 'yyyy-MM-dd') + $logfile)
}

# if logfile is older then 60 days, delete it
#if (((New-TimeSpan -Start ($logfile.CreationTimeUtc) -End (Get-Date)).Days > 60)

# end logging
Stop-Transcript