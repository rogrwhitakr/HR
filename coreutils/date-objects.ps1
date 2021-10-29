# get a date with a specific format
$1 = Get-Date -Format 'yyyy-MM-dd'

# parse a date naf format to ~something~
$hypothetical_filename = "20180418_081736225getAllDatas.xml"
$2 = [datetime]::parseexact($hypothetical_filename.Substring(0, 18), "yyyyMMdd_HHmmssfff", $null)

# ausgabe
'$1 = {0} :: $2 = {1}' -f ($1, $2)
# compute timespan
New-TimeSpan -Start $1 -End $2

