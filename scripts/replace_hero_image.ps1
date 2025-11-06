# Script: replace_hero_image.ps1
# Recherche et remplace toutes les occurrences de hero_home.webp par hero_bg.jpg
# Utilisation :
#   pwsh -File .\scripts\replace_hero_image.ps1 -ProjectRoot C:\multisales_app

param(
  [string]$ProjectRoot = "C:\multisales_app",
  [string]$Old = "hero_home.webp",
  [string]$New = "hero_bg.jpg",
  [string[]]$IncludePatterns = @('*.dart','*.html','*.js','*.css','*.yaml','*.json','*.md'),
  [string[]]$ExcludeDirNames = @('.git','.dart_tool','build','node_modules','android\\build','ios\\Runner.xcodeproj','ios\\Runner.xcworkspace','macos\\Runner.xcworkspace','.idea','.vscode','web\\icons','linux\\flutter','windows\\flutter'),
  [switch]$DryRun,
  [switch]$Backup,
  [switch]$FailOnMatch
)

# Ensure UTF-8 console output for accented characters on Windows
try {
  # Switch console code page to UTF-8 for legacy hosts
  chcp 65001 | Out-Null
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  $OutputEncoding = [System.Text.UTF8Encoding]::new()
} catch { }

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
  Write-Host "Chemin introuvable: $ProjectRoot" -ForegroundColor Red
  exit 1
}

# Allow comma-separated IncludePatterns passed as a single string
if ($IncludePatterns.Count -eq 1 -and $IncludePatterns[0] -match ',') {
  $IncludePatterns = $IncludePatterns[0] -split '\s*,\s*'
}

Set-Location -LiteralPath $ProjectRoot

# Build an exclusion regex to skip large or generated folders
$escapedExcludes = $ExcludeDirNames | ForEach-Object { [regex]::Escape($_) }
$excludeRegex = '(?i)(?:' + ($escapedExcludes -join '|') + ')(?:$|[\\/])'

# Affiche les occurrences d'abord
Write-Host "Occurrences actuelles de '$Old':" -ForegroundColor Cyan
$searchFiles = Get-ChildItem -Path $ProjectRoot -Recurse -File -Include $IncludePatterns |
  Where-Object { $_.FullName -notmatch $excludeRegex }
$foundMatches = @()
foreach ($f in $searchFiles) {
  try {
    $m = Select-String -Path $f.FullName -Pattern $Old -List -ErrorAction Stop
    if ($m) { $foundMatches += $m }
  } catch { }
}
if ($foundMatches.Count -eq 0) {
  Write-Host " - Aucune occurrence trouvee" -ForegroundColor Yellow
} else {
  $foundMatches | ForEach-Object { $_.Path } | Sort-Object -Unique | ForEach-Object { Write-Host " - $_" }
}

# Remplacement controle
$files = Get-ChildItem -Path $ProjectRoot -Recurse -File -Include $IncludePatterns |
  Where-Object { $_.FullName -notmatch $excludeRegex }

$totalChanges = 0
$writeErrors = 0
foreach ($f in $files) {
  try {
    $content = Get-Content -Raw -LiteralPath $f.FullName -ErrorAction Stop
  } catch {
  Write-Host "Ignore (lecture impossible): $($f.FullName)" -ForegroundColor DarkYellow
    continue
  }

  if ($content -match [regex]::Escape($Old)) {
    $newContent = $content -replace [regex]::Escape($Old), $New
    if ($DryRun) {
      Write-Host "(DryRun) Remplacement prevu dans: $($f.FullName)" -ForegroundColor Cyan
    } else {
      try {
        if ($Backup) {
          Copy-Item -LiteralPath $f.FullName -Destination ($f.FullName + '.bak') -Force -ErrorAction SilentlyContinue
        }
        Set-Content -LiteralPath $f.FullName -Value $newContent -NoNewline -Encoding UTF8
        Write-Host "Remplace dans: $($f.FullName)" -ForegroundColor Green
        $totalChanges++
      } catch {
        Write-Host "Erreur d'ecriture: $($f.FullName) - $($_.Exception.Message)" -ForegroundColor Red
        $writeErrors++
      }
    }
  }
}

if ($DryRun) {
  Write-Host "DryRun termine. Aucune modification ecrite." -ForegroundColor Cyan
} else {
  Write-Host "Termine. Fichiers modifies: $totalChanges" -ForegroundColor Green
}

Write-Host "Relance 'flutter clean' puis 'flutter pub get' si des assets ont change." -ForegroundColor Magenta

# Exit codes: 0 ok, 1 I/O errors, 2 matches found when -FailOnMatch is set
if ($writeErrors -gt 0) {
  $host.SetShouldExit(1)
} elseif ($FailOnMatch -and $foundMatches.Count -gt 0) {
  $host.SetShouldExit(2)
} else {
  $host.SetShouldExit(0)
}
