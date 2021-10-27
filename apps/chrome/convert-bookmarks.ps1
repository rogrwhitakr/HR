
$bookmarks = "/Google/Chrome/User Data/Default/bookmarks"
$date = Get-Date -Format 'yyyy-MM-dd'

if ($path = Join-Path -Path $env:LOCALAPPDATA -ChildPath $bookmarks) {
    $jsonData = ConvertFrom-Json -InputObject (get-content -Path $path -raw) -Depth 10
    $convData = $jsonData | ConvertTo-Html -Fragment
    $convData | Out-File -FilePath ("./bookmark_" + $date + ".html")
}
else {
    Write-Warning "it dont werk!"
}


# das problem ist die arbiträre tiefe des json dokuments
# wenn ich weiß, welche elemente ich benötige, kann ich das festgelegt scripten
# ich also element child[0].child[0].child[0] benötige, und nicht tiefer und nicht flacher...
# aber nicht dynamisch...
# das erscheint mir starr und unflexibel, aber so ginge es
# nur ist in diesem fall es einfacher, die paar klicks in der oberfläche zu machen, regelmäßig.
# reminder setzen! 