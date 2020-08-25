################################################################
# functions
function Test-Input {

    [CmdletBinding()]

    param
    (
        [string]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)]
        $data
    )

    $data = $data.Replace(",", ".")
    $pattern = '^\d{1,7}($|.\d{2}$)'

    if (([regex]::Matches($data, $pattern)).Success -eq $true) {
        return [double]([regex]::Matches($data, $pattern)).Value
    }

    else {
        return [string]"Nettobetrag muss numerisch sein, max zwei Nachkommastellen!"
    }
}



function New-PDFToTIFConverter {

    Add-Type -AssemblyName System.Windows.Forms

    $TiffConverter = New-Object system.Windows.Forms.Form
    $TiffConverter.Text = "PDFs zu TIFs konvertieren"
    $TiffConverter.TopMost = $true
    $TiffConverter.Width = 500
    $TiffConverter.Height = 520
    $TiffConverter.Icon = New-Object System.Drawing.Icon(((Split-Path -Parent $PSScriptRoot -Resolve) + "\" + "tax.ico"))

    # Check for ENTER and ESC presses
    $TiffConverter.KeyPreview = $True
    $TiffConverter.Add_KeyDown( {
            if ($_.KeyCode -eq "Enter") {
                $CalculateTaxRate.PerformClick()
            }
        })
    $TiffConverter.Add_KeyDown( {
            if ($_.KeyCode -eq "Escape") {
                $TiffConverter.Close()
            }
        })

    ################################################################
    # betrag

    $PathSelectionLabel = New-Object system.windows.Forms.Label
    $PathSelectionLabel.Text = "Pfad auswählen"
    $PathSelectionLabel.AutoSize = $true
    $PathSelectionLabel.Width = 25
    $PathSelectionLabel.Height = 10
    $PathSelectionLabel.location = new-object system.drawing.point(20, 20)
    $PathSelectionLabel.Font = "Microsoft Sans Serif,10"
    $TiffConverter.controls.Add($PathSelectionLabel)

    $PathContentsTextBox = New-Object system.windows.Forms.TextBox
    $PathContentsTextBox | gm
    $PathContentsTextBox.Width = 400
    $PathContentsTextBox.Height = 320
    $PathContentsTextBox.location = new-object system.drawing.point(35, 100)
    $PathContentsTextBox.Font = "Microsoft Sans Serif,10"
    $TiffConverter.controls.Add($PathContentsTextBox)

    # do the math thing

    $CalculateTaxRate_On_Click = {
        if ($PathContentsTextBox.Text -eq "") {
            $notification.text = "Nettobetrag darf nicht leer sein!"

        }
        elseif ((Test-Input -data $PathContentsTextBox.Text | Get-Member).TypeName -eq 'System.String') {
            $notification.text = (Test-Input -data $PathContentsTextBox.Text)
        }
        else {
            $notification.text = ""
        }

    }

    $CalculateTaxRate = New-Object system.windows.Forms.Button
    $CalculateTaxRate.Text = "berechnen"
    $CalculateTaxRate.Width = 150
    $CalculateTaxRate.Height = 25
    $CalculateTaxRate.location = new-object system.drawing.point(180, 450)
    $CalculateTaxRate.Font = "Microsoft Sans Serif,10"

    $CalculateTaxRate.Add_Click($CalculateTaxRate_On_Click)
    $TiffConverter.controls.Add($CalculateTaxRate)

    # ergebnis

    $notification = New-Object system.windows.Forms.Label
    $notification.Width = 350
    $notification.Height = 40
    $notification.text = ""
    $notification.location = new-object system.drawing.point(20, 430)
    $notification.Font = "Microsoft Sans Serif,10"
    $TiffConverter.controls.Add($notification)

    $OpenDirectoryDialogSelector = New-Object system.windows.Forms.Button
    $OpenDirectoryDialog = New-Object Windows.Forms.FolderBrowserDialog

    $OpenDirectoryDialogSelector.Text = "select path"
    $OpenDirectoryDialogSelector.Width = 150
    $OpenDirectoryDialogSelector.Height = 30
    $OpenDirectoryDialogSelector.location = new-object system.drawing.point(35, 50)
    $OpenDirectoryDialogSelector.Font = "Microsoft Sans Serif,10"
    $TiffConverter.controls.Add($OpenDirectoryDialogSelector)

    $OpenDirectoryDialog.RootFolder = 'Desktop'

    $OpenDirectoryDialogSelector_On_Click = {
        $OpenDirectoryDialog.ShowDialog() | Out-Null
        if ($OpenDirectoryDialog.SelectedPath) {
            $selectedPath = $OpenDirectoryDialog.SelectedPath
            $items = Get-ChildItem -path $selectedPath -Depth 1 -File -Filter '*.pdf'
            '{0}' -f $items.ToString()
            $stringBuilder = New-Object System.Text.StringBuilder
            $stringBuilder.Append("PDFs:`r").ToString()
            $stringBuilder.Append("`n").ToString()
            $stringBuilder.Append("`n").ToString()
            $stringBuilder.Append($selectedPath)
            $stringBuilder.Append("`n").ToString()
            $stringBuilder.Append($items.BaseName).ToString()
            $PathContentsTextBox.AppendText($items.Name)
        }
    }

    $OpenDirectoryDialogSelector.Add_Click($OpenDirectoryDialogSelector_On_Click)


    [void]$TiffConverter.ShowDialog()
    $TiffConverter.Dispose()

}

New-PDFToTIFConverter