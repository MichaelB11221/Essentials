# Set paths
$WTPath   = "C:\Users\baden\AppData\Local\Microsoft\WindowsApps\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\wt.exe"
$WSBPath  = "C:\Users\baden\AppData\Local\Microsoft\WindowsApps\MicrosoftWindows.WindowsSandbox_cw5n1h2txyewy\wsb.exe"
$WSAPath  = "C:\Users\baden\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\WsaClient.exe"
$WSLPath  = "C:\Users\baden\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForLinux_8wekyb3d8bbwe\wsl.exe"

# 1. Windows Terminal Preview context menu (files/folders, as admin and non-admin)
foreach ($target in @("*", "Directory")) {
    # Non-admin
    $base = "Registry::HKEY_CLASSES_ROOT\$target\shell\WTPreview"
    New-Item -Path $base -Force | Out-Null
    Set-ItemProperty -Path $base -Name "MUIVerb" -Value "Open in Windows Terminal Preview"
    Set-ItemProperty -Path $base -Name "Icon" -Value $WTPath
    New-Item -Path "$base\command" -Force | Out-Null
    Set-ItemProperty -Path "$base\command" -Name "(default)" -Value "`"$WTPath`" `"%V`""
    # Admin
    $baseA = "Registry::HKEY_CLASSES_ROOT\$target\shell\WTPreviewAdmin"
    New-Item -Path $baseA -Force | Out-Null
    Set-ItemProperty -Path $baseA -Name "MUIVerb" -Value "Open in Windows Terminal Preview (Admin)"
    Set-ItemProperty -Path $baseA -Name "Icon" -Value $WTPath
    Set-ItemProperty -Path $baseA -Name "HasLUAShield" -Value ""
    New-Item -Path "$baseA\command" -Force | Out-Null
    Set-ItemProperty -Path "$baseA\command" -Name "(default)" -Value "powershell -Command Start-Process -FilePath `"$WTPath`" -ArgumentList `"`"%V`"`" -Verb RunAs"
}

# 2. Windows Sandbox context menu (files only)
$base = "Registry::HKEY_CLASSES_ROOT\*\shell\WSB"
New-Item -Path $base -Force | Out-Null
Set-ItemProperty -Path $base -Name "MUIVerb" -Value "Open in Windows Sandbox"
Set-ItemProperty -Path $base -Name "Icon" -Value $WSBPath
New-Item -Path "$base\command" -Force | Out-Null
Set-ItemProperty -Path "$base\command" -Name "(default)" -Value "`"$WSBPath`" `"%1`""

# 3. Windows Subsystem for Android context menu (folders)
$base = "Registry::HKEY_CLASSES_ROOT\Directory\shell\WSA"
New-Item -Path $base -Force | Out-Null
Set-ItemProperty -Path $base -Name "MUIVerb" -Value "Open in Windows Subsystem for Android"
Set-ItemProperty -Path $base -Name "Icon" -Value $WSAPath
New-Item -Path "$base\command" -Force | Out-Null
Set-ItemProperty -Path "$base\command" -Name "(default)" -Value "`"$WSAPath`""

# 4. Windows Subsystem for Linux context menu (folders, as admin and non-admin)
foreach ($distro in @("", " -d Ubuntu", " -d kali-linux")) {
    $label = "Open in WSL" + $(if ($distro -eq "") {""} elseif ($distro -like "*Ubuntu*") {" (Ubuntu)"} else {" (Kali)"})
    $key = "Registry::HKEY_CLASSES_ROOT\Directory\shell\WSL" + $(if ($distro -eq "") {""} elseif ($distro -like "*Ubuntu*") {"Ubuntu"} else {"Kali"})
    # Non-admin
    New-Item -Path $key -Force | Out-Null
    Set-ItemProperty -Path $key -Name "MUIVerb" -Value $label
    Set-ItemProperty -Path $key -Name "Icon" -Value $WSLPath
    New-Item -Path "$key\command" -Force | Out-Null
    Set-ItemProperty -Path "$key\command" -Name "(default)" -Value "`"$WSLPath`"$distro --cd `"%V`""
    # Admin
    $keyA = $key + "Admin"
    New-Item -Path $keyA -Force | Out-Null
    Set-ItemProperty -Path $keyA -Name "MUIVerb" -Value "$label (Admin)"
    Set-ItemProperty -Path $keyA -Name "Icon" -Value $WSLPath
    Set-ItemProperty -Path $keyA -Name "HasLUAShield" -Value ""
    New-Item -Path "$keyA\command" -Force | Out-Null
    Set-ItemProperty -Path "$keyA\command" -Name "(default)" -Value "powershell -Command Start-Process -FilePath `"$WSLPath`" -ArgumentList `"$distro --cd `"%V`"`" -Verb RunAs"
}

Write-Host "All context menu entries for Windows Terminal Preview, Sandbox, WSA, and WSL (including Ubuntu and Kali) have been added. Restart Explorer to see them."