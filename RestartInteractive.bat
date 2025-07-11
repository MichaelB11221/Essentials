@echo off
echo ................................................
echo Press 1, 2, 3, 4, 5, 6, 7, 8 to select your task, or 9 to EXIT.
echo Run this .bat with admin privileges            .
echo ................................................
echo.
echo 1 - Boot Menu
echo 2 - Gaming
echo 3 - Non Gaming
echo 4 - Restart
echo 5 - Safe Boot Minimal
echo 6 - Safe Boot with Network
echo 7 - Normal Boot
echo 8 - Shutdown
echo 9 - Exit
echo.
SET /P M=Type 1, 2, 3, 4, 5, 6, 7, 8, 9 then press ENTER:
IF %M%==1 GOTO boot
IF %M%==2 GOTO gaming
IF %M%==3 GOTO nongaming
IF %M%==4 GOTO restart
IF %M%==5 GOTO safe
IF %M%==6 GOTO safenet
IF %M%==7 GOTO normal
IF %M%==8 GOTO shutdown
IF %M%==9 GOTO exit

:boot
bcdedit /set {bootmgr} displaybootmenu Yes
goto reboot

:gaming
bcdedit /default {current}
goto reboot

:nongaming
bcdedit /default {default}
goto reboot

:restart
goto reboot

:safe
bcdedit /set {default} safeboot minimal
goto reboot

:safenet
bcdedit /set {default} safeboot network
goto reboot

:normal
bcdedit /deletevalue {default} safeboot
goto reboot

:shutdown
shutdown -f -t

:reboot
shutdown -r -f -t 4
exit

:exit
exit
