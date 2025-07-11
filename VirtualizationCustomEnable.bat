@echo off
echo === Enabling conflicting Windows features ===
dism.exe /Online /Enable-Feature:Microsoft-Hyper-V-All /NoRestart
dism.exe /Online /Enable-Feature:VirtualMachinePlatform /NoRestart
dism.exe /Online /Enable-Feature:HypervisorPlatform /NoRestart
dism.exe /Online /Enable-Feature:WindowsDefenderApplicationGuard /NoRestart

echo === Disabling Memory Integrity (HVCI) ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v AllowFullMemoryAccess /t REG_DWORD /d 1 /f

echo === Enabling Windows Hypervisor Platform ONLY ===
dism.exe /Online /Enable-Feature /FeatureName:HypervisorPlatform /All /NoRestart

echo === Forcing WHPX restart ===
bcdedit /set hypervisorlaunchtype on
bcdedit /set HypervisorEnforcedCodeIntegrity on

echo === REBOOT REQUIRED. Press any key to reboot now... ===
pause >nul
shutdown /r /t 0
