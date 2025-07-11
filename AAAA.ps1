@echo off
:menu
echo Welcome to the Multiple-Answer Question Script!
echo Please choose an option (1-30):
echo ----------------------------------------------
echo 1. Option 1 - Default tweak A
echo 2. Option 2 - Default tweak B
echo 3. Option 3 - Default tweak C
echo ...
echo 30. Option 30 - Default tweak Z
echo ----------------------------------------------
set /p choice="Enter your choice (1-30): "

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="4" goto option3
if "%choice%"=="30" goto option30
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="30" goto option30
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="30" goto option30
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3
if "%choice%"=="3" goto option3


































echo Invalid choice! Please try again.
goto menu

:option1
echo You selected Option 1 with tweak A. Perform action here.
goto menu

:option2
echo You selected Option 2 with tweak B. Perform action here.
goto menu

:option3
echo You selected Option 3 with tweak C. Perform action here.
goto menu

:: Add more sections for options here
:option30
echo You selected Option 30 with tweak Z. Perform action here.
goto menu

:end
echo Thank you for using the script!
exit
