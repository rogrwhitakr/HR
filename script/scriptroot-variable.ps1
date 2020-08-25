
$PSScriptRoot

'location of one directory down, one over:'

$leaf = Split-Path -Leaf $PSScriptRoot -Resolve
$parent = Split-Path -Parent $PSScriptRoot -Resolve

'get one down: {0}' -f $parent

# this may not be the best way though, but it works. need to keep track of the levels
'get two down: {0}' -f (Split-Path -Parent $parent)