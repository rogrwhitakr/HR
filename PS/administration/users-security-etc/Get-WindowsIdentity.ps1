([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Values

# Using Localized User and Group Names
# returns the resolved name from the current user’s SID
([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Translate( [System.Security.Principal.NTAccount]).Value