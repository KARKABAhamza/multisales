@echo off
title MultiSales Firebase App Launcher
echo =================================================
echo 🔥 MULTISALES FIREBASE APPLICATION
echo =================================================
echo.
echo Project: multisales-18e57
echo Firebase SDKs: Analytics, Auth, Firestore, Storage,
echo               Crashlytics, Performance, Remote Config, Messaging
echo.
echo =================================================
echo Choisissez une option:
echo =================================================
echo.
echo 1. Lancer l'application web (Chrome)
echo 2. Lancer l'application Android (émulateur)
echo 3. Tester Firebase dans le navigateur
echo 4. Analyser le code
echo 5. Construire l'application
echo 6. Voir les logs Firebase
echo 7. Quitter
echo.
set /p choice="Entrez votre choix (1-7): "

if "%choice%"=="1" (
    echo.
    echo 🚀 Lancement de l'application web...
    flutter run -d chrome --web-port=3000
    goto end
)

if "%choice%"=="2" (
    echo.
    echo 📱 Lancement sur l'émulateur Android...
    flutter run -d android
    goto end
)

if "%choice%"=="3" (
    echo.
    echo 🧪 Ouverture de la page de test Firebase...
    start firebase_test.html
    goto end
)

if "%choice%"=="4" (
    echo.
    echo 🔍 Analyse du code en cours...
    flutter analyze
    pause
    goto end
)

if "%choice%"=="5" (
    echo.
    echo 🏗️ Construction de l'application...
    echo Quelle plateforme?
    echo 1. Web
    echo 2. Android APK
    echo 3. Les deux
    set /p build_choice="Choix: "

    if "%build_choice%"=="1" (
        flutter build web
    ) else if "%build_choice%"=="2" (
        flutter build apk
    ) else if "%build_choice%"=="3" (
        flutter build web
        flutter build apk
    )

    echo ✅ Construction terminée!
    pause
    goto end
)

if "%choice%"=="6" (
    echo.
    echo 📊 Informations Firebase:
    echo.
    echo Project ID: multisales-18e57
    echo Analytics ID: G-3DB4WDLJ7X
    echo Web API Key: AIzaSyBz4EfU40riAMXt3sdKFFFq5Lc_X5W6WGQ
    echo.
    echo Services configurés:
    echo ✅ Analytics
    echo ✅ Authentication
    echo ✅ Firestore
    echo ✅ Storage
    echo ✅ Crashlytics
    echo ✅ Performance
    echo ✅ Remote Config
    echo ✅ Cloud Messaging
    echo.
    echo Ouvrir la console Firebase? (o/n)
    set /p open_console=""
    if /i "%open_console%"=="o" (
        start https://console.firebase.google.com/project/multisales-18e57
    )
    pause
    goto end
)

if "%choice%"=="7" (
    echo.
    echo 👋 Au revoir!
    goto end
)

echo.
echo ❌ Choix invalide. Veuillez réessayer.
pause

:end
pause
