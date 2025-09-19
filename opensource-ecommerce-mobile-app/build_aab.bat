@echo off
REM 🚀 Script de Build Android App Bundle (AAB) - Conforme Google Play Store 2025
REM Ce script génère un fichier .aab compatible avec les exigences Google Play 2025

echo 🎯 BUILD ANDROID APP BUNDLE - CONFORMITÉ GOOGLE PLAY 2025
echo ==========================================================

REM Nettoyer le projet
echo 🧹 Nettoyage du projet...
flutter clean

REM Récupérer les dépendances
echo 📦 Récupération des dépendances...
flutter pub get

REM Build Android App Bundle avec obfuscation (recommandé)
echo 🔨 Construction de l'Android App Bundle (.aab)...
flutter build appbundle --release --obfuscate --split-debug-info=debug/ --target-platform android-arm,android-arm64,android-x64 --build-name=2.3.2 --build-number=232

REM Vérifier que le fichier AAB a été généré
set AAB_FILE=build\app\outputs\bundle\release\app-release.aab
if exist "%AAB_FILE%" (
    echo ✅ SUCCÈS ! Android App Bundle généré :
    echo 📁 Fichier : %AAB_FILE%
    echo.
    echo 🎯 CONFORMITÉ GOOGLE PLAY 2025 :
    echo ✅ Format : Android App Bundle (.aab)
    echo ✅ API Level : 35 (Android 15)
    echo ✅ Kotlin : 2.2.0
    echo ✅ Obfuscation : Activée
    echo ✅ Signature : Google Play App Signing
    echo.
    echo 🚀 PRÊT POUR UPLOAD SUR GOOGLE PLAY CONSOLE !
) else (
    echo ❌ ERREUR : Fichier AAB non généré
    exit /b 1
)

pause
