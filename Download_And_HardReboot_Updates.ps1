# Download available updates via Software Center and initiate a hard reboot
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsHidden=0 and IsInstalled=0")

if ($SearchResult.Updates.Count -gt 0) {
    Write-Output "Downloading updates: $($SearchResult.Updates.Count) available."
    $UpdateDownloader = $UpdateSession.CreateUpdateDownloader()
    $UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl

    foreach ($Update in $SearchResult.Updates) {
        $UpdatesToDownload.Add($Update) | Out-Null
    }

    $UpdateDownloader.Updates = $UpdatesToDownload
    $DownloadResult = $UpdateDownloader.Download()

    if ($DownloadResult.ResultCode -eq 2) { # 2 = wuDRCompleted
        Write-Output "Updates downloaded successfully. Initiating hard reboot."
        shutdown.exe /r /t 0 /f /c "System is restarting immediately after updates download."
        exit 0
    } else {
        Write-Output "Error during download. Result code: $($DownloadResult.ResultCode)"
        exit 1
    }
} else {
    Write-Output "No updates available to download."
    exit 0
}
