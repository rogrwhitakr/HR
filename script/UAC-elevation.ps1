
# Check if Elevated
$identity = [system.security.principal.windowsidentity]::GetCurrent()
$prinicpal = New-Object System.Security.Principal.WindowsPrincipal($identity)
$admin = [System.Security.Principal.WindowsBuiltInRole]::administrator
if ($prinicpal.IsInRole($admin)) {
    "Elevated PowerShell session detected. Continuing."
}
else {
    "This application/script must be run in an elevated PowerShell window. Please launch an elevated session and try again."
    Break
}