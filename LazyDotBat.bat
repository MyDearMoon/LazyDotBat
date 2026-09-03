@echo off
setlocal EnableExtensions
title LazyDotBat - Windows Optimization and Diagnostics

:: Ensure working directory is the script root
cd /d "%~dp0"

:: ── Elevation Check & Auto-Elevate ──────────────────────────────────────────
if /i "%~1"=="--no-admin" goto :skip_admin_check
if "%LAZYDOTBAT_NO_ADMIN%"=="1" goto :skip_admin_check

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Administrator privileges required. Attempting elevation...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >nul 2>&1
    if %errorlevel% neq 0 (
        echo [!] Elevation failed or was cancelled.
        echo     Please right-click "%~nx0" and select "Run as administrator".
        pause
    )
    exit /b
)
:skip_admin_check

:: ── Colors ──────────────────────────────────────────────────────────────────
for /f %%a in ('echo prompt $E ^| cmd') do set ESC=%%a
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"
set "CYAN=%ESC%[36m"
set "BLUE=%ESC%[34m"
set "MAGENTA=%ESC%[35m"
set "WHITE=%ESC%[97m"
set "GRAY=%ESC%[90m"
set "BOLD=%ESC%[1m"
set "RESET=%ESC%[0m"

:menu
cls
echo %CYAN%================================================================================%RESET%
echo %BOLD%%WHITE%                          LazyDotBat - Master Control%RESET%
echo %GRAY%               Windows System Maintenance ^& Diagnostic Suite%RESET%
echo %CYAN%================================================================================%RESET%
echo.
echo  %BOLD%%MAGENTA%[TOOLS ^& OPTIMIZATIONS]%RESET%
echo   %CYAN%[ 1]%RESET% Disk Cleaner               %CYAN%[ 6]%RESET% GPU Driver Reset
echo   %CYAN%[ 2]%RESET% RAM Flush (Standby Cache)  %CYAN%[ 7]%RESET% Restart Audio Service
echo   %CYAN%[ 3]%RESET% Network Stack Boost        %CYAN%[ 8]%RESET% Printer Spooler Fix
echo   %CYAN%[ 4]%RESET% Boost for Gaming (Toggle)  %CYAN%[ 9]%RESET% Peripheral Driver Reset
echo   %CYAN%[ 5]%RESET% Disable Windows Bloat
echo.
echo  %BOLD%%MAGENTA%[INFO ^& AUDITS]%RESET%
echo   %CYAN%[10]%RESET% Full System Overview      %CYAN%[13]%RESET% Open Ports ^& Abuse Check
echo   %CYAN%[11]%RESET% Physical Disk Health      %CYAN%[14]%RESET% Security Posture Audit
echo   %CYAN%[12]%RESET% Network Info ^& Ping Test
echo.
echo  %BOLD%%MAGENTA%[QUICK ACTIONS]%RESET%
echo   %YELLOW%[ A]%RESET% Run Full System Diagnostics Suite (10 - 14)
echo   %RED%[ Q]%RESET% Exit LazyDotBat
echo.
echo %CYAN%================================================================================%RESET%
echo.
set "choice="
set /p "choice=%BOLD%%WHITE%Enter your choice:%RESET% "

if not defined choice goto :menu

if /i "%choice%"=="1"  call :run_tool "%~dp0bat\tools\disk_cleaner.bat" & goto :menu
if /i "%choice%"=="2"  call :run_tool "%~dp0bat\tools\ram_flush.bat" & goto :menu
if /i "%choice%"=="3"  call :run_tool "%~dp0bat\tools\network_boost.bat" & goto :menu
if /i "%choice%"=="4"  call :run_tool "%~dp0bat\tools\boost_for_gaming.bat" & goto :menu
if /i "%choice%"=="5"  call :run_tool "%~dp0bat\tools\disable_windows_junk.bat" & goto :menu
if /i "%choice%"=="6"  call :run_tool "%~dp0bat\tools\gpu_reset.bat" & goto :menu
if /i "%choice%"=="7"  call :run_tool "%~dp0bat\tools\restart_audio.bat" & goto :menu
if /i "%choice%"=="8"  call :run_tool "%~dp0bat\tools\printer_fix.bat" & goto :menu
if /i "%choice%"=="9"  call :run_tool "%~dp0bat\tools\peripheral_reset.bat" & goto :menu

if /i "%choice%"=="10" call :run_tool "%~dp0bat\info\system_info.bat" & goto :menu
if /i "%choice%"=="11" call :run_tool "%~dp0bat\info\disk_health.bat" & goto :menu
if /i "%choice%"=="12" call :run_tool "%~dp0bat\info\network_info.bat" & goto :menu
if /i "%choice%"=="13" call :run_tool "%~dp0bat\info\open_ports.bat" & goto :menu
if /i "%choice%"=="14" call :run_tool "%~dp0bat\info\security_audit.bat" & goto :menu

if /i "%choice%"=="A"  goto :run_all_audits
if /i "%choice%"=="Q"  goto :quit
if /i "%choice%"=="0"  goto :quit

echo %RED%[!] Invalid option '%choice%'. Please select an option from the menu.%RESET%
ping 127.0.0.1 -n 2 >nul 2>&1
goto :menu

:run_tool
cls
if not exist "%~1" (
    echo %RED%[!] Target script not found: "%~1"%RESET%
    pause
    exit /b
)
call "%~1"
exit /b

:run_all_audits
cls
echo %CYAN%================================================================================%RESET%
echo %BOLD%%WHITE%                       Running Full Diagnostics Suite%RESET%
echo %CYAN%================================================================================%RESET%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat\ps1\system_info.ps1"
echo.
echo %CYAN%------------------------------------------------------------------------%RESET%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat\ps1\disk_health.ps1"
echo.
echo %CYAN%------------------------------------------------------------------------%RESET%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat\ps1\network_info.ps1"
echo.
echo %CYAN%------------------------------------------------------------------------%RESET%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat\ps1\open_ports.ps1"
echo.
echo %CYAN%------------------------------------------------------------------------%RESET%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat\ps1\security_audit.ps1"
echo.
echo %GREEN%[+] All diagnostics completed.%RESET%
pause
goto :menu

:quit
cls
echo %GREEN%Thank you for using LazyDotBat! Goodbye.%RESET%
ping 127.0.0.1 -n 2 >nul 2>&1
exit /b
