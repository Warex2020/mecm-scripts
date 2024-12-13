# Check if Telemetry (OTele) data collection is enabled

Write-Output "Checking for Telemetry (OTele) data collection settings..."

# Define the registry path for Telemetry settings
$telemetryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"

if (Test-Path $telemetryKey) {
    # Retrieve Telemetry settings
    $telemetryValue = Get-ItemProperty -Path $telemetryKey -Name AllowTelemetry -ErrorAction SilentlyContinue | Select-Object -ExpandProperty AllowTelemetry

    switch ($telemetryValue) {
        0 { Write-Output "Telemetry is disabled (AllowTelemetry: 0)." }
        1 { Write-Output "Basic telemetry is enabled (AllowTelemetry: 1)." }
        2 { Write-Output "Enhanced telemetry is enabled (AllowTelemetry: 2)." }
        3 { Write-Output "Full telemetry is enabled (AllowTelemetry: 3)." }
        default { Write-Output "Telemetry settings are not configured or unknown value found." }
    }

    exit 0
} else {
    Write-Output "Telemetry settings not found in the registry. Assuming Telemetry is not configured."
    exit 1
}
