#Requires -Version 7.0
function New-MarkdownMailToLink {
    [CmdletBinding()]
    Param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $markdownLinkRef,
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $To,
        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $Cc,
        [String]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $Bcc,
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $Subject,
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $Body
    )
    
    Add-Type -AssemblyName System.Web
    return "["`
     + $markdownLinkRef + `
     "](mailto:" + $To + `
    ($Cc ? "&cc=" + $Cc  : '' ) + `
     "?subject=" + [System.Web.HttpUtility]::UrlEncode($Subject) + `
     "&body=" + [System.Web.HttpUtility]::UrlEncode($body) + ")" 
    
}




New-MarkdownMailToLink -markdownLinkRef "Email-Template" -To "user@address.com" -Subject "subject test" -Body "
Guten Tag,

Der Server ist aktualisiert worden, allerdings sind nun weitere Schritte notwendig zum vollständigen Ausrollen des Programm-Updates:
Der Client wird von den Nutzern auf einem Terminal-Server aufgerufen, dieser Client muss noch auf die dafür verwendeten Terminal-Server verteilt werden. 
Diese Verteilung der Clients auf die XENAPP Server geschieht durch die IT.
 
Können Sie diese Verteilung vornehmen und Rückmeldung geben, sobald die Verteilung erfolgt ist
"


New-MarkdownMailToLink -markdownLinkRef "Email-Template" -To "user@address.com,user@address.com" -Cc "user@address.com" -Subject "Verteilung der Clients an die Benutzer / Terminal-Server" -Body "
Guten Tag,

Der Server ist aktualisiert worden, allerdings sind nun weitere Schritte notwendig zum vollständigen Ausrollen des Programm-Updates:
Der Client wird von den Nutzern auf einem Terminal-Server aufgerufen, dieser Client muss noch auf die dafür verwendeten Terminal-Server verteilt werden. 
Diese Verteilung der Clients auf die XENAPP Server geschieht durch die IT.
 
Können Sie diese Verteilung vornehmen und Rückmeldung geben, sobald die Verteilung erfolgt ist
"
