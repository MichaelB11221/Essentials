<#
.SYNOPSIS
  Enables Gaming Mode: disables virtualization & related services, kills telemetry/update/Xbox/GameDVR,
  sets power plan to High Performance.

.DESCRIPTION
  Saves current service states to a JSON snapshot (gaming-services-state.json),
  then disables target services/features.
  Sets power plan, disables GameDVR & Xbox overlays.

.PARAMETER KeepRDP
  Switch: If specified, keeps RDP (TermService) enabled for remote play.

.EXAMPLE
  .\optimize-gaming.ps1            # Gaming mode, RDP disabled
  .\optimize-gaming.ps1 -KeepRDP  # Gaming mode, RDP enabled
#>

param (
    [switch]$KeepRDP
)

# Path for snapshot state file
$stateFile = "$PSScriptRoot\gaming-services-state.json"

# List of services to disable (core virtualization + containers + telemetry + updates + Xbox + misc)
$servicesToDisable = @(
    'vmcompute',      # Hyper-V Host Compute Service
    'vmms',           # Hyper-V Virtual Machine Management
    'LxssManager',    # WSL
    'wuauserv',       # Windows Update
    'WaaSMedicSvc',   # Windows Update Medic
    'BITS',           # Background Intelligent Transfer Service
    'DiagTrack',      # Connected User Experiences and Telemetry
    'CDPSvc',         # Connected Devices Platform Service
    'RemoteRegistry', # Remote Registry
    'OneSyncSvc',     # Sync platform
    'SysMain',        # Superfetch / SysMain
    'XblAuthManager', # Xbox Live Auth Manager
    'XblGameSave',    # Xbox Live Game Save
    'PrintNotify',    # Print Spooler (optional, but usually safe to disable)
    'PrintSpooler',   # Print Spooler service name
    'SharedAccess',   # ICS (Internet Connection Sharing)
    'TermService'     # Remote Desktop Services (RDP)
)

# Remove RDP from disable list if user wants to keep it
if ($KeepRDP) {
    $servicesToDisable = $servicesToDisable | Where-Object { $_ -ne 'TermService' }
}

# Services that must always be kept on for gaming stability and essential system operation
$servicesToKeep = @(
    'Audiosrv',       # Windows Audio
    'AudioEndpointBuilder', # Audio Endpoint
    'Dhcp',           # DHCP Client
    'Dnscache',       # DNS Client
    'SysMain',        # SysMain, but can be disabled - careful (optional)
    'Winmgmt',        # Windows Management Instrumentation
    'WlanSvc',        # WLAN AutoConfig
    'PlugPlay',       # Plug and Play
    'ShellHWDetection' # Hardware detection
)

Write-Output "Starting Gaming Mode optimization..."

# Step 1: Save current service states to JSON for restore
Write-Output "Saving current service states..."
$services = Get-Service | Where-Object { $servicesToDisable -contains $_.Name }
$serviceStates = @{}
foreach ($svc in $services) {
    $serviceStates[$svc.Name] = $svc.Status
}
$serviceStates | ConvertTo-Json | Out-File -Encoding UTF8 $stateFile

# Step 2: Disable listed services
Write-Output "Disabling virtualization, update, telemetry and Xbox-related services..."
foreach ($svcName in $servicesToDisable) {
    $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    if ($null -ne $svc) {
        if ($svc.Status -ne 'Stopped') {
            try {
                Stop-Service -Name $svcName -Force -ErrorAction Stop
                Write-Output "Stopped service: $svcName"
            } catch {
                Write-Warning "Failed to stop service: $svcName ($_)" 
            }
        }
        try {
            Set-Service -Name $svcName -StartupType Disabled -ErrorAction Stop
            Write-Output "Disabled service: $svcName"
        } catch {
            Write-Warning "Failed to disable service: $svcName ($_)" 
        }
    } else {
        Write-Output "Service $svcName not found (OK if not installed)"
    }
}

# Step 3: Disable Windows Features (Hyper-V, Containers, Sandbox, WSL, WSA)
Write-Output "Disabling Windows Features related to virtualization and sandbox..."

# Disable Hyper-V platform and tools
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM-WOW64 -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux-Feature -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux-2 -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart -ErrorAction SilentlyContinue
Disable-WindowsOptionalFeature -Online -FeatureName Windows-Sandbox -NoRestart -ErrorAction SilentlyContinue

# Step 4: Disable GameDVR & Xbox Overlays
Write-Output "Disabling GameDVR and Xbox overlays..."
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "GameDVR_Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameConfigStore" -Name "GameDVR_FSEBehaviorMode_FFZ" -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\XboxGameOverlay" -Name "ShowStartupTrace" -Value 0 -PropertyType DWord -Force | Out-Null

# Step 5: Set power plan to High Performance
Write-Output "Setting power plan to High Performance..."
$highPerf = powercfg -list | Select-String -Pattern "High performance"
if ($highPerf) {
    $guid = ($highPerf -split ' ')[3]
    powercfg -setactive $guid
    Write-Output "Power plan set to High Performance."
} else {
    Write-Warning "High Performance power plan not found."
}

Write-Output "Gaming Mode optimization complete."
Write-Output "Run restore-services.ps1 to revert changes."
