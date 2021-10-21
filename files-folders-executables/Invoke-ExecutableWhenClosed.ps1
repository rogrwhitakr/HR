function Invoke-ExecutableWhenClosed {

}

$process = "Cloudya"
$executable = "C:\Users\bosterholt\AppData\Local\Programs\cloudya-desktop\Cloudya.exe"

while ($true) {

    If (get-process -Name $process -ErrorAction SilentlyContinue) {

        # do nothing but sleep
        Write-Warning -Message "waiting 10 seconds"
        Start-Sleep -Seconds 10
    } 
    else {

        Write-Warning -Message "starting application $process"
        Start-Process -FilePath $executable -WindowStyle Hidden
        
    
    }
}