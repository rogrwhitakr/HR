

Add-Type -AssemblyName System.Security;
[Text.Encoding]::ASCII.GetString([Security.Cryptography.ProtectedData]::Unprotect([Convert]::FromBase64String((Get-Content -raw (Join-Path -Path $env:USERPROFILE -ChildPath '.ssh'))), $null, 'CurrentUser'))