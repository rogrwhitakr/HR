
# using the xmlreader (works)
$IN = 'C:\Users\Administrator\Desktop\file\alterations\filealterations.xml'
$XmlReader = [system.Xml.XmlReader]::Create($IN) 

# # Parse the XML document.  
$XmlReader.Read()  
$XmlReader | Get-Member > .\ReaderWriterMethods.txt

$XmlReader.
#$IN.DocumentElement.SelectNodes("//customer") | Format-Xml | Out-File "$env:XML\customer.xml"
#$IN.DocumentElement.SelectNodes("//fillLevel") | Format-Xml | Out-File "$env:XML\fillLevel.xml"

#######################################
"creating custom northern-lights format"

# Set the File Name
$OUT = "C:\Users\Administrator\Desktop\file\singled_customers.xml"
 
# Create The Document
$XmlWriter = New-Object System.XMl.XmlTextWriter($OUT,$Null)

$XmlWriter | Get-Member >> .\ReaderWriterMethods.txt

$xmlWriter.Formatting = "Indented"
$xmlWriter.Indentation = "4"
#  
# Write the XML Decleration
$xmlWriter.WriteStartDocument()
#  
# Set the XSL
$XSLPropText = 'encoding="ISO-8859-1" standalone="yes"'
$xmlWriter.WriteProcessingInstruction("xml-stylesheet", $XSLPropText)
# Write Root Element
 
$xmlWriter.WriteStartElement('northern-lights tenantExtId="id"')
  
# Write the Document
$xmlWriter.WriteStartElement("customer")
$xmlWriter.WriteAttributeString("extId", '1')
$XmlWriter.writeE
$xmlWriter.WriteElementString("deliveryAddress")
$xmlWriter.WriteAttributeString("extId", '1')

$xmlWriter.WriteEndElement # <-- Closing Servers
  
# Write Close Tag for Root Element
$xmlWriter.WriteEndElement # <-- Closing RootElement
  
# End the XML Document
$xmlWriter.WriteEndDocument()
  
# Finish The Document
$xmlWriter.Finalize
$xmlWriter.Flush
$xmlWriter.Close()







# $XSL = New-Object System.Xml.Xsl.XslCompiledTransform

