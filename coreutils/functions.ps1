
# get available parameter attributes and types stuff
# If you ever wondered what your choices are with these attributes, here is how. All you need to know is the true name of the type that represents an attribute. PowerShell’s own attributes all reside in the System.Management.Automation namespace. Here are the two most commonly used:
#
# [Parameter()] = [System.Management.Automation.ParameterAttribute] 
# [CmdletBinding()] = [System.Management.Automation.CmdletBindingAttribute]

[System.Management.Automation.ParameterAttribute]::new() |  Get-Member -MemberType *Property | Select-Object -ExpandProperty Name

# hidden parameters
function Test-Something {
   param
   (
       [string]
       [Parameter(Mandatory)]
       $Name,
       
       [Parameter(DontShow)]
       [Switch]
       $Internal
   )
} 