
# using the xmlreader (works)
$IN = 'C:\Users\Administrator\Desktop\se_opti4cast\alterations\opti4cast_alterations.xml'
$XmlReader = [system.Xml.XmlReader]::Create($IN) 

# # Parse the XML document.  
$XmlReader.Read()  

$XmlReader | gm
$XmlReader | measure
$XmlReader.HasLineInfo()
$XmlReader.HasLineInfo()
$XmlReader.AttributeCount
$XmlReader.MoveToNextAttribute()
$XmlReader.LineNumber
$XmlReader.EOF
$XmlReader.BaseURI
#######################################
"creating custom northern-lights format"

# set and show what there is
$env:XML = "C:\Users\Administrator\Desktop\se_opti4cast\alterations"
# Get-ChildItem -Path $env:XML

# read in  file as System.Xml.XmlDocument
$IN = [xml](Get-Content "$env:XML\opti4cast_alterations.xml")

# get the nodes
$filllevelRecords = $IN.DocumentElement.SelectNodes("//fillLevel").Count
'we got {0} customer nodes' -f $filllevelRecords





# Set the File Name
$OUT = "C:\Users\Administrator\Desktop\se_opti4cast\alterations\alteration_1.xml"
 
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
 
$xmlWriter.WriteStartElement('northern-lights')
  
# Write the Document
# it has 1347725 nodes
#$xmlWriter.WriteStartElement(("<fillLevel storage="010" timestamp="2005-01-20T05:59:59.000+01:00" level="352"/>"))
$xmlWriter.WriteRaw(('<fillLevel storage="010" timestamp="2005-01-20T05:59:59.000+01:00" level="352"/>').toString())

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

#<fillLevel storage="010" timestamp="2005-01-20T05:59:59.000+01:00" level="352"/>
#<fillLevel storage="010" timestamp="2005-01-20T05:59:59.000+01:00" level="352"/>
#<fillLevel storage="010" timestamp="2005-01-20T06:00:00.000+01:00" level="526"/>
#<fillLevel storage="010" timestamp="2005-03-22T05:59:59.000+01:00" level="111"/>
#<fillLevel storage="010" timestamp="2005-03-22T06:00:00.000+01:00" level="475"/>
#<fillLevel storage="010" timestamp="2006-01-27T05:59:59.000+01:00" level="0"/>