@echo off
:: Run restore-services.ps1 as admin and show output

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0restore-services.ps1\"' -Verb RunAs"
