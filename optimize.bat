@echo off
:: Run optimize-gaming.ps1 as admin and show output

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0optimize-gaming.ps1\"' -Verb RunAs"
