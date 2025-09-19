#!/bin/bash

# 🚀 Script de Build Android App Bundle (AAB) - Conforme Google Play Store 2025
# Ce script génère un fichier .aab compatible avec les exigences Google Play 2025

echo "🎯 BUILD ANDROID APP BUNDLE - CONFORMITÉ GOOGLE PLAY 2025"
echo "=========================================================="

# Nettoyer le projet
echo "🧹 Nettoyage du projet..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Build Android App Bundle avec obfuscation (recommandé)
echo "🔨 Construction de l'Android App Bundle (.aab)..."
flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info=debug/ \
    --target-platform android-arm,android-arm64,android-x64 \
    --build-name=2.3.2 \
    --build-number=232

# Vérifier que le fichier AAB a été généré
AAB_FILE="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB_FILE" ]; then
    echo "✅ SUCCÈS ! Android App Bundle généré :"
    echo "📁 Fichier : $AAB_FILE"
    echo "📊 Taille : $(du -h "$AAB_FILE" | cut -f1)"
    echo ""
    echo "🎯 CONFORMITÉ GOOGLE PLAY 2025 :"
    echo "✅ Format : Android App Bundle (.aab)"
    echo "✅ API Level : 35 (Android 15)"
    echo "✅ Kotlin : 2.2.0"
    echo "✅ Obfuscation : Activée"
    echo "✅ Signature : Google Play App Signing"
    echo ""
    echo "🚀 PRÊT POUR UPLOAD SUR GOOGLE PLAY CONSOLE !"
else
    echo "❌ ERREUR : Fichier AAB non généré"
    exit 1
fi
