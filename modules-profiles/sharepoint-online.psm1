$SiteUrl = "https://seefelder-my.sharepoint.com/personal/benno_osterholt_ncv_de"
$Credential = Get-Credential -UserName benno.osterholt@ncv.de
Connect-PnPOnline -Url $SiteUrl -Credential $Credential