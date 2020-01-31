#####################################################################
# Open New Excel Workbook / WorkSheet
$Excel = new-object -comobject excel.application
$ExcelWordBook = $Excel.Workbooks.Add()
$ExcelWorkSheet = $ExcelWordBook.Worksheets.Add()
$Excel.Visible = $true
 
#####################################################################
## Load Excel  file
$ExcelPath = 'C:\KM_Main.xlsx'
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$ExcelWordBook = $Excel.Workbooks.Open($ExcelPath)
$ExcelWorkSheet = $Excel.WorkSheets.item(&amp;amp;quot;Sheet 1&amp;amp;quot;)
 
#####################################################################
# Close connections to Excel
# set interactive to false so no save buttons are shown
$Excel.DisplayAlerts = $false
$Excel.ScreenUpdating = $false
$Excel.Visible = $false
$Excel.UserControl = $false
$Excel.Interactive = $false
## save the workbook
$Excel.Save()
## quit the workbook
$Excel.Quit()
## function to close all com objects
function Release-Ref ($ref) {
([System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ref) -gt 0)
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
}
## close all object references
Release-Ref($ExcelWorkSheet)
Release-Ref($ExcelWordBook)
Release-Ref($Excel)
 
 
#####################################################################
# Change to a different Worksheet
$ExcelWorkSheet = $Excel.WorkSheets.item(&quot;Sheet 2&quot;)
 
#####################################################################
# Update / Insert / Delete Value in a Cell
$ExcelWorkSheet.Cells.Item(1,1).Value2 = &quot;New Value&quot;
 
#####################################################################
# Read Cell
$ExcelWorkSheet.Cells.Item(1,1).Text
 
#####################################################################
# Delete Row / Column
[void]$ExcelWorkSheet.Cells.Item(1,1).EntireColumn.Delete()
[void]$ExcelWorkSheet.Cells.Item(1,1).EntireRow.Delete()
 
#####################################################################
# Find Last Used Column or Row
$ExcelWorkSheet.UsedRange.columns.count
$ExcelWorkSheet.UsedRange.rows.count
 
#####################################################################
# Sorting
$table = $ExcelWorkSheet.ListObjects | where DisplayName -EQ &quot;User_Table&quot;
$table.Sort.SortFields.clear()
$table.Sort.SortFields.add( $table.Range.Columns.Item(1) )
$table.Sort.apply()
 
#####################################################################
# Clear all formatting on a sheet
$tableRange = $ExcelWorkSheet.UsedRange
$tableRange.ClearFormats()
 
#####################################################################
# Using Excel Table Styles&amp;amp;lt;
## formatting from &amp;amp;lt;a href=&quot;http://activelydirect.blogspot.co.uk/2011/03/write-excel-spreadsheets-fast-in.html&quot;&amp;amp;gt;http://activelydirect.blogspot.co.uk/2011/03/write-excel-spreadsheets-fast-in.html&amp;amp;lt;/a&amp;amp;gt;
$listObject = $ExcelWorkSheet.ListObjects.Add([Microsoft.Office.Interop.Excel.XlListObjectSourceType]::xlSrcRange, $ExcelWorkSheet.UsedRange, $null,[Microsoft.Office.Interop.Excel.XlYesNoGuess]::xlYes,$null)
$listObject.Name = &quot;User Table&quot;
$listObject.TableStyle = &quot;TableStyleLight10&quot;
 
#####################################################################
# Auto-Sizing Columns / Rows
$ExcelWorkSheet.UsedRange.Columns.Autofit() | Out-Null
 
#####################################################################
# Formatting a Column
$ExcelWorkSheet.columns.item($formatcolNum).NumberFormat = &quot;yyyy/mm/dd&quot;
 
#####################################################################
# Formatting Text / Numbers Colours
# &amp;lt;a href=&quot;http://theolddogscriptingblog.wordpress.com/2009/08/04/adding-color-to-excel-the-powershell-way/&quot;&amp;gt;http://theolddogscriptingblog.wordpress.com/2009/08/04/adding-color-to-excel-the-powershell-way/&amp;lt;/a&amp;gt;
 
#####################################################################
# Format Text / Numbers Bold
$ExcelWorkSheet.Cells.Item(1,1).Font.Bold=$True
 
#####################################################################
# Add Hyperlink to cell
$link = &quot;http://www.microsoft.com/technet/scriptcenter&quot;
$r = $ExcelWorkSheet.Range(&quot;A2&quot;)
[void]$ExcelWorkSheet.Hyperlinks.Add($r, $link)
 
#####################################################################
# Add Comment to Cell
$ExcelWorkSheet.Range(&quot;D2&quot;).AddComment(&quot;Autor Name: `rThis is my comment&quot;)
 
#####################################################################
# Add a Picture to a Comment
$image = &quot;C:\test\Pictures\Kittys\gotyou.jpg&quot;
$ExcelWorkSheet.Range(&quot;C1&quot;).AddComment()
$ExcelWorkSheet.Range(&quot;d3&quot;).Comment.Shape.Fill.UserPicture($image)
 
#####################################################################
# Fix Location and Size of comment
$ExcelWorkSheet.Range(&quot;D3&quot;).Comment.Shape.Left = 100
$ExcelWorkSheet.Range(&quot;D3&quot;).Comment.Shape.Top = 100
$ExcelWorkSheet.Range(&quot;D3&quot;).Comment.Shape.Width = 100
$ExcelWorkSheet.Range(&quot;D3&quot;).Comment.Shape.Height = 100
 
#####################################################################
# Making a Comment/s visible
$comments = $ExcelWorkSheet.comments
foreach ($c in $comments) {
$c.Visible = 1
}
 
#####################################################################
# Add a Formula
$formula = &quot;=8*8&quot;
$ExcelWorkSheet.Cells.Item(1,1).Formula = $formula