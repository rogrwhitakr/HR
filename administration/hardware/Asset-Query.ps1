function Get-LocalInventory {
    [CmdletBinding()]
    param(
        # Where to write the JS file. By default: .\<COMPUTERNAME>.js (script folder)
        [string]$OutputPath = (Join-Path $PSScriptRoot "$env:COMPUTERNAME.js"),

        # Do not create/write the JS file; only return the object/array
        [switch]$NoFile,

        # Also write the object to the pipeline (useful for inspection)
        [switch]$PassThru
    )

    $ErrorActionPreference = 'Stop'

    # Fallback if $PSScriptRoot is not available (e.g. ISE/interactive)
    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $OutputPath = Join-Path (Get-Location) "$env:COMPUTERNAME.js"
    }

    $server = $env:COMPUTERNAME
    $result = @()

    try {
        Write-Host "Working on local computer $server" -BackgroundColor DarkGreen

        # --- Base inventory (local only) ---
        $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Continue |
            Select-Object Manufacturer, Model, TotalPhysicalMemory

        $bios = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Continue |
            Select-Object SerialNumber, SMBIOSBIOSVersion

        $baseBoard = Get-CimInstance -ClassName Win32_BaseBoard -ErrorAction Continue |
            Select-Object Manufacturer, Product, SerialNumber, Version

        $operatingSystem = Get-CimInstance -ClassName CIM_OperatingSystem -ErrorAction Continue |
            Select-Object Caption, OSArchitecture, Version, BuildNumber, CSName, SystemDrive, LastBootUpTime

        # CPU
        $processor = Get-CimInstance -ClassName Win32_Processor -ErrorAction Continue |
            Select-Object Name, NumberOfCores, NumberOfEnabledCore, NumberOfLogicalProcessors, ProcessorId, PartNumber, MaxClockSpeed, AddressWidth

        # RAM modules
        $physicalMemory = Get-CimInstance -ClassName CIM_PhysicalMemory -ErrorAction Continue |
            Select-Object DeviceLocator, SerialNumber, Capacity,
                @{N = "Speed"; E = {
                    if ($null -ne $_.Speed -and [double]$_.Speed -ge 1e9) { "{0:N1} Gb/s" -f ($_.Speed / 1e9) }
                    elseif ($null -ne $_.Speed -and [double]$_.Speed -gt 0) { "{0:N0} Mb/s" -f ($_.Speed / 1e6) }
                    else { $null }
                }},
                PartNumber, Manufacturer

        # GPU
        $videoController = Get-CimInstance -ClassName Win32_VideoController -ErrorAction Continue |
            Select-Object Name, VideoProcessor, DriverVersion, AdapterRAM

        # Monitors
        $monitor = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID -ErrorAction Continue |
            Select-Object @{Label = 'ManufacturerName'; Expression = { ($_.ManufacturerName | ForEach-Object { [char]$_ }) -join "" } },
                          @{Label = 'ProductCodeID';  Expression = { ($_.ProductCodeID  | ForEach-Object { [char]$_ }) -join "" } },
                          @{Label = 'UserFriendlyName'; Expression = { ($_.UserFriendlyName | ForEach-Object { [char]$_ }) -join "" } },
                          @{Label = 'SerialNumberID'; Expression = { ($_.SerialNumberID | ForEach-Object { [char]$_ }) -join "" } },
                          YearOfManufacture, WeekOfManufacture

        # Disks
        $diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -ErrorAction Continue |
            Select-Object Model, SerialNumber, Size, FirmwareRevision, InterfaceType, Index

        # NICs (physical)
        $networkAdapter = Get-CimInstance -ClassName Win32_NetworkAdapter -ErrorAction Continue |
            Where-Object { $_.PhysicalAdapter -eq $true } |
            Select-Object Name, ProductName, DeviceID, Speed, AdapterType, InterfaceIndex, MACAddress

        # --- Current user details ---
        $id = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal  = [Security.Principal.WindowsPrincipal]$id
        $isElevated = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

        $sessionName = $env:SESSIONNAME
        $logonServer = $env:LOGONSERVER
        $userDomain  = $env:USERDOMAIN

        # Best-effort last interactive logon time
        $logonTime = $null
        try {
            $interactive = Get-CimInstance Win32_LogonSession -Filter "LogonType=2 OR LogonType=10" -ErrorAction Stop |
                Sort-Object StartTime -Descending | Select-Object -First 1
            if ($null -ne $interactive -and $null -ne $interactive.StartTime) {
                $logonTime = [Management.ManagementDateTimeConverter]::ToDateTime($interactive.StartTime)
            }
        } catch {}

        $currentUser = [pscustomobject]@{
            UserName     = $id.Name
            Sid          = $id.User.Value
            IsElevated   = $isElevated
            UserDomain   = $userDomain
            LogonServer  = $logonServer
            SessionName  = $sessionName
            ApproxLogon  = $logonTime
        }

        # --- Windows 11 Eligibility (local, best-effort) ---
        $os = Get-CimInstance -ClassName CIM_OperatingSystem -ErrorAction SilentlyContinue
        $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
        $cs  = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue

        # System drive size
        $sysDisk = $null
        try {
            if ($null -ne $os -and $null -ne $os.SystemDrive) {
                $sysDisk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter ("DeviceID='{0}'" -f $os.SystemDrive) -ErrorAction Stop
            }
        } catch {}

        # TPM (prefer Get-Tpm)
        $tpmPresent = $null; $tpmVersionOK = $null; $tpmReady = $null
        try {
            if (Get-Command Get-Tpm -ErrorAction SilentlyContinue) {
                $t = Get-Tpm
                if ($null -ne $t) {
                    $tpmPresent   = [bool]$t.TpmPresent
                    $tpmReady     = [bool]$t.TpmReady
                    # SpecVersion can be array; check for "2.0"
                    $tpmVersionOK = (($t.SpecVersion | Where-Object { $_ -match '^2\.0' }).Count -gt 0)
                }
            } else {
                $tw = Get-CimInstance -Namespace root\cimv2\security\microsofttpm -ClassName Win32_Tpm -ErrorAction Stop
                if ($null -ne $tw) {
                    $tpmPresent   = $true
                    $tpmVersionOK = ($tw.SpecVersion -match '2\.0')
                    $tpmReady     = [bool]$tw.IsEnabled_InitialValue
                }
            }
        } catch {}

        # Secure Boot / UEFI
        $secureBootEnabled = $null
        $uefi = $null
        try {
            if (Get-Command Confirm-SecureBootUEFI -ErrorAction SilentlyContinue) {
                $res = Confirm-SecureBootUEFI -ErrorAction Stop
                $secureBootEnabled = [bool]$res
                $uefi = $true
            } else {
                $sb = Get-CimInstance -Namespace root\Microsoft\Windows\SecureBoot -ClassName MSFT_SecureBoot -ErrorAction Stop
                if ($null -ne $sb) {
                    $uefi = $true
                    $secureBootEnabled = [bool]$sb.SecureBootEnabled
                }
            }
        } catch {
            if ($_.Exception.Message -match 'not supported on this platform') {
                $uefi = $false
                $secureBootEnabled = $false
            } elseif ($_.Exception.Message -match 'Access was denied') {
                $uefi = $null
                $secureBootEnabled = $null
            } else {
                $uefi = $null
                $secureBootEnabled = $null
            }
        }

        # Core requirement checks
        $totalRamBytes = $cs.TotalPhysicalMemory
        $ramOK = ($null -ne $totalRamBytes -and $totalRamBytes -ge 4GB)

        $storageOK = $false
        if ($null -ne $sysDisk -and $null -ne $sysDisk.Size) { $storageOK = ($sysDisk.Size -ge 64GB) }

        $cpuCoresOK = $null
        $cpuFrequencyOK = $null
        $os64 = $null
        try { if ($null -ne $cpu.NumberOfCores) { $cpuCoresOK = ($cpu.NumberOfCores -ge 2) } } catch {}
        try { if ($null -ne $cpu.MaxClockSpeed) { $cpuFrequencyOK = ($cpu.MaxClockSpeed -ge 1000) } } catch {} # MHz
        try { if ($null -ne $os.OSArchitecture) { $os64 = ($os.OSArchitecture -match '64') } } catch {}

        $eligibility = [pscustomobject]@{
            OS64Bit            = $os64
            CPUCoresOK         = $cpuCoresOK
            CPUFrequencyOK     = $cpuFrequencyOK
            RAMOK              = $ramOK
            StorageOK          = $storageOK
            TpmPresent         = $tpmPresent
            TpmVersionOK       = $tpmVersionOK
            TpmReady           = $tpmReady
            SecureBootEnabled  = $secureBootEnabled
            UEFI               = $uefi
            GraphicsWddm2      = $null   # left as null unless you want a dxdiag parse
            DirectX12          = $null
        }

        $failed = @()
        $undetermined = @()

        if ($eligibility.OS64Bit -eq $false) { $failed += 'OS 64-bit' }
        elseif ($null -eq $eligibility.OS64Bit) { $undetermined += 'OS Architecture' }

        if ($eligibility.CPUCoresOK -eq $false) { $failed += '>= 2 CPU cores' }
        elseif ($null -eq $eligibility.CPUCoresOK) { $undetermined += 'CPU cores' }

        if ($eligibility.CPUFrequencyOK -eq $false) { $failed += '>= 1 GHz CPU' }
        elseif ($null -eq $eligibility.CPUFrequencyOK) { $undetermined += 'CPU frequency' }

        if ($eligibility.RAMOK -eq $false) { $failed += '>= 4 GB RAM' }
        elseif ($null -eq $eligibility.RAMOK) { $undetermined += 'RAM' }

        if ($eligibility.StorageOK -eq $false) { $failed += '>= 64 GB system drive' }
        elseif ($null -eq $eligibility.StorageOK) { $undetermined += 'Storage' }

        # TPM
        if ($eligibility.TpmPresent -eq $false -or $eligibility.TpmVersionOK -eq $false -or $eligibility.TpmReady -eq $false) {
            $failed += 'TPM 2.0 (present & ready)'
        } elseif ($null -eq $eligibility.TpmPresent -or $null -eq $eligibility.TpmVersionOK -or $null -eq $eligibility.TpmReady) {
            $undetermined += 'TPM'
        }

        # Secure Boot + UEFI
        if ($eligibility.SecureBootEnabled -eq $false -or $eligibility.UEFI -eq $false) {
            $failed += 'Secure Boot enabled & UEFI'
        } elseif ($null -eq $eligibility.SecureBootEnabled -or $null -eq $eligibility.UEFI) {
            $undetermined += 'Secure Boot/UEFI'
        }

        $meetsCore = ($failed.Count -eq 0 -and $undetermined.Count -eq 0)

        $win11Eligibility = [pscustomobject]@{
            Summary = [pscustomobject]@{
                MeetsCoreRequirements = $meetsCore
                Failed                = $failed
                Undetermined          = $undetermined
            }
            Signals = $eligibility
        }

        # --- Final object ---
        $objInv = [pscustomobject]@{
            ComputerName    = $server
            ComputerSystem  = $computerSystem
            Bios            = $bios
            BaseBoard       = $baseBoard
            OperatingSystem = $operatingSystem
            Processor       = $processor
            PhysicalMemory  = $physicalMemory
            VideoController = $videoController
            Monitor         = $monitor
            DiskDrive       = $diskDrive
            NetworkAdapter  = $networkAdapter
            CurrentUser     = $currentUser
            Win11Eligibility= $win11Eligibility
        }

        $result += $objInv
    }
    catch {
        Write-Host "Local inventory failed: $($_.Exception.Message)" -BackgroundColor DarkRed
        throw
    }

    # --- Output handling: ALWAYS write a valid JS array with JSON inside ---
    if (-not $NoFile) {
        try {
            # Force an array even for a single item, and clean \u0000
            $json = @($result) | ConvertTo-Json -Depth 8
            $json = $json -replace '\\u0000',''

            $js = "var data = $json;"

            $dir = Split-Path -Path $OutputPath -Parent
            if ($dir -and -not (Test-Path $dir)) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
            }

            $js | Out-File -LiteralPath $OutputPath -Encoding UTF8
        } catch {
            Write-Warning "Failed to write JS file to '$OutputPath': $($_.Exception.Message)"
        }
    }

    if ($PassThru) {
        return $result
    }
}

# 1) Import the function (paste into your script or profile)
# 2) Run it with defaults:
Get-LocalInventory

# 3) Return the object (no file), then inspect it:
Get-LocalInventory -NoFile -PassThru | Format-List * -Force

# 4) Write custom output path:
# Get-LocalInventory -OutputPath "C:\Temp\hardware\data.js"
  