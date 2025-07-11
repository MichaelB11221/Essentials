<#
.SYNOPSIS
  Restores all services and features to their saved pre-gaming states.

.DESCRIPTION
  Reads the gaming-services-state.json snapshot saved by optimize-gaming.ps1
  and restores service states and startup types.
  Also re-enables Windows features disabled by optimize-gaming.ps1.
  Resets power plan to Balanced.

.EXAMPLE
  .\restore-services.ps1
#>

# Path to snapshot state file
$stateFile = "$PSScriptRoot\gaming-services-state.json"

if (-Not (Test-Path $stateFile)) {
    Write-Error "Snapshot state file not found: $stateFile"
    exit 1
}

# Read saved service states
Write-Output "Reading saved service states..."
$serviceStates = Get-Content $stateFile | ConvertFrom-Json

# Restore services
foreach ($svcName in $serviceStates.PSObject.Properties.Name) {
    $savedStatus = $serviceStates.$svcName
    $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    if ($null -ne $svc) {
        try {
            # Enable service startup
            Set-Service -Name $svcName -StartupType Automatic -ErrorAction Stop
            # Start service if was running before
            if ($savedStatus -eq 'Running') {
                Start-Service -Name $svcName -ErrorAction Stop
            }
        } catch {
    		Write-Warning "Failed to restore $($svcName): $($_)"
        }
    }
}
# Re-enable Windows Features
Write-Output "Re-enabling Windows Features (Hyper-V, WSL, Containers, Sandbox)..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM-WOW64 -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux-Feature -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Subsystem-For-Linux-2 -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart -ErrorAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Sandbox -NoRestart -ErrorAction SilentlyContinue

# Reset power plan to Balanced
Write-Output "Resetting power plan to Balanced..."
$balanced = powercfg -list | Select-String -Pattern "Balanced"
if ($balanced) {
    $guid = ($balanced -split ' ')[3]
    powercfg -setactive $guid
    Write-Output "Power plan set to Balanced."
} else {
    Write-Warning "Balanced power plan not found."
}

Write-Output "Restoration complete. Please restart your PC to fully apply all changes."
