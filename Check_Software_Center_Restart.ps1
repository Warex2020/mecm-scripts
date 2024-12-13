# Check if a restart is pending in Software Center

# Path to the registry key that indicates a pending restart
$pendingRestartKeys = @(
    "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootRequired",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
)

$pendingRestart = $false

foreach ($key in $pendingRestartKeys) {
    if (Test-Path $key) {
        Write-Output "A restart is pending. Key found: $key"
        $pendingRestart = $true
        break
    }
}

if (-not $pendingRestart) {
    Write-Output "No restart is pending in Software Center."
    exit 0
} else {
    exit 1
}
