# Check if BitLocker is active and list the encryption status of all partitions
$bitLockerVolumes = Get-BitLockerVolume -ErrorAction SilentlyContinue

if ($bitLockerVolumes) {
    Write-Output "BitLocker is active on this system."
    
    foreach ($volume in $bitLockerVolumes) {
        $status = if ($volume.ProtectionStatus -eq 1) { "Encrypted" } else { "Not Encrypted" }
        Write-Output "Drive: $($volume.MountPoint), Status: $status"
    }

    exit 0
} else {
    Write-Output "BitLocker is not active on this system."
    exit 1
}
