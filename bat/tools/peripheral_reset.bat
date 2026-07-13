@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] This script must be run as Administrator.
    echo     Right-click the file and select "Run as administrator".
    pause
    exit /b
)

:: ── Colors ──
for /f %%a in ('echo prompt $E ^| cmd') do set ESC=%%a
set GREEN=%ESC%[32m
set RED=%ESC%[31m
set YELLOW=%ESC%[33m
set CYAN=%ESC%[36m
set RESET=%ESC%[0m

echo %CYAN%=== Peripheral Reset ===%RESET%
echo Restarts keyboard, mouse, and other input device drivers to fix
echo unresponsive or glitchy peripherals without rebooting.
echo.
echo %YELLOW%[!] Your keyboard and mouse may freeze for a few seconds while drivers reload.%RESET%
set /p go="%YELLOW%[?] Continue? (y/n): %RESET%"
if /i not "%go%"=="y" exit /b
echo.

echo %CYAN%[*] Re-scanning for hardware changes...%RESET%
pnputil /scan-devices >nul 2>&1
echo %GREEN%    Done.%RESET%

echo %CYAN%[*] Restarting keyboard and mouse drivers...%RESET%
powershell -NoProfile -Command "Get-PnpDevice -Class Mouse,Keyboard -Status OK -ErrorAction SilentlyContinue | Restart-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue"
echo %GREEN%    Done.%RESET%

echo %CYAN%[*] Restarting other HID devices (touchscreens, controllers)...%RESET%
powershell -NoProfile -Command "Get-PnpDevice -Class HIDClass -Status OK -ErrorAction SilentlyContinue | Restart-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue"
echo %GREEN%    Done.%RESET%

echo %CYAN%[*] Restarting Bluetooth service...%RESET%
sc query bthserv >nul 2>&1
if %errorlevel% equ 0 (
    net stop bthserv /y >nul 2>&1
    net start bthserv >nul 2>&1
    echo %GREEN%    Done.%RESET%
) else (
    echo %YELLOW%    No Bluetooth service on this PC, skipped.%RESET%
)

echo %CYAN%[*] Restarting device pairing service...%RESET%
net stop DeviceAssociationService /y >nul 2>&1
net start DeviceAssociationService >nul 2>&1
echo %GREEN%    Done.%RESET%

echo.
echo %GREEN%[+] Peripherals reset. If a device still doesn't work, unplug it,%RESET%
echo %GREEN%    wait 5 seconds, and plug it back in.%RESET%
pause
