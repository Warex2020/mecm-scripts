# Script to track user activity for the last 7 days and calculate active times

Write-Output "Tracking logged-in user activities for the last 7 days..."

# Define the date range (last 7 days)
$startDate = (Get-Date).AddDays(-7)

# Function to convert ticks to a readable time format
function Convert-TicksToTime {
    param ($ticks)
    [TimeSpan]::FromTicks($ticks)
}

# Retrieve logged events (only for the last 7 days)
$events = Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4800, 4801; StartTime=$startDate} -ErrorAction SilentlyContinue

if ($events) {
    $userActivity = @{}

    foreach ($event in $events) {
        $eventTime = $event.TimeCreated
        $user = $event.Properties[5].Value

        # Check for unlock (4801) and lock (4800) events
        if ($event.Id -eq 4801) {
            if (-not $userActivity[$user]) {
                $userActivity[$user] = @()
            }
            $userActivity[$user] += @([PSCustomObject]@{
                Action = "Unlocked"
                Time   = $eventTime
            })
        } elseif ($event.Id -eq 4800) {
            if (-not $userActivity[$user]) {
                $userActivity[$user] = @()
            }
            $userActivity[$user] += @([PSCustomObject]@{
                Action = "Locked"
                Time   = $eventTime
            })
        }
    }

    # Process activity data for each user
    foreach ($user in $userActivity.Keys) {
        Write-Output "User: $user"

        $activity = $userActivity[$user]
        $totalActiveTime = [timespan]::Zero
        $previousUnlockTime = $null

        foreach ($record in $activity) {
            if ($record.Action -eq "Unlocked") {
                $previousUnlockTime = $record.Time
            } elseif ($record.Action -eq "Locked" -and $previousUnlockTime) {
                $activeDuration = $record.Time - $previousUnlockTime
                $totalActiveTime += $activeDuration
                Write-Output "Active from $previousUnlockTime to $record.Time (Duration: $activeDuration)"
                $previousUnlockTime = $null
            }
        }

        Write-Output "Total active time for $user: $totalActiveTime"
    }
} else {
    Write-Output "No activity records found in the last 7 days."
    exit 1
}

Write-Output "User activity tracking completed for the last 7 days."
exit 0
