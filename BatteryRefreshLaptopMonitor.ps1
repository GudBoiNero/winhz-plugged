function Set-RefreshRate {
    param (
        [int]$Rate
    )
    # Check if NirCmd is present
    if (-Not (Test-Path "./nircmd.exe")) {
        Write-Host "NirCmd not found. Ensure it is in the script directory or in PATH."
        return
    }
    # Set the refresh rate for the primary monitor using NirCmd
    Start-Process -FilePath "./nircmd.exe" -ArgumentList "setdisplay 1 refresh $Rate" -NoNewWindow -Wait
    if ($?) {
        Write-Host "Refresh rate set to $Rate Hz."
    }
    else {
        Write-Host "Failed to set refresh rate to $Rate Hz."
    }
}

function Get-PluggedIn {
    $battery = Get-WmiObject Win32_Battery
    if ($battery.BatteryStatus -eq 2) {
        return $true
    }
    return $false
}

Write-Host "Listening for power state changes. Press Ctrl+C to exit."
$last_pluggedIn = Get-PluggedIn
while ($true) {
    Start-Sleep -Seconds 0.5

    $pluggedIn = Get-PluggedIn
    if ($last_pluggedIn -ne $pluggedIn) {
        if ($pluggedIn) {
            Set-RefreshRate 165
        }
        else {
            Set-RefreshRate 60
        }
    }
    $last_pluggedIn = $pluggedIn
}
