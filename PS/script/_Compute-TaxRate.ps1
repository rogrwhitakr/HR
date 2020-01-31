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
        return [string]"muss numerisch sein, max zwei Nachkommastellen!"
    }
}


function New-ComputeTaxRateWindow {

    Add-Type -AssemblyName System.Windows.Forms

    $TaxRateCompute = New-Object system.Windows.Forms.Form
    $TaxRateCompute.Text = "Steuersatz berechnen"
    $TaxRateCompute.TopMost = $true
    $TaxRateCompute.Width = 400
    $TaxRateCompute.Height = 300
    $TaxRateCompute.Icon = New-Object System.Drawing.Icon("tax.ico")

    ################################################################
    # betrag

    $AmountLabel = New-Object system.windows.Forms.Label
    $AmountLabel.Text = "Betrag"
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

    $regularTaxLevelLabel = New-Object system.windows.Forms.Label
    $regularTaxLevelLabel.Text = "Steuersatz:"
    $regularTaxLevelLabel.AutoSize = $true
    $regularTaxLevelLabel.Width = 25
    $regularTaxLevelLabel.Height = 10
    $regularTaxLevelLabel.location = new-object system.drawing.point(20, 90)
    $regularTaxLevelLabel.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($regularTaxLevelLabel)

    $regularTaxLevelTextBox = New-Object system.windows.Forms.TextBox
    $regularTaxLevelTextBox.Text = "19 %"
    $regularTaxLevelTextBox.Name = 0.19
    $regularTaxLevelTextBox.Width = 100
    $regularTaxLevelTextBox.Height = 20
    $regularTaxLevelTextBox.location = new-object system.drawing.point(35, 120)
    $regularTaxLevelTextBox.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($regularTaxLevelTextBox)

    ################################################################
    # 7 %

    $reducedTaxLevelLabel = New-Object system.windows.Forms.Label
    $reducedTaxLevelLabel.Text = "Steuersatz:"
    $reducedTaxLevelLabel.AutoSize = $true
    $reducedTaxLevelLabel.Width = 25
    $reducedTaxLevelLabel.Height = 10
    $reducedTaxLevelLabel.location = new-object system.drawing.point(20, 160)
    $reducedTaxLevelLabel.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($reducedTaxLevelLabel)

    $reducedTaxLevelTextBox = New-Object system.windows.Forms.TextBox
    $reducedTaxLevelTextBox.Text = "7 %"
    $reducedTaxLevelTextBox.Name = 1.19
    $reducedTaxLevelTextBox.Width = 100
    $reducedTaxLevelTextBox.Height = 20
    $reducedTaxLevelTextBox.location = new-object system.drawing.point(35, 190)
    $reducedTaxLevelTextBox.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($reducedTaxLevelTextBox)

    # do the math thing

    $CalculateTaxRate_On_Click = {
        if ($AmountTextBox.Text -eq "") {
            $notification.text = "darf nicht leer sein!"
            $reducedTaxLevelResult.Text = ""
            $regularTaxLevelResult.Text = ""
        }
        elseif ((Test-Input -data $AmountTextBox.Text | Get-Member).TypeName -eq 'System.String') {
            $notification.text = (Test-Input -data $AmountTextBox.Text)
        }
        else { 
            $notification.text = ""   
            $reducedTaxLevelResult.Text = '{0:N2}' -f ([double]$reducedTaxLevelTextBox.Name * (Test-Input -data $AmountTextBox.Text))
            $regularTaxLevelResult.Text = '{0:N2}' -f ([double]$regularTaxLevelTextBox.Name * (Test-Input -data $AmountTextBox.Text))
        }

    }

    $CalculateTaxRate = New-Object system.windows.Forms.Button
    $CalculateTaxRate.Text = "berechnen"
    $CalculateTaxRate.Width = 150
    $CalculateTaxRate.Height = 25
    $CalculateTaxRate.location = new-object system.drawing.point(180, 50)
    $CalculateTaxRate.Font = "Microsoft Sans Serif,10"

    $CalculateTaxRate.Add_Click($CalculateTaxRate_On_Click)
    # evtl to do add enter taste


    $TaxRateCompute.controls.Add($CalculateTaxRate)

    # ergebnis

    $regularTaxLevelResult = New-Object system.windows.Forms.TextBox
    $regularTaxLevelResult.Width = 150
    $regularTaxLevelResult.Height = 20
    $regularTaxLevelResult.location = new-object system.drawing.point(180, 120)
    $regularTaxLevelResult.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($regularTaxLevelResult)

    $reducedTaxLevelResult = New-Object system.windows.Forms.TextBox
    $reducedTaxLevelResult.Width = 150
    $reducedTaxLevelResult.Height = 20
    $reducedTaxLevelResult.location = new-object system.drawing.point(180, 190)
    $reducedTaxLevelResult.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($reducedTaxLevelResult)

    $notification = New-Object system.windows.Forms.Label
    $notification.Width = 350
    $notification.Height = 20
    $notification.text = ""
    $notification.location = new-object system.drawing.point(62, 20)
    $notification.Font = "Microsoft Sans Serif,10"
    $TaxRateCompute.controls.Add($notification)


    [void]$TaxRateCompute.ShowDialog()
    $TaxRateCompute.Dispose()

}

New-ComputeTaxRateWindow