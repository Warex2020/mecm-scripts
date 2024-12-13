# Schedule a random reboot between 00:00 and 04:00

# Generate a random time in seconds (between 00:00 and 04:00)
$randomSeconds = Get-Random -Minimum 0 -Maximum 14400  # 4 hours in seconds

# Calculate the scheduled time
$scheduledTime = (Get-Date).Date.AddSeconds($randomSeconds)

# Ensure the reboot is scheduled for the next day if it's already past the random time
if ($scheduledTime -lt (Get-Date)) {
    $scheduledTime = $scheduledTime.AddDays(1)
}

# Convert the time to shutdown.exe compatible format
$delayInSeconds = ($scheduledTime - (Get-Date)).TotalSeconds

# Schedule the reboot
shutdown.exe /r /t $delayInSeconds /c "Scheduled random reboot between 00:00 and 04:00."
Write-Output "Reboot scheduled at: $scheduledTime (in approximately $delayInSeconds seconds)."
exit 0
