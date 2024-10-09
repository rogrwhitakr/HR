
$gadu =@{
    "Properties" = "PasswordNotRequired","PasswordLastSet"
    "Filter" = '(PasswordLastSet -eq "0") -and (PasswordNotRequired -eq $false)'
    "SearchBase" = "OU=Sales,DC=contoso,DC=com"
    }
    
Get-ADUser @gadu

Get-ADUser -LDAPFilter '(!userAccountControl:1.2.840.113556.1.4.803:=2)'

get-adUser -objectGuid "16fc04d3-a2c2-4b3b-8e41-e4e33d6e834f" -gu