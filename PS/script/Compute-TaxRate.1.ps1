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



function New-ComputeTaxRateWindow {

    Add-Type -AssemblyName System.Windows.Forms

    $TaxRateCompute = New-Object system.Windows.Forms.Form
    $TaxRateCompute.Text = "Steuersatz berechnen"
    $TaxRateCompute.TopMost = $true
    $TaxRateCompute.Width = 400
    $TaxRateCompute.Height = 320
    $TaxRateCompute.Icon = New-Object System.Drawing.Icon("tax.ico")

    # Check for ENTER and ESC presses
    $TaxRateCompute.KeyPreview = $True
    $TaxRateCompute.Add_KeyDown( {
            if ($_.KeyCode -eq "Enter") {
                $CalculateTaxRate.PerformClick()
            }
        })
    $TaxRateCompute.Add_KeyDown( {
            if ($_.KeyCode -eq "Escape") {
                $TaxRateCompute.Close()
            }
        })

    ################################################################
    # betrag

    $AmountLabel = New-Object system.windows.Forms.Label
    $AmountLabel.Text = "Nettobetrag"
    $AmountLabel.AutoSize = $true
    $AmountLabel.Width = 25
    $AmountLabel.Height = 10
    $AmountLabel.location = new-object system.drawing.point(20, 20)
    $AmountLabel.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($AmountLabel)

    $AmountTextBox = New-Object system.windows.Forms.TextBox
    $AmountTextBox.Width = 100
    $AmountTextBox.Height = 20
    $AmountTextBox.location = new-object system.drawing.point(35, 50)
    $AmountTextBox.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($AmountTextBox)

    ################################################################
    # 19 %

    $salesTaxLabel = New-Object system.windows.Forms.Label
    $salesTaxLabel.Text = "Umsatzsteuer (19%)"
    $salesTaxLabel.Name = 0.19
    $salesTaxLabel.AutoSize = $true
    $salesTaxLabel.Width = 25
    $salesTaxLabel.Height = 10
    $salesTaxLabel.location = new-object system.drawing.point(20, 90)
    $salesTaxLabel.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($salesTaxLabel)

    ################################################################
    # 7 %

    $grossAmountLabel = New-Object system.windows.Forms.Label
    $grossAmountLabel.Text = "Bruttobetrag:"
    $grossAmountLabel.Name = 1.19
    $grossAmountLabel.AutoSize = $true
    $grossAmountLabel.Width = 25
    $grossAmountLabel.Height = 10
    $grossAmountLabel.location = new-object system.drawing.point(20, 160)
    $grossAmountLabel.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($grossAmountLabel)
    # do the math thing

    $CalculateTaxRate_On_Click = {
        if ($AmountTextBox.Text -eq "") {
            $notification.text = "Nettobetrag darf nicht leer sein!"
            $grossAmountResult.Text = ""
            $salesTaxResult.Text = ""
        }
        elseif ((Test-Input -data $AmountTextBox.Text | Get-Member).TypeName -eq 'System.String') {
            $notification.text = (Test-Input -data $AmountTextBox.Text)
        }
        else { 
            $notification.text = ""   
            $grossAmountResult.Text = '{0:N2}' -f ([double]$grossAmountLabel.Name * (Test-Input -data $AmountTextBox.Text))
            $salesTaxResult.Text = '{0:N2}' -f ([double]$salesTaxLabel.Name * (Test-Input -data $AmountTextBox.Text))
        }

    }

    $CalculateTaxRate = New-Object system.windows.Forms.Button
    $CalculateTaxRate.Text = "berechnen"
    $CalculateTaxRate.Width = 150
    $CalculateTaxRate.Height = 25
    $CalculateTaxRate.location = new-object system.drawing.point(180, 50)
    $CalculateTaxRate.Font = "Microsoft Sans Serif,10"

    $CalculateTaxRate.Add_Click($CalculateTaxRate_On_Click)
    $TaxRateCompute.controls.Add($CalculateTaxRate)

    # ergebnis

    $salesTaxResult = New-Object system.windows.Forms.TextBox
    $salesTaxResult.Width = 150
    $salesTaxResult.Height = 20
    $salesTaxResult.location = new-object system.drawing.point(180, 120)
    $salesTaxResult.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($salesTaxResult)

    $grossAmountResult = New-Object system.windows.Forms.TextBox
    $grossAmountResult.Width = 150
    $grossAmountResult.Height = 20
    $grossAmountResult.location = new-object system.drawing.point(180, 190)
    $grossAmountResult.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($grossAmountResult)

    $notification = New-Object system.windows.Forms.Label
    $notification.Width = 350
    $notification.Height = 40
    $notification.text = ""
    $notification.location = new-object system.drawing.point(20, 230)
    $notification.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($notification)


    [void]$TaxRateCompute.ShowDialog()
    $TaxRateCompute.Dispose()

}

New-ComputeTaxRateWindow