#requires -version 5.1

param(
    [String]
    [Parameter( Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "ConfigFile for OPTITOOL GeoserverPorts")] 
    [ValidateScript( { Test-Path $_ -include *.psd1 })]
    $ConfigurationFile
)

if (Test-Path $ConfigurationFile -PathType Leaf) {
    Write-Verbose -Message "using configuration file $ConfigurationFile"
    $config = Import-PowerShellDataFile -Path $ConfigurationFile
}
else {
    Write-Verbose -Message "using default configuration"
    $config = @{
        'geo' = @{
            'Endpoint' = @{
                'proxy' = 'ha-geo.ot-hosting.de'
                'oldproxy' = 'ha-01.ot-hosting.de'
                'direct'= 'geo-osm-01.ot-hosting.de'
            }
            'nonSSL'   = @{
                'Monit'               = '2812'
                'Graphhopper'         = '8989'
                'LegacyRoutingserver' = '13042'
                'Nominatim'           = '8080'
                'Photon'              = '2322'
                'Tileserver'          = '8483'
                'Webserver'           = '80'
            }	
            'SSL'      = @{
                'Monit'               = '2813'
                'Graphhopper'         = '8990'	
                'LegacyRoutingserver' = '13042'
                'Nominatim'           = '8081'
                'Photon'              = '2323'
                'Tileserver'          = '8484'
                'Webserver'           = '443'
            }
        }
    }
}

$result = $config.geo.Endpoint.Keys | ForEach-Object {
    $endpoint = $config.geo.Endpoint.Item($_)
    $config.geo.SSL.Keys | foreach-object {
        Test-NetConnection -ComputerName $endpoint -RemotePort $config.geo.SSL.Item($_) -WarningAction SilentlyContinue -InformationLevel Detailednet
    }
    $config.geo.nonSSL.Keys | foreach-object {
        Test-NetConnection -ComputerName $endpoint -RemotePort $config.geo.nonSSL.Item($_) -WarningAction SilentlyContinue -InformationLevel Detailed
    }
        
}

$result | Format-Table -AutoSize -Property ComputerName, RemoteAddress, RemotePort, PingSucceeded, TcpTestSucceeded
$result | Out-File 'geoserver-port-results.txt'