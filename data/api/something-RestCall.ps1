$URI = "/catalog-service/api/consumer/resourceViews/?withExtendedData=$($WithExtendedData)&withOperations=$($WithOperations)&managedOnly=$($ManagedOnly)&`$orderby=name asc&limit=$($Limit)&page=$($page)&`$filter=resourceType/id eq 'Infrastructure.Machine' or resourceType/id eq 'Infrastructure.Virtual' or resourceType/id eq 'Infrastructure.Cloud' or resourceType/id eq 'Infrastructure.Physical'"

$EscapedURI = [uri]::EscapeUriString($URI)

$Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference