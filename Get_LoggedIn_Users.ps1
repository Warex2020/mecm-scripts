# Display logged-in users, login time, and session state

# Query logged-in users
$users = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
$sessions = Get-WmiObject -Namespace "root\cimv2" -Class Win32_LogonSession

# Filter interactive logons and get details
$interactiveLogons = $sessions | Where-Object { $_.LogonType -eq 2 }

if ($interactiveLogons) {
    Write-Output "Logged-in users and session details:"
    foreach ($logon in $interactiveLogons) {
        $loginInfo = $logon | Get-WmiObject -Query "ASSOCIATORS OF {Win32_LogonSession.LogonId='$($_.LogonId)'} WHERE AssocClass=Win32_LoggedOnUser Role=Dependent"

        foreach ($info in $loginInfo) {
            $userName = $info.Antecedent.Name
            $domain = $info.Antecedent.Domain
            $logonTime = $logon.StartTime
            $state = if ($logon.Caption -eq 'Active') { "Unlocked" } else { "Locked" }
            Write-Output "User: $domain\$userName, Login Time: $logonTime, State: $state"
        }
    }
    exit 0
} else {
    Write-Output "No interactive sessions found."
    exit 1
}
