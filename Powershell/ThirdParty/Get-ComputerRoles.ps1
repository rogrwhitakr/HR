$strComputer = Read-Host "Enter Computer Name"
$objWMI = Get-WmiObject -Class win32_ComputerSystem -namespace "root\CIMV2" -computername $strComputer
Write-Host "Computer: $strComputer is a:"
switch ($objWMI.domainRole)
  {
  0 {Write-Host "Stand alone workstation"}
  1 {Write-Host "Member workstation"}
  2 {Write-Host "Stand alone server"}
  3 {Write-Host "Member server"}
  4 {Write-Host "Back-up domain controller"}
  5 {Write-Host "Primary domain controller"}
  default {Write-Host "The role can not be determined"}
  }