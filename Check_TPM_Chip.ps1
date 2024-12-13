# Checking for TPM security chip presence
$tpm = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm -ErrorAction SilentlyContinue

if ($tpm) {
    Write-Output "TPM chip found: ManufacturerID=$($tpm.ManufacturerID), Version=$($tpm.SpecVersion)"
    exit 0
} else {
    Write-Output "No TPM chip found on this system."
    exit 1
}
