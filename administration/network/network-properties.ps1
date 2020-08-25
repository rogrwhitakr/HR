
#IPCONFIG
Get-NetIPConfiguration
Get-NetIPAddress | Sort-Object InterfaceIndex | format-table InterfaceIndex, InterfaceAlias, AddressFamily, IPAddress, PrefixLength -Autosize
Get-NetIPAddress | Where-Object AddressFamily -eq IPv4 | format-table –AutoSize
Get-NetAdapter Wi-Fi | Get-NetIPAddress | format-table -AutoSize

#PING
Test-NetConnection www.microsoft.com
Test-NetConnection -ComputerName www.microsoft.com -InformationLevel Detailed
Test-NetConnection -ComputerName www.microsoft.com | Select-Object -ExpandProperty PingReplyDetails | format-table Address, Status, RoundTripTime
1..10 | Where-Object { Test-NetConnection -ComputerName www.microsoft.com -RemotePort 80 } | format-table -AutoSize

#NSLOOKUP
Resolve-DnsName www.microsoft.com
Resolve-DnsName microsoft.com -type SOA
Resolve-DnsName microsoft.com -Server 8.8.8.8 –Type A

#ROUTE
Get-NetRoute -Protocol Local -DestinationPrefix 192.168*
Get-NetAdapter Wi-Fi | Get-NetRoute

#TRACERT
Test-NetConnection www.microsoft.com –TraceRoute
Test-NetConnection outlook.com -TraceRoute | Select-Object -ExpandProperty TraceRoute | Where-Object { Resolve-DnsName $_ -type PTR -ErrorAction SilentlyContinue }

#NETSTAT
Get-NetTCPConnection | Group-Object State, RemotePort | Sort-Object Count | format-table Count, Name –Autosize
Get-NetTCPConnection | Where-Object State -eq Established | format-table –Autosize
Get-NetTCPConnection | Where-Object State -eq Established | Where-Object RemoteAddress -notlike 127* | Where-Object { $_; Resolve-DnsName $_.RemoteAddress -type PTR -ErrorAction SilentlyContinue }

#check if remote port is connected to us

$ports = @(52222,22)
foreach ($port in $ports) {

   Get-NetTCPConnection | Where-Object {$_.RemotePort -eq $port} | format-table –Autosize 

}

############################################################################
### Finding IP Address Assigned by DHCP
############################################################################

Get-NetIPAddress | Where-Object PrefixOrigin -eq dhcp | Select-Object-Object -ExpandProperty IPAddress 

# get FQDN
[System.Net.Dns] | Get-Member -Static

# dont work , ping works though
Get-NetTCPConnection -RemoteAddress 138.201.14.51
