# Log off all currently logged-in users

# Get all active sessions
$sessions = Get-CimInstance -ClassName Win32_LogonSession | Where-Object { $_.LogonType -eq 2 }

if ($sessions) {
    Write-Output "Logging off all active users."
    foreach ($session in $sessions) {
        $loggedOnUser = Get-CimInstance -Query "ASSOCIATORS OF {Win32_LogonSession.LogonId='$($session.LogonId)'} WHERE AssocClass=Win32_LoggedOnUser"

        foreach ($user in $loggedOnUser) {
            $userName = $user.Antecedent.Name
            $domain = $user.Antecedent.Domain
            $logonId = $session.LogonId

            # Log off the user
            try {
                Invoke-CimMethod -Query "SELECT * FROM Win32_LogonSession WHERE LogonId = '$logonId'" -MethodName Terminate
                Write-Output "User: $domain\$userName successfully logged off."
            } catch {
                Write-Output "Failed to log off user: $domain\$userName. Error: $_"
            }
        }
    }
    exit 0
} else {
    Write-Output "No active users to log off."
    exit 1
}
