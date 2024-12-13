# Pending updates: Total number is displayed in the first line with dynamic status codes
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search("IsHidden=0 and IsInstalled=0")

if ($SearchResult.Updates.Count -gt 0) {
    Write-Output "Pending updates: $($SearchResult.Updates.Count)"
    foreach ($Update in $SearchResult.Updates) {
        Write-Output "Title: $($Update.Title), Description: $($Update.Description)"
    }
    # Exit code 1 indicates pending updates found
    exit 1
} else {
    Write-Output "No pending updates: 0"
    # Exit code 0 indicates no updates found
    exit 0
}
