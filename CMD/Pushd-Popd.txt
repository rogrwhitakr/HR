@echo off

::create a temporary drive letter mapped to your UNC root location
::and effectively CD to that location

pushd \\REESE\Users\Ben\Desktop

::do your work

hier ausführen

::remove the temporary drive letter and return to your original location

popd

wenn das Script nicht voll ausgeführt wird, legt system32 einen weiteren Ordner in der Struktur an!
