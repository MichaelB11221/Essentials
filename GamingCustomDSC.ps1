# ===================== #
#  Gaming DSC Baseline  #
# ===================== #

Configuration GamingSetupConfig {
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node "localhost" {

        # ---------- CORE SYSTEM TWEAKS ----------
        
        # Disable Hibernation
        Registry DisableHibernation {
            Key = "HKLM\SYSTEM\ControlSet001\Control\Power"
            ValueName = "HibernateEnabled"
            ValueType = "Dword"
            ValueData = 0
            Ensure = "Present"
        }

	# Unlock and set Ultimate Performance power plan
	Script SetUltimatePerfPlan {
   	 GetScript = {
        $guid = (powercfg -GETACTIVESCHEME) -match "e9a42b02"
        return @{ Result = $guid }
    }
    TestScript = {
        $active = (powercfg /GETACTIVESCHEME)
        return $active -like "*e9a42b02*"
    }
    SetScript = {
        # Add the Ultimate Performance plan if it doesn't exist
        $exists = powercfg /L | Select-String "e9a42b02"
        if (-not $exists) {
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        }
        # Set it as active
        powercfg /S e9a42b02-d5df-448d-aa00-03f14749eb61
    }
}

        # Disable Windows Defender Real-Time Protection (optional, controversial)
        Registry DisableDefenderRealTime {
            Key = "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
            ValueName = "DisableRealtimeMonitoring"
            ValueType = "Dword"
            ValueData = 1
            Ensure = "Present"
        }

        # Disable Game DVR / Xbox Game Bar
        Registry DisableGameDVR {
            Key = "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
            ValueName = "AllowGameDVR"
            ValueType = "Dword"
            ValueData = 0
            Ensure = "Present"
        }

        # Disable Startup Delay
        Registry StartupDelay {
            Key = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
            ValueName = "StartupDelayInMSec"
            ValueType = "Dword"
            ValueData = 0
            Ensure = "Present"
        }

        # ---------- CLEAN WINDOWS CRAP ----------

        # Remove SMB1
        WindowsFeature RemoveSMB1 {
            Name   = "FS-SMB1"
            Ensure = "Absent"
        }

        # Remove XPS Viewer
        WindowsFeature RemoveXPS {
            Name   = "XPS-Viewer"
            Ensure = "Absent"
        }

        # Remove Math Recognizer
        WindowsFeature RemoveMathRecognizer {
            Name   = "MathRecognizer"
            Ensure = "Absent"
        }

        # Remove Fax + Scan
        WindowsFeature RemoveFax {
            Name   = "FaxServicesClientPackage"
            Ensure = "Absent"
        }

        # Remove Work Folders
        WindowsFeature RemoveWorkFolders {
            Name   = "WorkFolders-Client"
            Ensure = "Absent"
        }

        # Remove IE (legacy)
        WindowsFeature RemoveIE {
            Name   = "Internet-Explorer-Optional-amd64"
            Ensure = "Absent"
        }

        # ---------- FILE CLEANUP EXAMPLE ----------

        Script DeleteTempFiles {
            GetScript = { return @{ Result = $true } }
            TestScript = { return $false }
            SetScript = {
                Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        Script ClearPrefetch {
            GetScript = { return @{ Result = $true } }
            TestScript = { return $false }
            SetScript = {
                Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        # ---------- DISABLE ANNOYANCES ----------

        # Disable Consumer Experience content
        Registry DisableCEIP {
            Key = "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            ValueName = "DisableWindowsConsumerFeatures"
            ValueType = "Dword"
            ValueData = 1
            Ensure = "Present"
        }

        # Disable Auto Download of suggested apps
        Registry DisableSuggestedApps {
            Key = "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            ValueName = "DisableSoftLanding"
            ValueType = "Dword"
            ValueData = 1
            Ensure = "Present"
        }

        # Disable Windows Tips
        Registry DisableTips {
            Key = "HKLM\Software\Policies\Microsoft\Windows\CloudContent"
            ValueName = "DisableSoftLanding"
            ValueType = "Dword"
            ValueData = 1
            Ensure = "Present"
        }
    }
}

# Generate MOF
GamingSetupConfig
