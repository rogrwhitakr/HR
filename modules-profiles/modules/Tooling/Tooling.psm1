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

Function Use-7ZipCompression {

    param (

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = "Compression Method")] 
        [ValidateSet("Add", "Update", "Extract", "Delete", "Test")]     
        $Method,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1, HelpMessage = "File/Directory to compress OR extract to")]
        [ValidateScript( {Test-Path $_ })]
        $Path,

        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 2)] 
        $Archive
    )

    BEGIN {
        try {
            $tool = find-executable -executable '7z.exe' -Verbose
            Write-Verbose "$Method files from/to $archive using 7zip"
        }

        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Verbose "An Error occurred. Please assign the Path to the Executable 7zip."
            Write-Error $ErrorMessage
        }
    }

    PROCESS {
        switch ($Method) { 
            Add {
                Start-Process -FilePath $tool -ArgumentList 'a', '-mx9', '-scsUTF-8', $archive.ToString(), $Path
            } 
            Delete {
                Start-Process -FilePath $tool -ArgumentList 'd', '-mx9', '-scsUTF-8', $archive, $Path
            } 
            Extract {
                Start-Process -FilePath $tool -ArgumentList 'x', '-mx9', '-scsUTF-8 ', $archive, '-o$Path', '-y' -WindowStyle minimized
            } 
            Test {
                Start-Process -FilePath $tool -ArgumentList 't', '-mx9', '-scsUTF-8 ', $archive
            } 
            Update {
                Start-Process -FilePath $tool -ArgumentList 'u', '-mx9', '-scsUTF-8', $archive, $Path
            } 
            default {
                Write-Error "No method selected."
            }
        }
    }
}

function g {
    Begin {
        $query = 'https://www.google.com/search?q='
    }

    Process {
        if ($args.Count -eq 0) {
            break
        }

        # Write-Verbose $args.Count, "Arguments detected"
        # Write-Verbose "Parsing out Arguments: $args"
        for ($i = 0; $i -le $args.Count; $i++) {
            $args | ForEach-Object {"Arg $i `t $_ `t Length `t" + $_.Length, " characters"} | Out-Null
        }
        $args | ForEach-Object {$query = $query + "$_+"}
    }
    End {
        $url = $query.Substring(0, $query.Length - 1)
        Write-Host "Search URL: $url `nInvoking..."
        Start-Process "$url"
    }
}

function att {

    while ($true) {
        $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('  ')
        Start-Sleep -Seconds 180
    }
}

function Get-CurrentCalendarWeek {
    $currentDate = Get-Date
    $calendarWeek = [System.Globalization.CultureInfo]::CurrentCulture.Calendar.GetWeekOfYear(
        $currentDate,
        [System.Globalization.CalendarWeekRule]::FirstFourDayWeek,
        [System.DayOfWeek]::Monday
    )
    return "KW" + $calendarWeek + "_quarantine-remediation" | clip
}


function Get-MSIProductInfo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$msiPath
    )

    if (-not (Test-Path $msiPath)) {
        Write-Error "MSI file not found at path: $msiPath"
        return
    }

    try {
        $installer = New-Object -ComObject WindowsInstaller.Installer
        $database = $installer.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $installer, @($msiPath, 0))
        $view = $database.OpenView("SELECT * FROM Property")
        $view.Execute()
        $record = $view.Fetch()
        $properties = @{}

        while ($record) {
            $property = $record.StringData(1)
            $value = $record.StringData(2)
            if ($property -eq "ProductCode" -or $property -eq "ProductVersion") {
                $properties[$property] = $value
            }
            $record = $view.Fetch()
        }

        return $properties
    } catch {
        Write-Error "Failed to read MSI file: $_"
    }
}

export-modulemember -function Get-MSIProductInfo
export-modulemember -function g
export-modulemember -function Find-Executable
export-modulemember -function Use-7ZipCompression
export-modulemember -function att
export-modulemember -function Get-CurrentCalendarWeek
