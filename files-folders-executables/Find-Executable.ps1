function Find-Executable {
    param (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true)] 
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9].*?\.exe$')]
        $Executable
    )

    try {

        # 1st we look on the path
        # if exe is there, awesome:
        if (get-command $Executable -ErrorAction SilentlyContinue) {
            Write-Verbose "Found executable on environment paths (env:)"
            return [System.IO.FileInfo] (get-command $Executable).Definition 
        }
        else {
            # if not, we search default installation paths (assuming we are not using portables)
            # we first look in 64 bit program files
            $exec = Get-ChildItem -Path ${env:ProgramFiles} -Name $Executable -Recurse | Select-Object -First 1

            # if it is not empty, we assume we found it and prepend the full path
            If ($exec) {
                $exec = Join-Path -Path ${env:ProgramFiles} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles} -Name $Executable -Recurse | Select-Object -First 1)
                Write-Verbose "found executable (64-bit): $exec"
                return [System.IO.FileInfo] $exec
            }
            # now we look in 32 bit programs
            else {
                $exec = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name $Executable -Recurse | Select-Object -First 1
                If ($exec) {
                    $exec = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath (Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name $Executable -Recurse | Select-Object -First 1)
                    Write-Verbose "found executable (32-bit): $exec"
                    return [System.IO.FileInfo] $exec
                }
                else {
                    Write-Warning "executable $executable not found!"
                    break
                }
            }
        }
    }
    catch {
        Write-Error "$_"
    }
}

 find-executable -executable 'mysql.exe' -Verbose 
 find-executable -executable 'javaws.exe' -Verbose 
 find-executable -executable 'notepad++.exe' -Verbose
 find-executable -executable 'pg_dumpall.exe' -Verbose
 find-executable -executable '7z.exe' -Verbose
 # this one does not work because the executable is in "C:\Tools\something\else".
 # how to handle?
 find-executable -executable 'vboxmanage.exe' -Verbose
 find-executable -executable 'mtputty.exe' -Verbose