# Check for TPM and enable BitLocker on all local partitions without PIN prompt
$tpm = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm -ErrorAction SilentlyContinue

if ($tpm) {
    Write-Output "TPM chip found: ManufacturerID=$($tpm.ManufacturerID), Version=$($tpm.SpecVersion). Starting encryption."

    # Ensure BitLocker is installed
    if (!(Get-WindowsFeature -Name BitLocker).Installed) {
        Write-Output "BitLocker is not installed. Installing BitLocker..."
        Install-WindowsFeature -Name BitLocker -IncludeManagementTools -ErrorAction Stop
    }

    # Get all local partitions
    $localDrives = Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' }

    foreach ($drive in $localDrives) {
        $mountPoint = $drive.DriveLetter
        if (!$mountPoint) {
            Write-Output "Skipping drive without a drive letter."
            continue
        }

        # Check if BitLocker is already enabled
        $BitLockerStatus = Get-BitLockerVolume -MountPoint $mountPoint
        if ($BitLockerStatus.ProtectionStatus -eq 'Off') {
            Write-Output "Enabling BitLocker on drive $mountPoint."
            Enable-BitLocker -MountPoint $mountPoint -EncryptionMethod XtsAes256 -TpmProtector -ErrorAction Stop
        } else {
            Write-Output "BitLocker is already enabled on drive $mountPoint."
        }
    }

    Write-Output "BitLocker encryption process initiated for all local drives."
    exit 0
} else {
    Write-Output "No TPM chip found on this system. BitLocker cannot be enabled."
    exit 1
}
