
# The sample code
function New-HashTable {

    $Items = @{
        'import' = {'csv_import_legacy', 'csv_import', 'import'}
        'log'    = 'log';
        'export' = 'export';
    }

    if ($Items.export = 'export') {
        'export'
    }
    elseif ($Items.import = 'import') {
        'import'
    }
    else {
        'somesin else'
    }
}

Describe 'New-HashTable' {
    It 'gets the import' {

        $assertion =  New-HashTable
        $assertion | Should -be    'import'
    }

}
