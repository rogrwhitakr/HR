
$uri = 'https://uinames.com/api/?region=germany'
$uri = 'https://uinames.com/api/'
$uri = 'https://uinames.com/api/?region=germany?amount=25'

Invoke-WebRequest -Uri $uri -UseBasicParsing -Verbose
