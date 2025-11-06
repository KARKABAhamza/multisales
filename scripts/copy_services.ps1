# Script PowerShell : copie et normalise les images depuis le dossier source vers le projet Flutter
# ADAPTE les deux variables $srcRoot et $projectRoot avant d'exécuter.
$srcRoot = "C:\Users\HP\Desktop\Multisales\multisales PHOTO"
$projectRoot = "C:\multisales_app"   # <-- racine de ton projet Flutter
$dest = Join-Path $projectRoot "assets\images\services"

Write-Host "Source: $srcRoot"
Write-Host "Destination: $dest"

# Crée le dossier destination si nécessaire
if (-not (Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    Write-Host "Created $dest"
}

# Liste des fichiers attendus dans le dossier source (tel que visible sur ta capture)
$files = @(
  "Gants.jpg",
  "MREF.jpg",
  "mref0.jpg",
  "MREF1.jpg",
  "MREF2.jpg",
  "MREF3.jpg",
  "MREF4.jpg",
  "MREF5.jpg",
  "MREF6.jpg",
  "MREF7.jpg",
  "MREF8.jpg",
  "MREF9.jpg",
  "MREF10.jpg",
  "MREF11.jpg",
  "MREF12.jpg",
  "MREF13.jpg",
  "MREF14.jpg",
  "refM.jpg"
)

foreach ($f in $files) {
    $src = Join-Path $srcRoot $f
    if (Test-Path $src) {
        # normaliser en minuscules pour éviter les problèmes de casse en production web
        $destName = $f.ToLower()
        $destPath = Join-Path $dest $destName
        Copy-Item -Force -Path $src -Destination $destPath
        Write-Host "Copied: $f -> $destPath"
    } else {
        Write-Warning "Missing source file: $src"
    }
}
