#!/bin/bash
# Quick launch script for MultiSales Firebase App

echo "🔥 MultiSales Firebase App Launcher"
echo "===================================="
echo ""
echo "Launching Flutter web app with Firebase integration..."
echo "Project: multisales-18e57"
echo "Port: 3000"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Launch the app
flutter run -d chrome --web-port=3000

echo ""
echo "✅ App launched successfully!"
echo "📱 Access your app at: http://localhost:3000"
echo "🧪 Test Firebase at: file://$(pwd)/firebase_test.html"
echo "📊 Firebase Console: https://console.firebase.google.com/project/multisales-18e57"
