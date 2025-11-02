@echo off
echo ========================================
echo Chay ung dung tren Android Emulator
echo ========================================
echo.

echo Dang kiem tra emulator...
flutter emulators

echo.
echo Chon emulator:
echo 1. Medium_Phone
echo 2. flutter_emulator
echo.
set /p choice="Nhap lua chon (1 hoac 2): "

if "%choice%"=="1" (
    echo Khoi dong Medium_Phone...
    start /B flutter emulators --launch Medium_Phone
) else if "%choice%"=="2" (
    echo Khoi dong flutter_emulator...
    start /B flutter emulators --launch flutter_emulator
) else (
    echo Lua chon khong hop le!
    pause
    exit
)

echo.
echo Doi emulator khoi dong (30 giay)...
timeout /t 30 /nobreak

echo.
echo Chay ung dung...
flutter run -d android

pause
