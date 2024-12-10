function Set-RefreshRate {
    param (
        [int]$Rate = 60
    )

    # Check if NirCmd is present
    if (-Not (Test-Path "./nircmd.exe")) {
        Write-Host "NirCmd not found. Ensure it is in the script directory or in PATH."
        return
    }

    # Set the refresh rate for the primary monitor using NirCmd
    $resolution = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth, ScreenHeight
    $monitor = Get-WmiObject -Class Win32_DisplayControllerConfiguration
    $bits = $monitor.BitsPerPixel
    $process = Start-Process -FilePath "./nircmd.exe" -ArgumentList "setdisplay $($resolution.ScreenWidth) $($resolution.ScreenHeight) $bits $Rate" -NoNewWindow -Wait
    if ($process.ExitCode -eq 0) {
        Write-Host "Refresh rate set to $Rate Hz."
    }
    else {
        Write-Host "Failed to set refresh rate to $Rate Hz. Error Code: $($process.ExitCode)"
    }
}

function Get-PluggedIn {
    $battery = Get-WmiObject Win32_Battery
    if ($battery.BatteryStatus -eq 2) {
        return $true
    }
    return $false
}

# Main script logic
Write-Host "Listening for power state changes. Press Ctrl+C to exit."
$last_pluggedIn = Get-PluggedIn

while ($true) {
    $pluggedIn = Get-PluggedIn
    # Determine refresh rate based on power state
    $refreshRate = if ($pluggedIn) { $HzOnPlug } else { $HzOnBattery }

    if (-not $refreshRate) { 
        Write-Host "Parameters -HzOnPlug and -HzOnBattery are required and must be non zero."
        break 
    }

    if ($last_pluggedIn -ne $pluggedIn) {
        Set-RefreshRate -Rate $refreshRate
    }

    $last_pluggedIn = $pluggedIn
}
