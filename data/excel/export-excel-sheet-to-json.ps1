Install-Module ImportExcel -Scope CurrentUser

$xlsx = "C:\Users\benno.osterholt\OneDrive - SEEFELDER GmbH\csv-to-json.xlsx"
$sheet = "20251113011604"
$out  = "C:\Users\benno.osterholt\OneDrive - SEEFELDER GmbH\output.json"

$data = Import-Excel -Path $xlsx -WorksheetName $sheet
$data | ConvertTo-Json -Depth 100 | Out-File -FilePath $out -Encoding utf8