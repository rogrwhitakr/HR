
# get the pyhiscal disk properties
# health status
# disk type
# connector / bus type

Get-PhysicalDisk | select-object *

# Im Fall eines Defekts, der einen Austausch der Disk nötig macht, reicht diese Information alleine jedoch kaum, um sie zu lokalisieren. 
# Stattdessen kann man beim betroffenen Laufwerk die LED aufleuchten lassen. Diese Aufgabe übernimmt Enable-PhysicalDiskIdentification:

Get-PhysicalDisk | Where-Object {$_.HealthStatus -ne "healthy"} | Enable-PhysicalDiskIdentification

# Get-PhysicalDisk kennt PowerShell noch das Cmdlet Get-Disk. 
# Während das erste die Laufwerke aus der Sicht des Storage-Subsystems betrachtet, sieht sie Get-Disk aus der Perspektive des Betriebs­systems

Get-Disk

Get-Volume