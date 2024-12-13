# Check if telemetry data collection is enabled for Microsoft Office

Write-Output "Checking telemetry settings for Microsoft Office..."

# Define registry paths for Office telemetry settings
$officeTelemetryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Office",
    "HKCU:\SOFTWARE\Policies\Microsoft\Office"
)

$telemetryFound = $false

foreach ($path in $officeTelemetryPaths) {
    if (Test-Path $path) {
        Write-Output "Office telemetry settings found at: $path"
        
        # Search for telemetry settings under each Office version
        $subKeys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^[0-9]{2,4}$" }
        
        foreach ($subKey in $subKeys) {
            $version = $subKey.PSChildName
            $telemetryKey = "$($subKey.FullName)\Common\Telemetry"
            
            if (Test-Path $telemetryKey) {
                $telemetryValue = Get-ItemProperty -Path $telemetryKey -Name DisableTelemetry -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DisableTelemetry
                $telemetryFound = $true

                if ($telemetryValue -eq 1) {
                    Write-Output "Telemetry is disabled for Office $version."
                } elseif ($telemetryValue -eq 0) {
                    Write-Output "Telemetry is enabled for Office $version."
                } else {
                    Write-Output "Telemetry settings for Office $version are not configured."
                }
            }
        }
    }
}

if (-not $telemetryFound) {
    Write-Output "No telemetry settings found for Microsoft Office."
    exit 1
} else {
    Write-Output "Office telemetry check completed."
    exit 0
}
