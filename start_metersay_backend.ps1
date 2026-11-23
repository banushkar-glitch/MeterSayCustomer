# MeterSay Background Services Launcher
$ErrorActionPreference = "SilentlyContinue"
$logFile = "D:\MeterSayCustomer\backend_service.log"

function Write-Log([string]$msg) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $logFile -Value "[$timestamp] $msg"
}

function Test-PortOpen([string]$server, [int]$port) {
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $iar = $tcp.BeginConnect($server, $port, $null, $null)
        $wait = $iar.AsyncWaitHandle.WaitOne(800, $false)
        if (-not $wait) {
            $tcp.Close()
            return $false
        }
        $tcp.EndConnect($iar)
        $tcp.Close()
        return $true
    } catch {
        return $false
    }
}

Write-Log "Checking MeterSay services..."

# 1. Check PostgreSQL (Port 5432)
if (-not (Test-PortOpen "127.0.0.1" 5432)) {
    Write-Log "Starting PostgreSQL 18..."
    Start-Process -FilePath "C:\Program Files\PostgreSQL\18\bin\postgres.exe" -ArgumentList '-D "C:\Program Files\PostgreSQL\18\data"' -WindowStyle Hidden
    
    $retries = 0
    while (-not (Test-PortOpen "127.0.0.1" 5432) -and $retries -lt 10) {
        Start-Sleep -Milliseconds 500
        $retries++
    }
    if (Test-PortOpen "127.0.0.1" 5432) {
        Write-Log "PostgreSQL started successfully on port 5432."
    } else {
        Write-Log "PostgreSQL failed to open port 5432 within 5 seconds."
    }
} else {
    Write-Log "PostgreSQL is already running on port 5432."
}

# 2. Check Spring Boot Backend (Port 8080)
if (-not (Test-PortOpen "127.0.0.1" 8080)) {
    $jarPath = "D:\MeterSayCustomer\backend\metersay-backend\build\libs\metersay-backend-0.0.1-SNAPSHOT.jar"
    if (Test-Path $jarPath) {
        Write-Log "Starting Spring Boot backend ($jarPath)..."
        Start-Process -FilePath "java" -ArgumentList "-jar `"$jarPath`"" -WorkingDirectory "D:\MeterSayCustomer\backend\metersay-backend" -WindowStyle Hidden
        Write-Log "Spring Boot process launched."
    } else {
        Write-Log "ERROR: JAR file not found at $jarPath"
    }
} else {
    Write-Log "Spring Boot backend is already running on port 8080."
}

# 3. Check MeterSay Driver Backend (Port 5000)
if (-not (Test-PortOpen "127.0.0.1" 5000)) {
    $driverJar = "D:\Users\Abhijeet\MeterSe\springboot-backend\target\metersay-backend-1.0.0.jar"
    if (Test-Path $driverJar) {
        Write-Log "Starting MeterSay Driver Backend ($driverJar)..."
        Start-Process -FilePath "java" -ArgumentList "-jar `"$driverJar`"" -WorkingDirectory "D:\Users\Abhijeet\MeterSe\springboot-backend" -WindowStyle Hidden
        Write-Log "MeterSay Driver Backend process launched on port 5000."
    } else {
        Write-Log "ERROR: Driver backend JAR file not found at $driverJar"
    }
} else {
    Write-Log "MeterSay Driver Backend is already running on port 5000."
}


