@echo off
echo.
echo ========================================
echo   BAZAR MARKETPLACE - NETTOYAGE PHASE 2
echo   Suppression des doublons critiques
echo ========================================
echo.

REM Sauvegarde
echo [1/4] Creation de la sauvegarde...
git checkout -b cleanup-phase2-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%
if %errorlevel% neq 0 (
    echo ERREUR: Impossible de creer la branche de sauvegarde
    pause
    exit /b 1
)

REM Suppression ecrans home doublons
echo [2/4] Suppression des ecrans home doublons...
if exist "lib\screens\home_page\home_page.dart" (
    echo   - Suppression: home_page.dart
    del /f /q "lib\screens\home_page\home_page.dart"
)
if exist "lib\screens\home_page\simple_glassmorphic_home.dart" (
    echo   - Suppression: simple_glassmorphic_home.dart
    del /f /q "lib\screens\home_page\simple_glassmorphic_home.dart"
)
if exist "lib\screens\home_page\glassmorphic_home_page.dart" (
    echo   - Suppression: glassmorphic_home_page.dart
    del /f /q "lib\screens\home_page\glassmorphic_home_page.dart"
)

REM Suppression composants glassmorphic doublons
echo [3/4] Suppression des composants glassmorphic doublons...
if exist "lib\widgets\glassmorphic_appbar_simple.dart" (
    echo   - Suppression: glassmorphic_appbar_simple.dart
    del /f /q "lib\widgets\glassmorphic_appbar_simple.dart"
)
if exist "lib\widgets\glassmorphism_app_bar.dart" (
    echo   - Suppression: glassmorphism_app_bar.dart
    del /f /q "lib\widgets\glassmorphism_app_bar.dart"
)
if exist "lib\widgets\glassmorphism\glassmorphic_appbar.dart" (
    echo   - Suppression: glassmorphic_appbar.dart
    del /f /q "lib\widgets\glassmorphism\glassmorphic_appbar.dart"
)
if exist "lib\widgets\glassmorphism\glassmorphic_button.dart" (
    echo   - Suppression: glassmorphic_button.dart
    del /f /q "lib\widgets\glassmorphism\glassmorphic_button.dart"
)
if exist "lib\widgets\glassmorphism\glassmorphic_button_clean.dart" (
    echo   - Suppression: glassmorphic_button_clean.dart
    del /f /q "lib\widgets\glassmorphism\glassmorphic_button_clean.dart"
)

REM Suppression themes doublons
echo [4/4] Suppression des themes doublons...
if exist "lib\utils\mobikul_theme.dart" (
    echo   - Suppression: mobikul_theme.dart
    del /f /q "lib\utils\mobikul_theme.dart"
)
if exist "lib\utils\glassmorphism_theme.dart" (
    echo   - Suppression: glassmorphism_theme.dart
    del /f /q "lib\utils\glassmorphism_theme.dart"
)
if exist "lib\utils\glassmorphism_theme_extension.dart" (
    echo   - Suppression: glassmorphism_theme_extension.dart
    del /f /q "lib\utils\glassmorphism_theme_extension.dart"
)

echo.
echo ========================================
echo   NETTOYAGE PHASE 2 TERMINE
echo ========================================
echo.
echo Test de compilation en cours...
flutter clean
if %errorlevel% neq 0 (
    echo ERREUR: flutter clean a echoue
    pause
    exit /b 1
)

flutter pub get
if %errorlevel% neq 0 (
    echo ERREUR: flutter pub get a echoue
    pause
    exit /b 1
)

flutter analyze
if %errorlevel% neq 0 (
    echo ATTENTION: flutter analyze a detecte des erreurs
    echo Veuillez les corriger avant de continuer
    pause
    exit /b 1
)

echo.
echo ✅ SUCCES: Phase 2 terminee avec succes!
echo.
echo Prochaines etapes:
echo 1. Corriger les imports cassés
echo 2. Tester la navigation
echo 3. Continuer avec la Phase 3
echo.
pause

