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

echo %CYAN%=== Lab PC Reset ===%RESET%
echo Preps a shared PC for the next user: closes browsers and clears
echo leftover sessions, logins, history, temp files, and recent items.
echo.
echo %RED%[!] This will close all open browsers and sign out any saved web logins.%RESET%
set /p go="%YELLOW%[?] Continue? (y/n): %RESET%"
if /i not "%go%"=="y" exit /b
echo.

:: ── Optional extras ──────────────────────────────────────────────────────────
set /p c_dl="%YELLOW%[?] Also clear the Downloads folder? (y/n): %RESET%"
set /p c_cred="%YELLOW%[?] Also remove saved network credentials (cmdkey)? (y/n): %RESET%"
echo.

:: ── 1. Close browsers ────────────────────────────────────────────────────────
echo %CYAN%[*] Closing browsers...%RESET%
for %%p in (chrome.exe msedge.exe firefox.exe brave.exe opera.exe vivaldi.exe) do taskkill /f /im %%p >nul 2>&1
timeout /t 2 /nobreak >nul
echo %GREEN%    Done.%RESET%

:: ── 2. Clear browser sessions, logins, history, cache ────────────────────────
echo %CYAN%[*] Clearing browser data (sessions, cookies, history, saved logins)...%RESET%
call :clearchromium "%LOCALAPPDATA%\Google\Chrome\User Data\Default"
call :clearchromium "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default"
call :clearchromium "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default"
call :clearchromium "%APPDATA%\Opera Software\Opera Stable"
call :clearchromium "%LOCALAPPDATA%\Vivaldi\User Data\Default"
for /d %%p in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do call :clearfirefox "%%p"
echo %GREEN%    Done.%RESET%

:: ── 3. Clear temp folders ────────────────────────────────────────────────────
echo %CYAN%[*] Clearing temp folders...%RESET%
rd /s /q "%TEMP%" 2>nul & mkdir "%TEMP%"
rd /s /q "C:\Windows\Temp" 2>nul & mkdir "C:\Windows\Temp"
echo %GREEN%    Done.%RESET%

:: ── 4. Clear recent items and jump lists ─────────────────────────────────────
echo %CYAN%[*] Clearing recent files list...%RESET%
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1
echo %GREEN%    Done.%RESET%

:: ── 5. Clear clipboard ───────────────────────────────────────────────────────
echo %CYAN%[*] Clearing clipboard...%RESET%
echo off | clip
echo %GREEN%    Done.%RESET%

:: ── 6. Empty Recycle Bin ─────────────────────────────────────────────────────
echo %CYAN%[*] Emptying Recycle Bin...%RESET%
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo %GREEN%    Done.%RESET%

:: ── 7. Flush DNS ─────────────────────────────────────────────────────────────
echo %CYAN%[*] Flushing DNS cache...%RESET%
ipconfig /flushdns >nul 2>&1
echo %GREEN%    Done.%RESET%

:: ── 8. Optional: Downloads ───────────────────────────────────────────────────
if /i "%c_dl%"=="y" (
    rd /s /q "%USERPROFILE%\Downloads" 2>nul & mkdir "%USERPROFILE%\Downloads"
    echo %GREEN%[+] Downloads cleared.%RESET%
)

:: ── 9. Optional: saved credentials ───────────────────────────────────────────
if /i "%c_cred%"=="y" (
    for /f "tokens=1,* delims= " %%a in ('cmdkey /list ^| findstr /i "Target:"') do cmdkey /delete:%%b >nul 2>&1
    echo %GREEN%[+] Saved network credentials removed.%RESET%
)

echo.
echo %GREEN%[+] Lab PC reset complete. Ready for the next user.%RESET%
pause
exit /b

:: ── Helpers ──────────────────────────────────────────────────────────────────
:clearchromium
if not exist "%~1" exit /b
del /f /q "%~1\Cookies" "%~1\Cookies-journal" >nul 2>&1
del /f /q "%~1\History" "%~1\History-journal" >nul 2>&1
del /f /q "%~1\Login Data" "%~1\Login Data-journal" >nul 2>&1
del /f /q "%~1\Web Data" "%~1\Web Data-journal" >nul 2>&1
del /f /q "%~1\Network\Cookies" "%~1\Network\Cookies-journal" >nul 2>&1
rd /s /q "%~1\Sessions" 2>nul
rd /s /q "%~1\Cache" 2>nul
exit /b

:clearfirefox
if not exist "%~1" exit /b
del /f /q "%~1\cookies.sqlite" "%~1\cookies.sqlite-wal" >nul 2>&1
del /f /q "%~1\formhistory.sqlite" >nul 2>&1
del /f /q "%~1\logins.json" >nul 2>&1
del /f /q "%~1\sessionstore.jsonlz4" >nul 2>&1
rd /s /q "%~1\sessionstore-backups" 2>nul
rd /s /q "%~1\cache2" 2>nul
exit /b
