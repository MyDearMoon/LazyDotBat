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

echo %CYAN%=== Printer Fix ===%RESET%
echo.

echo %CYAN%[*] Stopping print spooler...%RESET%
net stop spooler /y >nul 2>&1
echo %GREEN%    Done.%RESET%

echo %CYAN%[*] Clearing stuck print jobs...%RESET%
del /f /q "%systemroot%\System32\spool\PRINTERS\*.*" >nul 2>&1
echo %GREEN%    Done.%RESET%

echo %CYAN%[*] Starting print spooler...%RESET%
net start spooler >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%    Spooler failed to start. Try rebooting the PC.%RESET%
) else (
    echo %GREEN%    Done.%RESET%
)
echo.

echo %CYAN%[*] Installed printers:%RESET%
powershell -NoProfile -Command "Get-Printer | Sort-Object Name | Format-Table Name, DriverName, PrinterStatus -AutoSize"

set /p c_test="%YELLOW%[?] Print a test page on the default printer? (y/n): %RESET%"
if /i "%c_test%"=="y" (
    powershell -NoProfile -Command "Get-CimInstance Win32_Printer -Filter 'Default=true' | Invoke-CimMethod -MethodName PrintTestPage | Out-Null"
    echo %GREEN%[+] Test page sent.%RESET%
)

echo.
echo %GREEN%[+] Printer fix complete. Try printing again.%RESET%
pause
