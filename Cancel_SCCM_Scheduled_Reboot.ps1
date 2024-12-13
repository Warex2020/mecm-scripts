# Cancel a scheduled reboot initiated by the Software Center

# Stop the SCNotification process
$scNotification = Get-Process -Name SCNotification -ErrorAction SilentlyContinue
if ($scNotification) {
    Stop-Process -Name SCNotification -Force
    Write-Output "SCNotification process has been stopped."
} else {
    Write-Output "SCNotification process is not running."
}

# Suspend the CcmExec service
$ccmExecService = Get-Service -Name CcmExec -ErrorAction SilentlyContinue
if ($ccmExecService.Status -eq 'Running') {
    Suspend-Service -Name CcmExec
    Write-Output "CcmExec service has been suspended."
} else {
    Write-Output "CcmExec service is not running."
}

# Cancel the scheduled reboot
shutdown.exe /a
if ($LASTEXITCODE -eq 0) {
    Write-Output "Scheduled reboot successfully canceled."
    exit 0
} else {
    Write-Output "No scheduled reboot found or cancellation failed."
    exit 1
}
