function g {

	Begin {

		$query='https://www.google.com/search?q='

	}

	Process
	{
		if ($args.Count -eq 0)
		{
            break
		}

		Write-Host $args.Count, "Arguments detected"
		Write-Host "Parsing out Arguments: $args"
		for ($i=0;$i -le $args.Count;$i++){
			$args | % {"Arg $i `t $_ `t Length `t" + $_.Length, " characters"} | Out-Null
        }
		$args | % {$query = $query + "$_+"}
	}

	End

	{
		$url = $query.Substring(0,$query.Length-1)
		Write-Host "Search URL: $url `nInvoking..."
		start "$url"
	}
}