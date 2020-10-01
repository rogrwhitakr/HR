

# set and show what there is
$env:XML = "C:\Users\Administrator\Desktop\se_file"
# Get-ChildItem -Path $env:XML

# read in  file as System.Xml.XmlDocument
$IN = [xml](Get-Content "$env:XML\file_TEST-Customers.xml")

# create a file to save to :: exists aready...
Remove-Item -Path "$env:XML\OUT.xml" -ErrorAction SilentlyContinue
Copy-Item -Path "$env:XML\_template.xml" -Destination "$env:XML\OUT.xml"
$OUT = [xml](Get-Content "$env:XML\OUT.xml")

# get a template customer to fill
$CUSTOMER_ADD = [xml](Get-Content "$env:XML\_customer-template.xml")
$customer = $CUSTOMER_ADD.DocumentElement.SelectSingleNode("//customer")

# get the nodes
$CustomerRecords = $IN.DocumentElement.SelectNodes("//customer").Count
'we got {0} customer nodes' -f $CustomerRecords
$DelAddrRecords = $IN.DocumentElement.SelectNodes("//deliveryAddress").Count
'we got {0} customer nodes' -f $DelAddrRecords

Read-Host -Prompt "start?"

for ($i = 1; $i -le $DelAddrRecords; $i++) {
    '$i is @ {0}' -f $i
    $deliveryAddress = $IN.DocumentElement.SelectSingleNode("//deliveryAddress[$i]")
    $OUT | Get-Member
    $OUT.DocumentElement.AppendChild($OUT.ImportNode($customer, $true))
    $OUT.DocumentElement.AppendChild($OUT.ImportNode($deliveryAddress, $true))
    $OUT.save("$env:XML\OUT.xml")       
}
System.Xml.XmlDocument GetEnumerator
# Set the File Name
$OUT.save("$env:XML\OUT.xml")

$CUSTOMER_ADD = [xml](Get-Content "$env:XML\_customer-template.xml")
