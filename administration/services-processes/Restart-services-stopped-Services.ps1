# restart services that zabbix complains about b/c
# - automatic
# - yet stopped

get-service | where-object { $_.status -eq 'stopped' -and $_.StartType -eq 'Automatic'} | restart-service
