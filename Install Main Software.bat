@echo off

echo This tool will automatically download all of aaronfranke's preferred 
echo software via opening the download links in your web browser.
echo.
echo Note: Not all software is included on this installer list. 
echo Visit the folders to manually download other programs.
echo.
echo WINDOWS XP USERS PLEASE READ THIS!
echo.
echo I highly recommend that you install the Unofficial Service Pack 4, for 
echo Windows XP 32-bit systems only. Includes updates through April 2019 from 
echo POSReady 2009. Please ensure Service Pack 3 is installed prior to this.
echo.
echo If you are using Windows XP 64-bit, then your system is no longer supported. 
echo Only the 32-bit version is supported with this trick until April 2019. 
echo.
echo If you are running unsupported Windows XP, consider switching to Linux.
echo.

pause

cd "Software"
echo.
echo Beginning automatic download of software...
echo.

cd "Web Browsers"
echo Downloading Web Browsers...
    "Chrome.url"
    "Firefox.url"
    "Opera.url"
cd ..

pause
echo.

cd "Essential Libraries"
echo Downloading Essential Libraries...
    "DirectX Runtime.url"
    "OpenSSL.url"
    "Java.url"
cd ..

pause
echo.

cd "Piriform Tools"
echo Downloading the Piriform tools...
    "Piriform Speccy.url"
    "Piriform CCleaner.url"
    "Piriform Defraggler.url"
cd ..

pause
echo.

cd "Security"
echo Downloading Security software...
    "Malwarebytes Anti-Malware.url"
cd ..

pause
echo.

cd "Document Management"
echo Downloading Document Management programs...
    "Dropbox.url"
    "Notepad++.url"
    "LibreOffice.url"
    "7-Zip.url"
cd ..

pause
echo.

cd "Media"
echo Downloading Media programs...
    "VLC Media Player.url"
    "GIMP.url"
cd ..

pause
echo.

cd "Social"
echo Downloading Social Apps...
    "Steam.url"
    "Skype.url"
cd ..

pause
echo.

cd "Remote"
echo Downloading Remote Control Software...
    "FileZilla.url"
    "Putty.url"
    "TeamViewer.url"
cd ..

pause
echo.

cd "Other"
echo Downloading Other Software...
    "0.url"
    "1.url"
    "2.url"
    "3.url"
    "4.url"
    "5.url"
    "6.url"
    "7.url"
    "8.url"
    "9.url"
cd ..

cls
echo Done!

pause


