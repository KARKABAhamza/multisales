@echo off
echo Configuring FlutterFire for MultiSales project...
echo.

REM Add Pub Cache bin to PATH for this session only
set PATH=%PATH%;C:\Users\HP\AppData\Local\Pub\Cache\bin

echo Checking if flutterfire is available...
flutterfire --version
if %errorlevel% neq 0 (
    echo Error: FlutterFire CLI not found in PATH
    echo Please add C:\Users\HP\AppData\Local\Pub\Cache\bin to your system PATH
    pause
    exit /b 1
)

echo.
echo Running FlutterFire configure...
flutterfire configure --project=multisales-18e57

echo.
echo Configuration complete!
echo You can now run: flutter run
pause
