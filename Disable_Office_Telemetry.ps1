# Disable telemetry data collection for Microsoft Office

Write-Output "Disabling telemetry data collection for Microsoft Office..."

# Define registry paths for Office telemetry settings
$officeTelemetryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Office",
    "HKCU:\SOFTWARE\Policies\Microsoft\Office"
)

foreach ($path in $officeTelemetryPaths) {
    # Check if the base Office policy key exists
    if (Test-Path $path) {
        # Search for Office versions under the base policy key
        $subKeys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^[0-9]{2,4}$" }
        
        foreach ($subKey in $subKeys) {
            $version = $subKey.PSChildName
            $telemetryKey = "$($subKey.FullName)\Common\Telemetry"
            
            # Ensure the telemetry key exists
            if (-not (Test-Path $telemetryKey)) {
                New-Item -Path $telemetryKey -Force | Out-Null
                Write-Output "Created telemetry key for Office $version at $telemetryKey."
            }

            # Set the DisableTelemetry value to 1 (disable telemetry)
            Set-ItemProperty -Path $telemetryKey -Name DisableTelemetry -Value 1 -Force
            Write-Output "Telemetry disabled for Office $version."
        }
    } else {
        Write-Output "Policy path not found: $path. Skipping."
    }
}

Write-Output "Office telemetry has been successfully disabled."
exit 0
