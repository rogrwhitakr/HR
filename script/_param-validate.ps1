[ValidateNotNullOrEmpty()]     
[ValidateScript( {Test-Path $_ })]
[ValidateScript( {Test-Path $_ -include *.vmdk})]