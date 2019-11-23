
@echo off

for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (set version=%%j.%%k) else (set version=%%i.%%j))

echo This tool will automatically download all of aaronfranke's preferred 
echo software via opening the download links in your web browser.
echo.
echo A lot of the programs are within a Ninite wrapper for easy installation.
echo.
echo Note: Not all included links are opened by this script. 
echo Visit the folders to manually download other programs.
echo.
if "%version%" == "5.0" echo  Detected Windows version: Windows 2000 (unsupported)
if "%version%" == "5.1" echo  Detected Windows version: Windows XP (unsupported by Microsoft)
if "%version%" == "5.2" echo  Detected Windows version: Windows XP x64 (unsupported by Microsoft)
if "%version%" == "6.0" echo  Detected Windows version: Windows Vista (unsupported by Microsoft)
if "%version%" == "6.1" echo  Detected Windows version: Windows 7
if "%version%" == "6.2" echo  Detected Windows version: Windows 8.0 (unsupported by Microsoft)
if "%version%" == "6.3" echo  Detected Windows version: Windows 8.1
if "%version%" == "10.0" echo  Detected Windows version: Windows 10
echo.

rem Out-of-support warnings for various EOL Windows versions. 
if "%version%" == "5.0" echo WINDOWS 2000 USERS PLEASE READ THIS!
if "%version%" == "5.0" echo.
if "%version%" == "5.0" echo Windows 2000 is no longer supported. Please consider switching to Lubuntu.
if "%version%" == "5.0" echo This script will probably not work correctly on Windows 2000.

if "%version%" == "5.1" echo WINDOWS XP USERS PLEASE READ THIS!
if "%version%" == "5.2" echo.
if "%version%" == "5.2" echo Windows XP is no longer supported. Please consider switching to Lubuntu.
if "%version%" == "5.1" echo.
if "%version%" == "5.1" echo If that's not an option, I highly recommend that you install Unofficial
if "%version%" == "5.1" echo Service Pack 4. Includes updates through April 2019 from POSReady 2009.
if "%version%" == "5.1" echo Please ensure Service Pack 3 is installed prior to this.

if "%version%" == "5.2" echo WINDOWS XP X64 USERS PLEASE READ THIS!
if "%version%" == "5.2" echo.
if "%version%" == "5.2" echo Windows XP x64 edition is no longer supported. Please consider switching to Lubuntu.

if "%version%" == "6.0" echo WINDOWS VISTA USERS PLEASE READ THIS!
if "%version%" == "6.0" echo.
if "%version%" == "6.0" echo Windows Vista is no longer supported. Please consider switching to Xubuntu.

if "%version%" == "6.2" echo WINDOWS 8.0 USERS PLEASE READ THIS!
if "%version%" == "6.2" echo.
if "%version%" == "6.2" echo Windows 8.0 is no longer supported. Please upgrade to Windows 8.1 or Xubuntu.

echo.

pause

cd "Software"
echo.
echo Beginning automatic download of software...
echo.

echo Downloading many programs via just-install...
    "just-install.exe"

echo.
pause
echo.
echo.

cd "Piriform"
echo Downloading Piriform Tools...
    "Piriform Speccy.url"
    "Piriform Defraggler.url"
cd ..

echo.
pause
echo.
echo.

cd "Patches"
    realtimeisuniversal.reg
    if "%version%" == "5.1" "Win XP - .NET Framework 4.0.url"
    if "%version%" == "5.1" "Win XP - Unofficial Service Pack 4.url"
    if "%version%" == "5.1" "Win XP - User Profile Hive Cleanup Service.url"
    if "%version%" == "6.1" "Win 7 - Microsoft Security Essentials.url"
    if "%version%" == "6.2" "Win 8 - Classic Shell.url"
    if "%version%" == "6.3" "Win 8 - Classic Shell.url"
    if "%version%" == "10.0" start "Win10 Decrapifier PowerShell Script" PowerShell.exe -ExecutionPolicy Bypass -File "Win 10 - Decrapifier v2.ps1"
cd ..

echo.
pause
echo.
echo.

cls
echo Done!
echo.

pause


