
# dc to dc test connection
Test-NetConnection -ComputerName srv-dc1.see.int -Port 445
$dc = 'srv-dc1.see.int'
$ports = 53, 88, 135, 389, 445, 464, 636, 3268, 3269,9389
foreach ($p in $ports) {
    $r = Test-NetConnection -ComputerName $dc -Port $p -WarningAction SilentlyContinue
    '{0,5} : {1}' -f $p, $r.TcpTestSucceeded
}