# Check if Microsoft Office is installed and output its version

Write-Output "Checking for Microsoft Office installation..."

# Define registry paths to check for Office installations
$officePaths = @(
    "HKLM:\SOFTWARE\Microsoft\Office",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
)

$officeFound = $false

foreach ($path in $officePaths) {
    if (Test-Path $path) {
        Write-Output "Office installation found at: $path"
        $subKeys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^[0-9]{2,4}$" }
        
        foreach ($subKey in $subKeys) {
            $version = $subKey.PSChildName
            $editionKey = "$($subKey.FullName)\Common\InstallRoot"
            $edition = (Get-ItemProperty -Path $editionKey -ErrorAction SilentlyContinue).Path

            if ($version -and $edition) {
                Write-Output "Office Version: $version, Installation Path: $edition"
                $officeFound = $true
            } elseif ($version) {
                Write-Output "Office Version: $version (Exact path not found)"
                $officeFound = $true
            }
        }
    }
}

if (-not $officeFound) {
    Write-Output "No Microsoft Office installation found."
    exit 1
} else {
    Write-Output "Microsoft Office check completed."
    exit 0
}
