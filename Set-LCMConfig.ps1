[DSCLocalConfigurationManager()]
Configuration LCMConfig {
    Node "localhost" {
        Settings {
            RefreshMode = "Push"                    # You apply configs manually
            ConfigurationMode = "ApplyOnly"  # Enforce compliance
            ConfigurationModeFrequencyMins = 30     # Optional: re-check every 30 min
            RebootNodeIfNeeded = $true              # Reboot if needed
            AllowModuleOverWrite = $true
        }
    }
}

# Generate and apply the LCM configuration
LCMConfig
Set-DscLocalConfigurationManager -Path ./LCMConfig
