$excel = New-Object -ComObject Excel.Application
# open Excel file
$workbook = $excel.Workbooks.Open("c:\test\excelfile.xlsx" )
 
# uncomment next line to make Excel visible
#$excel.Visible = $true
 
$sheet = $workbook.ActiveSheet
$column = 1
$row = 1
$info = $sheet.cells.Item($column , $row).Text
$excel.Quit()
 
 
"Cell A1 contained '$info'" 

$excel = New-Object -ComObject Excel.Application
# open Excel file
$workbook = $excel.Workbooks.Open("c:\test\excelfile.xlsx" )
 
# uncomment next line to make Excel visible
#$excel.Visible = $true
 
$sheet = $workbook.ActiveSheet
$column = 1
$row = 1
# change content of Excel cell
$sheet.cells.Item($column,$row) = Get-Random
# save changes
$workbook.Save()
$excel.Quit() 
