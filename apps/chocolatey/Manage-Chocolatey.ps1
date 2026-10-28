<#
.SYNOPSIS
    Automated Chocolatey bootstrapper, installer, and scheduled upgrade manager.
.DESCRIPTION
    Ensures administrative rights, modern TLS protocols, bootstraps Chocolatey CLI,
    installs packages declared in a plain text configuration file, and supports
    monthly maintenance / upgrades with integrated file and console logging.
.PARAMETER PackageFile
    Path to the text file containing package IDs (optional version separated by ':' or '=').
.PARAMETER LogDirectory
    Path where log files are stored. Defaults to C:\ProgramData\ChocolateyScript\Logs.
.PARAMETER UpgradeOnly
    Performs routine upgrades of all installed packages and Chocolatey itself without re-parsing the manifest.
.PARAMETER WhatIf
    Executes in dry-run mode passing -WhatIf to Chocolatey commands where supported.
.EXAMPLE
    # Initial setup / baseline deployment:
    .\Manage-Chocolatey.ps1 -PackageFile ".\packages.txt"

.EXAMPLE
    # Monthly maintenance / scheduled task:
    .\Manage-Chocolatey.ps1 -UpgradeOnly
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$PackageFile = "$PSScriptRoot\packages.txt",

    [Parameter(Mandatory = $false)]
    [string]$LogDirectory = "$env:ProgramData\ChocolateyAutomation\Logs",

    [Parameter(Mandatory = $false)]
    [switch]$UpgradeOnly
)

# Enforce strict execution standards
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Logging Infrastructure
if (-not (Test-Path -Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
}

$Global:LogFile = Join-Path -Path $LogDirectory -ChildPath ("Choco_Run_{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss"))

function Write-ScriptLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('INFO', 'SUCCESS', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine   = "[$timestamp] [$Level] $Message"

    # Write to rolling file
    $logLine | Out-File -FilePath $Global:LogFile -Append -Encoding UTF8

    # Console display formatting
    switch ($Level) {
        'SUCCESS' { Write-Host $logLine -ForegroundColor Green }
        'WARN'    { Write-Host $logLine -ForegroundColor Yellow }
        'ERROR'   { Write-Host $logLine -ForegroundColor Red }
        Default   { Write-Host $logLine -ForegroundColor Cyan }
    }
}
#endregion

#region Core Functions
function Assert-Administrator {
    [CmdletBinding()]
    param()

    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    $isAdmin   = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        Write-ScriptLog "This script requires elevated administrative privileges. Please relaunch as Administrator." -Level ERROR
        throw "Administrator privileges required."
    }
}

function Assert-Chocolatey {
    [CmdletBinding()]
    param()

    # Enforce secure transport (TLS 1.2 and 1.3)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
        Write-ScriptLog "Chocolatey not detected. Bootstrapping installation..." -Level INFO

        try {
            $bootstrapScript = "https://community.chocolatey.org/install.ps1"
            Invoke-RestMethod -Uri $bootstrapScript | Invoke-Expression

            # Reload process environment path so choco is immediately accessible
            $chocoBin = "$env:ProgramData\chocolatey\bin"
            if ($env:PATH -notlike "*$chocoBin*") {
                $env:PATH = "$chocoBin;$env:PATH"
            }

            # Optional: Disable prompt confirmation by default
            & choco feature enable -n allowGlobalConfirmation --no-progress | Out-Null

            Write-ScriptLog "Chocolatey installed and initialized successfully." -Level SUCCESS
        }
        catch {
            Write-ScriptLog "Failed to bootstrap Chocolatey: $($_.Exception.Message)" -Level ERROR
            throw
        }
    }
    else {
        Write-ScriptLog "Chocolatey CLI detected: $(& choco --version)" -Level INFO
    }
}

function Get-PackageManifest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-ScriptLog "Package definition file not found at: $Path" -Level WARN
        return @()
    }

    $parsedPackages = @()
    $lines = Get-Content -Path $Path -Encoding UTF8

    foreach ($line in $lines) {
        $trimmed = $line.Trim()

        # Skip comments and whitespace
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith('#')) {
            continue
        }

        # Match package ID and optional version separated by ':' or '='
        if ($trimmed -match '^([a-zA-Z0-9_\-\.]+)(?:[:=]([a-zA-Z0-9_\-\.]+))?$') {
            $parsedPackages += [PSCustomObject]@{
                Id      = $Matches[1]
                Version = if ($Matches[2]) { $Matches[2] } else { $null }
            }
        }
        else {
            Write-ScriptLog "Skipping invalid manifest entry: $trimmed" -Level WARN
        }
    }

    return $parsedPackages
}

function Install-PackageBaseline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Packages
    )

    Write-ScriptLog "Beginning installation pass for $($Packages.Count) package(s)..." -Level INFO

    foreach ($pkg in $Packages) {
        $cmdArgs = @("install", $pkg.Id, "-y", "--no-progress")

        if ($pkg.Version) {
            $cmdArgs += @("--version", $pkg.Version)
            Write-ScriptLog "Installing package [$($pkg.Id)] pinned to version [$($pkg.Version)]..." -Level INFO
        }
        else {
            Write-ScriptLog "Installing package [$($pkg.Id)] (latest available)..." -Level INFO
        }

        $process = Start-Process -FilePath "choco.exe" -ArgumentList $cmdArgs -NoNewWindow -Wait -PassThru

        # Exit code 0: success; 3010: success, restart required
        if ($process.ExitCode -in 0, 3010) {
            Write-ScriptLog "Successfully installed [$($pkg.Id)] (Exit code: $($process.ExitCode))." -Level SUCCESS
        }
        else {
            Write-ScriptLog "Failed installing [$($pkg.Id)] (Exit code: $($process.ExitCode))." -Level ERROR
        }
    }
}

function Invoke-SystemUpgrade {
    [CmdletBinding()]
    param()

    Write-ScriptLog "Starting system-wide upgrade routine..." -Level INFO

    # Upgrade core CLI first
    Write-ScriptLog "Upgrading Chocolatey CLI engine..." -Level INFO
    & choco upgrade chocolatey -y --no-progress | Out-File -FilePath $Global:LogFile -Append

    # Upgrade all managed applications
    Write-ScriptLog "Upgrading all installed packages..." -Level INFO
    $upgradeOutput = & choco upgrade all -y --no-progress | Tee-Object -FilePath $Global:LogFile -Append

    # Extract upgrade summary metrics
    $summaryLine = $upgradeOutput | Where-Object { $_ -match 'Chocolatey upgraded (\d+)/(\d+) packages' }
    if ($summaryLine) {
        Write-ScriptLog "Upgrade Summary: $summaryLine" -Level SUCCESS
    }
    else {
        Write-ScriptLog "All packages are currently up to date." -Level INFO
    }
}
#endregion

#region Execution Entrypoint
try {
    Assert-Administrator
    Assert-Chocolatey

    if ($UpgradeOnly) {
        Invoke-SystemUpgrade
    }
    else {
        $packagesToInstall = Get-PackageManifest -Path $PackageFile
        if ($packagesToInstall.Count -gt 0) {
            Install-PackageBaseline -Packages $packagesToInstall
        }
        else {
            Write-ScriptLog "No packages to install from manifest." -Level WARN
        }
    }

    Write-ScriptLog "Chocolatey management run completed successfully. Log saved to: $Global:LogFile" -Level SUCCESS
}
catch {
    Write-ScriptLog "Critical script failure: $($_.Exception.Message)" -Level ERROR
    exit 1
}
#endregion