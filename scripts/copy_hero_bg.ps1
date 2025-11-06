# Script: copy_hero_bg.ps1
# Copie MREF1.jpg vers assets/images/hero_bg.jpg
# Modifie $srcRoot si ton dossier source est différent.

param(
  [string]$SrcRoot = "C:\Users\HP\Desktop\Multisales\multisales PHOTO",
  [string]$ProjectRoot = "C:\multisales_app",
  [string]$SrcName = "MREF1.jpg"
)

$src = Join-Path $SrcRoot $SrcName
$destDir = Join-Path $ProjectRoot "assets\images"
$destFile = Join-Path $destDir "hero_bg.jpg"

if (-not (Test-Path $src)) {
  Write-Host "Source file not found: $src" -ForegroundColor Red
  Write-Host "Liste des fichiers dans $SrcRoot :" -ForegroundColor Yellow
  Get-ChildItem -Path $SrcRoot -File | ForEach-Object { Write-Host $_.Name }
  exit 1
}

if (-not (Test-Path $destDir)) {
  New-Item -ItemType Directory -Path $destDir -Force | Out-Null
  Write-Host "Created $destDir"
}

Copy-Item -Force -Path $src -Destination $destFile
Write-Host "Copied $SrcName -> $destFile" -ForegroundColor Green

Write-Host ""
Write-Host "Ensuite, à la racine du projet exécute :"
Write-Host "  flutter clean"
Write-Host "  flutter pub get"
Write-Host "  flutter run -d chrome --web-port=3000"
