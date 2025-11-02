@echo off
echo ========================================
echo Chay ung dung tren Web Browser
echo ========================================
echo.

echo Chon trinh duyet:
echo 1. Chrome
echo 2. Edge
echo.
set /p choice="Nhap lua chon (1 hoac 2): "

if "%choice%"=="1" (
    echo Chay tren Chrome...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo Chay tren Edge...
    flutter run -d edge
) else (
    echo Lua chon khong hop le!
    pause
    exit
)

pause
