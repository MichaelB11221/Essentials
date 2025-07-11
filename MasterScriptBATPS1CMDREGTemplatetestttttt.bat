# Check if running as Administrator; if not, relaunch the script with elevated privileges.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator"))
{
    Write-Host "This script requires Administrator privileges. Relaunching with elevated rights..."
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Set the Execution Policy to Bypass for the current process.
Set-ExecutionPolicy Bypass -Scope Process -Force

# Stop execution on any error.
$ErrorActionPreference = "Stop"

# List of scripts (including .ps1, .bat, .cmd, and .reg). Replace with your actual paths.
$scriptList = @(
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\1.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\2.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\3.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\4.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\5.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\bufferbloat-main\Resources\1 by 1\6.bat",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\Github\windows11-scripts\windows11-scripts-main\windows11-scripts-main\RemoveRTXRemixVulkanBeta.reg",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\Github\windows11-scripts\windows11-scripts-main\windows11-scripts-main\RemoveDXVK_HUD.reg",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\Github\windows11-scripts\windows11-scripts-main\windows11-scripts-main\HKCUdsound.reg",
"D:\Private\Locker\Windows\SoftwareTweaking\TweakingApps&Tools\Tweaks,Optimizations,Scripts,CLITools\networktweaks.ps1",
"D:\UACDisable.ps1"
)

# Loop through each script and execute it based on its file type.
foreach ($script in $scriptList) {
    if (Test-Path $script) {
        Write-Host "Running $script..."

        # Check the file extension and execute accordingly.
        $fileExtension = [System.IO.Path]::GetExtension($script).ToLower()

        switch ($fileExtension) {
            ".ps1" {
                # Run PowerShell script
                & $script
                Write-Host "$script completed successfully."
            }
            ".bat" {
                # Run .bat file using cmd.exe
                Start-Process cmd.exe -ArgumentList "/c `"$script`""
                Write-Host "$script completed successfully."
            }
            ".cmd" {
                # Run .cmd file using cmd.exe
                Start-Process cmd.exe -ArgumentList "/c `"$script`""
                Write-Host "$script completed successfully."
            }
            ".reg" {
                # Import .reg file using regedit
                Start-Process regedit.exe -ArgumentList "/s `"$script`""
                Write-Host "$script registry import completed successfully."
            }
            default {
                Write-Host "Unsupported script type: $script" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Error: $script not found!" -ForegroundColor Red
        exit 1  # Stop the master script if any script is missing.
    }
}

Write-Host "All scripts executed successfully!"