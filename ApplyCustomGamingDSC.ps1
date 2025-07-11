$ConfigPath = "$PSScriptRoot\GamingCustomDSC"
Start-DscConfiguration -Path $ConfigPath -Wait -Force -Verbose
