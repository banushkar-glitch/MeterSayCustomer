@echo off
title Stop MeterSay Services
echo ========================================================
echo        Stopping MeterSay Background Services...
echo ========================================================
powershell.exe -Command "& {
    Get-Process -Name java -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like '*metersay-backend*' -or (Get-Process -Id $_.Id).Path -like '*java*' } | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process -Name postgres -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host 'MeterSay services stopped.' -ForegroundColor Yellow
}"
echo ========================================================
timeout /t 3

