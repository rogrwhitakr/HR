# take an object...
$process = Get-Process -id $pid 
 
# ...and turn it into a hash table
$hashtable = $process | ForEach-Object {
 
 $object = $_
 
 # determine the property names in this object and create a
 # sorted list
 $columns = $_ | 
   Get-Member -MemberType *Property | 
   Select-Object -ExpandProperty Name |
   Sort-Object
 
 # create an empty hash table
 $hashtable = @{}
 
 # take all properties, and add keys to the hash table for each property
 $columns | ForEach-Object {
   # exclude empty properties
   if (![String]::IsNullOrEmpty($object.$_ ))
   {
     # add a key (property) to the hash table with the
     # property value
     $hashtable.$_ = $object.$_
   }
 }
 $hashtable
} 
 
 
$hashtable | Out-GridView