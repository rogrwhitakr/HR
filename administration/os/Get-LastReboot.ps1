#There are five event IDs that are reserved for power up, power down and uptime events.
# 1074 -> System has been shutdown by a process/user
# 6005 -> The Event log service was started
# 6006 -> The Event log service was stopped
# 6008 -> The previous system shutdown at time on date was unexpected
# 6013 -> The system uptime is number seconds

Get-WinEvent -FilterHashtable @{logname = 'System'; id = 1074} | Format-Table -wrap

Get-WinEvent -FilterHashtable @{logname = 'System'; id = 1074, 6005, 6006, 6008} -MaxEvents 6 | Format-Table -wrap