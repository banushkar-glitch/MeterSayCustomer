@echo off
title MeterSay Backend Services
echo ========================================================
echo        Starting MeterSay Background Services...
echo ========================================================
powershell.exe -ExecutionPolicy Bypass -File "D:\MeterSayCustomer\start_metersay_backend.ps1"
echo.
echo Verification:
powershell.exe -Command "& {
    function Test-PortOpen([string]$server, [int]$port) {
        try {
            $tcp = New-Object System.Net.Sockets.TcpClient
            $iar = $tcp.BeginConnect($server, $port, $null, $null)
            $wait = $iar.AsyncWaitHandle.WaitOne(800, $false)
            if (-not $wait) { $tcp.Close(); return $false }
            $tcp.EndConnect($iar); $tcp.Close(); return $true
        } catch { return $false }
    }
    Write-Host '  [PostgreSQL 18  - Port 5432]:' (if (Test-PortOpen '127.0.0.1' 5432) { 'RUNNING (OK)' } else { 'STOPPED' })
    Write-Host '  [Spring Boot    - Port 8080]:' (if (Test-PortOpen '127.0.0.1' 8080) { 'RUNNING (OK)' } else { 'STARTING...' })
}"
echo ========================================================
echo Done! You can now use MeterSay Customer App.
timeout /t 5

