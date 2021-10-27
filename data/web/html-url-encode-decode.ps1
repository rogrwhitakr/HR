Add-Type -AssemblyName System.Web
[System.Web.HttpUtility]::HtmlEncode('something <somthing else>')

$urlToEncode = "
Guten Tag Herr XY,

ich wollte nachfragen, wie weit sie mit Ihren Validierungstests für Programm gekommen sind.
zum Testen der Webanwendungen (bzw deren Aufruf) habe ich da Programm über die Citrix-Oberfläche gestartet, hier gibt es allerdings noch ein Problem:

Der Client wird auf einem Terminal-Server aufgerufen, dieser müsste noch verteilt werden an die verwendeten Terminal-Server.

Können Sie mir hier weiterhelfen?

Freundliche Grüße / Best Regards,
"
$urlToDecode = "subject=Erneuerung%20der%20Zugangsdaten%20f%C3%BCr%20den%20Nutzer%20%22asder%22&body=Hallo%20Herr%20XY%2C%0A%0Adie%20G%C3%BCltigkeit%20des%20Logins%20f%C3%BCr%20den%20User%20%22TESTY%22%20ist%20abgelaufen.%20K%C3%B6nnen%20Sie%20ein%20neues%20Passwort%20f%C3%BCr%20den%20Benutzer%20erzeugen%3F"


[System.Web.HttpUtility]::UrlEncode($urlToEncode) 
[System.Web.HttpUtility]::UrlDecode($urlToDecode) 
