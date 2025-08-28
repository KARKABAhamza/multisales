# PowerScript to configure FlutterFire for MultiSales project
Write-Host "Configuring FlutterFire for MultiSales project..." -ForegroundColor Green
Write-Host ""

# Add Pub Cache bin to PATH for this session only
$env:PATH += ";C:\Users\HP\AppData\Local\Pub\Cache\bin"

Write-Host "Checking if flutterfire is available..." -ForegroundColor Yellow
try {
    & flutterfire --version
    Write-Host ""
    Write-Host "Running FlutterFire configure..." -ForegroundColor Yellow
    & flutterfire configure --project=multisales-18e57
    Write-Host ""
    Write-Host "Configuration complete!" -ForegroundColor Green
    Write-Host "You can now run: flutter run" -ForegroundColor Cyan
} catch {
    Write-Host "Error: FlutterFire CLI not found in PATH" -ForegroundColor Red
    Write-Host "Please add C:\Users\HP\AppData\Local\Pub\Cache\bin to your system PATH" -ForegroundColor Yellow
    Write-Host "Or run this command directly:" -ForegroundColor Yellow
    Write-Host "C:\Users\HP\AppData\Local\Pub\Cache\bin\flutterfire configure --project=multisales-18e57" -ForegroundColor Cyan
}

Read-Host "Press Enter to continue..."
