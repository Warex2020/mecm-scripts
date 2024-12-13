# Disable telemetry data collection for Microsoft Office for all users

Write-Output "Disabling telemetry data collection for Microsoft Office for all users..."

# Define the registry path for machine-wide Office telemetry settings
$officeTelemetryHKLM = "HKLM:\SOFTWARE\Policies\Microsoft\Office"

# Define the registry path for default user settings (applies to new profiles)
$defaultUserRegistry = "HKLM:\SOFTWARE\Microsoft\Office"

# Disable telemetry for HKLM (all users on the machine)
if (Test-Path $officeTelemetryHKLM) {
    $subKeys = Get-ChildItem -Path $officeTelemetryHKLM | Where-Object { $_.Name -match "^[0-9]{2,4}$" }
    foreach ($subKey in $subKeys) {
        $telemetryKey = "$($subKey.FullName)\Common\Telemetry"
        if (-not (Test-Path $telemetryKey)) {
            New-Item -Path $telemetryKey -Force | Out-Null
            Write-Output "Created telemetry key for Office version at $telemetryKey."
        }
        Set-ItemProperty -Path $telemetryKey -Name DisableTelemetry -Value 1 -Force
        Write-Output "Telemetry disabled for Office version (HKLM): $($subKey.PSChildName)."
    }
} else {
    Write-Output "Office policy path not found under HKLM. Creating it..."
    New-Item -Path $officeTelemetryHKLM -Force | Out-Null
}

# Disable telemetry for default user settings (ensures it applies to new users)
if (Test-Path $defaultUserRegistry) {
    $subKeys = Get-ChildItem -Path $defaultUserRegistry | Where-Object { $_.Name -match "^[0-9]{2,4}$" }
    foreach ($subKey in $subKeys) {
        $telemetryKey = "$($subKey.FullName)\Common\Telemetry"
        if (-not (Test-Path $telemetryKey)) {
            New-Item -Path $telemetryKey -Force | Out-Null
            Write-Output "Created telemetry key for Office version at $telemetryKey (Default User)."
        }
        Set-ItemProperty -Path $telemetryKey -Name DisableTelemetry -Value 1 -Force
        Write-Output "Telemetry disabled for Office version (Default User): $($subKey.PSChildName)."
    }
} else {
    Write-Output "Default user registry path for Office not found. Creating it..."
    New-Item -Path $defaultUserRegistry -Force | Out-Null
}

Write-Output "Telemetry settings have been successfully disabled for all users."
exit 0
