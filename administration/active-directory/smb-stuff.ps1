

Get-Command -Noun "*smb*"

# get local shares
Get-SmbShare

# get only "real" shares
Get-SmbShare | Where-Object {$_.Special -ne $true}

# get access rights to local shares
Get-SmbShareAccess -Name (Get-SmbShare).Name

Get-SmbClientConfiguration