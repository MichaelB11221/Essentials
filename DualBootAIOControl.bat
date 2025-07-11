@echo off
title Dual Boot AIO Control
color 0A
mode con cols=50 lines=20

:menu
cls
echo ========================================
echo         Dual Boot AIO Control
echo ========================================
echo 1. Restart
echo 2. Power Off
echo 3. Reboot to Current Boot Entry (Skip Boot Menu)
echo 4. Reboot to Other Boot Entry (Skip Boot Menu)
echo 5. Reboot to Safe Mode
echo 6. Reboot to Safe Mode with Networking
echo 7. Reboot to Safe Mode with Command Prompt
echo 8. Reboot to Safe Mode (Last Option)
echo 9. Reboot to BIOS
echo 10. Reboot to Boot Menu
echo 11. Reboot to Advanced Startup Options
echo ========================================
echo Choose an option:
set /p choice=

IF "%choice%"=="1" GOTO restart
IF "%choice%"=="2" GOTO poweroff
IF "%choice%"=="3" GOTO bootcurrent
IF "%choice%"=="4" GOTO bootother
IF "%choice%"=="5" GOTO safemode
IF "%choice%"=="6" GOTO safenetwork
IF "%choice%"=="7" GOTO safecli
IF "%choice%"=="8" GOTO safeother
IF "%choice%"=="9" GOTO bios
IF "%choice%"=="10" GOTO bootmenu
IF "%choice%"=="11" GOTO advanced
GOTO menu

:restart
shutdown /r /t 0
GOTO end

:poweroff
shutdown /s /t 0
GOTO end

:bootcurrent
bcdedit /bootsequence {current} /1
shutdown /r /t 0
GOTO end

:bootother
for /f "tokens=2 delims={}" %%i in ('bcdedit /enum ^| find "identifier"') do (
    if not "%%i"=="current" (
        bcdedit /bootsequence {%%i} /1
        shutdown /r /t 0
    )
)
GOTO end

:safemode
bcdedit /set {current} safeboot minimal
shutdown /r /t 0
GOTO end

:safenetwork
bcdedit /set {current} safeboot network
shutdown /r /t 0
GOTO end

:safecli
bcdedit /set {current} safeboot minimal
bcdedit /set {current} safebootalternateshell yes
shutdown /r /t 0
GOTO end

:safeother
bcdedit /set {current} safeboot minimal
shutdown /r /t 0
GOTO end

:bios
shutdown /r /fw /t 0
GOTO end

:bootmenu
shutdown /r /o /t 0
GOTO end

:advanced
shutdown /r /o /t 0
GOTO end

:end
exit