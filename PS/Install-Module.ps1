# place script in
# $home\Documents\WindowsPowerShell\Modules\<Module Folder>\<Module Files>
#
# the other paths work also
($env:PSModulePath).Replace(";","`n")

#\---Modules
#    +---Use-7ZipCompresson
#        +---Use-7ZipCompresson.psm1

Import-Module -Name Tooling -Verbose 