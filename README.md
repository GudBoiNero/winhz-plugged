A powershell script that automatically sets your framerate whenever you plug or unplug your laptop from power.

Useful for gaming laptops that don't automatically change framerates when on battery.

## Setup

-   Open up _Task Scheduler_ on windows and add a new task.
-   Make it run on startup and ensure it runs this command `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
-   With the arguments field set as `-NoProfile -ExecutionPolicy Bypass -File "C:\Program Files (x86)\BatteryRefreshLaptopMonitorScript\BatteryRefreshLaptopMonitor.ps1" -HzOnBattery 60 -HzOnPlug 165`

> You can change the location of the script `"C:\Program Files (x86)\BatteryRefreshLaptopMonitorScript\BatteryRefreshLaptopMonitor.ps1"` if you want. It doesn't matter, just make sure the `-File "FilePath"` argument is correct.
>
> Also make sure you don't forget
