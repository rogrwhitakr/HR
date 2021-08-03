@echo on

ipconfig | find /i "Drahtlos-LAN-Adapter LAN-Verbindung" && set interface=tru

echo %interface%

set iface=Drahtlos-LAN-Adapter

ipconfig /all |  find /i "%iface%" && set exist=true

echo %exist%

set port=:443

netstat -anop TCP | find /i "%port%"



pause