
function ConvertTo-Base64 {
    param (
        [Parameter(Mandatory = $true)]
        [string]$file
    )

    if (-not (Test-Path $file)) {
        Write-Error "Datei '$file' wurde nicht gefunden."
        return
    }
    else {
        $file = Get-ChildItem -Path $file
    }

    try {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $base64 = [Convert]::ToBase64String($bytes)
        $base64 | clip
        Write-Host "Base64-String wurde in die Zwischenablage kopiert."
    } catch {
        Write-Error "Fehler beim Konvertieren der Datei: $_"
    }
}