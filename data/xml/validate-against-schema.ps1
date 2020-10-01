 # i have little recollection if this works at all


Function Test-Xml{ 
    param(     
        [Parameter( 
            Mandatory = $true, 
            Position = 0, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true)] 
        [xml]$xml, 
        [Parameter( 
            Mandatory = $true, 
            Position = 1, 
            ValueFromPipeline = $false)] 
        [string]$schema 
        ) 
 
    #<c>Declare the array to hold our error objects</c> 
    $validationerrors = @() 
         
    #<c>Check to see if we have defined our namespace cache variable, 
    #and create it if it doesnt exist. We do this in case we want to make 
    #lots and lots of calls to this function, to save on excessive file IO.</c> 
    if (-not $schemas){ ${GLOBAL:schemas} = @{} } 
     
    #<c>Check to see if the namespace is already in the cache,if not then add it</c> 
    #<choose> 
    #<if test="Is schema in cache"> 
    if (-not $schemas[$schema]) { 
        #<c>Read in the schema file</c> 
        [xml]$xmlschema = Get-Content $schema 
        #<c>Extract the targetNamespace from the schema</c> 
        $namespace = $xmlschema.get_DocumentElement().targetNamespace 
        #<c>Add the schema/namespace entry to the global hashtable</c> 
        $schemas.Add($schema,$namespace) 
        #</if> 
    } else { 
        #<else> 
        #<c>Pull the namespace from the schema cache</c> 
        $namespace = $schemas[$schema] 
    } 
    #</else><choose> 
 
    #<c>Define the script block that will act as the validation event handler</c> 
$code = @' 
    param($sender,$a) 
    $ex = $a.Exception 
    #<c>Trim out the useless,irrelevant parts of the message</c> 
    $msg = $ex.Message -replace " in namespace 'http.*?'","" 
    #<c>Create the custom error object using a hashtable</c> 
    $properties = @{LineNumber=$ex.LineNumber; LinePosition=$ex.LinePosition; Message=$msg} 
    $o = New-Object PSObject -Property $properties 
    #<c>Add the object to the $validationerrors array</c> 
    $validationerrors += $o 
'@ 
    #<c>Convert the code block to as ScriptBlock</c> 
    $validationEventHandler = [scriptblock]::Create($code) 
     
    #<c>Create a new XmlReaderSettings object</c> 
    $rs = new-object System.Xml.XmlreaderSettings 
    #<c>Load the schema into the XmlReaderSettings object</c> 
    [Void]$rs.schemas.add($namespace,(new-object System.Xml.xmltextreader($schema))) 
    #<c>Instruct the XmlReaderSettings object to use Schema validation</c> 
    $rs.validationtype = "Schema" 
    $rs.ConformanceLevel = "Auto" 
    #<c>Add the scriptblock as the ValidationEventHandler</c> 
    $rs.add_ValidationEventHandler($validationEventHandler) 
     
    #<c>Create a temporary file and save the Xml into it</c> 
    $xmlfile = [System.IO.Path]::GetTempFileName() 
    $xml.Save($xmlfile) 
     
    #<c>Create the XmlReader object using the settings defined previously</c> 
    $reader = [System.Xml.XmlReader]::Create($xmlfile,$rs) 
     
    #<c>Temporarily set the ErrorActionPreference to SilentlyContinue, 
    #as we want to use our validation event handler to handle errors</c> 
    $previousErrorActionPreference = $ErrorActionPreference 
    $ErrorActionPreference = "SilentlyContinue" 
     
    #<c>Read the Xml using the XmlReader</c> 
    while ($reader.read()) {$null} 
    #<c>Close the reader</c> 
    $reader.close() 
     
    #<c>Delete the temporary file</c> 
    Remove-Item $xmlfile 
     
    #<c>Reset the ErrorActionPreference back to the previous value</c> 
    $ErrorActionPreference = $previousErrorActionPreference  
     
    #<c>Return the array of validation errors</c> 
    return $validationerrors 
} 
#</body></function> 
 
################################################################ 
## Start script 
################################################################ 
 
#<example> 
$schema = "C:\Desktop\api.xsd" 
[xml]$xml = Get-ChildItem 'C:\Desktop\operative.xml' 
Validate-Xml $xml $schema 
#</example> 
 
################################################################

function Test-Xml {
param(
    $InputObject = $null,
    $Namespace = 'northern-lights',
    $SchemaFile = $null
)

BEGIN {
    $failCount = 0
    $failureMessages = ""
    $fileName = ""
}

PROCESS {
    if ($InputObject -and $_) {
        throw 'ParameterBinderStrings\AmbiguousParameterSet'
        break
    } elseif ($InputObject) {
        $InputObject
    } elseif ($_) {
        $fileName = $_.FullName
        $readerSettings = New-Object -TypeName System.Xml.XmlReaderSettings
        $readerSettings.ValidationType = [System.Xml.ValidationType]::Schema
        $readerSettings.ValidationFlags = [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessInlineSchema -bor
            [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation -bor 
            [System.Xml.Schema.XmlSchemaValidationFlags]::ReportValidationWarnings
        $readerSettings.Schemas.Add($Namespace, $SchemaFile) | Out-Null
        $readerSettings.add_ValidationEventHandler(
        {
            $failureMessages = $failureMessages + [System.Environment]::NewLine + $fileName + " - " + $_.Message
            $failCount = $failCount + 1
        });
        $reader = [System.Xml.XmlReader]::Create($_, $readerSettings)
        while ($reader.Read()) { }
        $reader.Close()
    } else {
        throw 'ParameterBinderStrings\InputObjectNotBound'
    }
}
}
 
################################################################ 
## Start script 
################################################################

Set-Location "$env:USERPROFILE\Desktop"

$source = "http://northern-lights.one/api.xsd"
$xsd = Join-Path -Path (Get-Location) -ChildPath "api.xsd"
 
Invoke-WebRequest $source -OutFile $xsd


$schema = "C:\Desktop\api.xsd" 
$xmlFileName = Get-ChildItem 'C:\operative.xml' 

# Check if the provided file exists
if((Test-Path -Path $xmlFileName) -eq $false) {
    Write-Host "XML validation not possible since no XML file found at '$xmlFileName'"
    exit 2
}

# Get the file
$XmlFile = Get-Item($xmlFileName)

# Keep count of how many errors there are in the XML file
$script:errorCount = 0

# Perform the XSD Validation
    $readerSettings = New-Object -TypeName System.Xml.XmlReaderSettings
    $readerSettings.ValidationType = [System.Xml.ValidationType]::Schema
    $readerSettings.ValidationFlags = [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessInlineSchema -bor [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation
    $readerSettings.add_ValidationEventHandler(
        {
            # Triggered each time an error is found in the XML file
            Write-Host $("`nError found in XML: " + $_.Message + "`n") -ForegroundColor Red
            $script:errorCount++
        }
    );

    $reader = [System.Xml.XmlReader]::Create($XmlFile.FullName, $readerSettings)
    
    while ($reader.Read()) { }
    $reader.Close()

# Verify the results of the XSD validation
if($script:errorCount -gt 0)
{
    # XML is NOT valid
    Write-Output "nah"
}
else
{
    # XML is valid
    Write-Output "JA"

}