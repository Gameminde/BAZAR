@echo off
echo 🚀 INSTALLATION BAGISTO POUR BAZAR MARKETPLACE
echo ================================================

echo.
echo 📋 Phase 1: Installation des dépendances...
echo.

REM Vérifier PHP
php --version
if %errorlevel% neq 0 (
    echo ❌ PHP n'est pas installé ou pas dans le PATH
    echo 💡 Installez PHP 8.1+ depuis https://php.net
    pause
    exit /b 1
)

REM Vérifier Composer
composer --version
if %errorlevel% neq 0 (
    echo ❌ Composer n'est pas installé
    echo 💡 Installez Composer depuis https://getcomposer.org
    pause
    exit /b 1
)

echo ✅ PHP et Composer détectés
echo.

echo 📦 Installation des dépendances PHP...
composer install --no-dev --optimize-autoloader
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de l'installation Composer
    pause
    exit /b 1
)

echo ✅ Dépendances PHP installées
echo.

echo 📦 Installation des dépendances Node.js...
npm install --production
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de l'installation NPM
    pause
    exit /b 1
)

echo ✅ Dépendances Node.js installées
echo.

echo 🔧 Configuration de l'environnement...
copy .env.example .env
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de la copie du fichier .env
    pause
    exit /b 1
)

echo ✅ Fichier .env créé
echo.

echo 🔑 Génération de la clé d'application...
php artisan key:generate
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de la génération de la clé
    pause
    exit /b 1
)

echo ✅ Clé d'application générée
echo.

echo 🗄️ Configuration de la base de données...
echo.
echo 📝 Veuillez configurer votre base de données dans le fichier .env
echo.
echo Exemple de configuration:
echo DB_CONNECTION=mysql
echo DB_HOST=127.0.0.1
echo DB_PORT=3306
echo DB_DATABASE=bagisto_bazar
echo DB_USERNAME=root
echo DB_PASSWORD=votre_mot_de_passe
echo.
echo Appuyez sur une touche quand vous avez configuré la base de données...
pause

echo 🚀 Installation de Bagisto...
php artisan bagisto:install
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de l'installation de Bagisto
    echo 💡 Vérifiez votre configuration de base de données
    pause
    exit /b 1
)

echo ✅ Bagisto installé avec succès!
echo.

echo ⚡ Optimisation pour la production...
php artisan optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo ✅ Optimisations appliquées
echo.

echo 🎉 INSTALLATION TERMINÉE!
echo =========================
echo.
echo 🌐 Accès admin: http://localhost:8000/admin
echo 🛒 Accès boutique: http://localhost:8000
echo.
echo 📋 Prochaines étapes:
echo 1. Configurez votre boutique dans l'admin
echo 2. Ajoutez des produits
echo 3. Configurez les paiements
echo 4. Testez l'API GraphQL
echo.
echo Appuyez sur une touche pour démarrer le serveur...
pause

echo 🚀 Démarrage du serveur de développement...
php artisan serve --host=0.0.0.0 --port=8000
