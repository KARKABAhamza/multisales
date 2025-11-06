# PowerShell script to copy and normalize your logo/product images into the Flutter project
# Edit $src if your source folder differs

param(
  [string]$src = "C:\\Users\\HP\\Desktop\\Multisales\\multisales PHOTO",
  [string]$dest = "${PSScriptRoot}\\..\\assets\\images\\logos"
)

Write-Host "Source: $src"
Write-Host "Destination: $dest"

New-Item -ItemType Directory -Force -Path $dest | Out-Null

$filesMap = @{
  "Gants.jpg" = "gants.jpg"
  "MREF.jpg" = "mref.jpg"
  "MREF1.jpg" = "mref1.jpg"
  "MREF2.jpg" = "mref2.jpg"
  "MREF3.jpg" = "mref3.jpg"
  "MREF4.jpg" = "mref4.jpg"
  "MREF5.jpg" = "mref5.jpg"
  "MREF6.jpg" = "mref6.jpg"
  "MREF7.jpg" = "mref7.jpg"
  "MREF8.jpg" = "mref8.jpg"
  "MREF9.jpg" = "mref9.jpg"
  "MREF10.jpg" = "mref10.jpg"
  "MREF11.jpg" = "mref11.jpg"
  "MREF12.jpg" = "mref12.jpg"
  "MREF13.jpg" = "mref13.jpg"
  "MREF14.jpg" = "mref14.jpg"
  "mref0.jpg" = "mref0.jpg"
}

foreach ($kvp in $filesMap.GetEnumerator()) {
  $srcPath = Join-Path $src $($kvp.Key)
  if (Test-Path $srcPath) {
    $destPath = Join-Path $dest $($kvp.Value)
    Copy-Item -Force -Path $srcPath -Destination $destPath
    Write-Host "Copied: `t$srcPath`t=> $destPath"
  } else {
    Write-Warning "Source not found: $srcPath"
  }
}

Write-Host "\nImport terminé. Vérifiez les images et relancez votre app Flutter."
