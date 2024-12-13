# System Cleanup Script

Write-Output "Starting system cleanup..."

# 1. Löschen des Windows-Temp-Ordners
$windowsTemp = "C:\Windows\Temp"
if (Test-Path $windowsTemp) {
    Write-Output "Cleaning Windows Temp folder..."
    Remove-Item -Path "$windowsTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Windows Temp folder cleaned."
} else {
    Write-Output "Windows Temp folder not found."
}

# 2. Löschen von Benutzer-Temp-Dateien
$userTemp = "$env:LOCALAPPDATA\Temp"
if (Test-Path $userTemp) {
    Write-Output "Cleaning user Temp folder..."
    Remove-Item -Path "$userTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "User Temp folder cleaned."
} else {
    Write-Output "User Temp folder not found."
}

# 3. Bereinigen des SoftwareDistribution-Ordners (alte Update-Dateien)
$softwareDistribution = "C:\Windows\SoftwareDistribution\Download"
if (Test-Path $softwareDistribution) {
    Write-Output "Cleaning SoftwareDistribution folder..."
    Remove-Item -Path "$softwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "SoftwareDistribution folder cleaned."
} else {
    Write-Output "SoftwareDistribution folder not found."
}

# 4. Leeren des Papierkorbs
Write-Output "Emptying Recycle Bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Output "Recycle Bin emptied."

# 5. Löschen von Protokolldateien älter als 30 Tage (optional)
$logPaths = @(
    "C:\Windows\Logs",
    "$env:LOCALAPPDATA\Temp"
)
foreach ($logPath in $logPaths) {
    if (Test-Path $logPath) {
        Write-Output "Deleting log files older than 30 days in $logPath..."
        Get-ChildItem -Path $logPath -Recurse -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Output "Old log files in $logPath deleted."
    } else {
        Write-Output "Log folder $logPath not found."
    }
}

# Abschluss der Bereinigung
Write-Output "System cleanup completed."
exit 0
