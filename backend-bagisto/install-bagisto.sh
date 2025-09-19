#!/bin/bash

echo "🚀 INSTALLATION BAGISTO POUR BAZAR MARKETPLACE"
echo "================================================"

echo ""
echo "📋 Phase 1: Installation des dépendances..."
echo ""

# Vérifier PHP
if ! command -v php &> /dev/null; then
    echo "❌ PHP n'est pas installé"
    echo "💡 Installez PHP 8.1+ avec: sudo apt install php8.1-cli php8.1-mysql"
    exit 1
fi

# Vérifier Composer
if ! command -v composer &> /dev/null; then
    echo "❌ Composer n'est pas installé"
    echo "💡 Installez Composer depuis https://getcomposer.org"
    exit 1
fi

echo "✅ PHP et Composer détectés"
echo ""

echo "📦 Installation des dépendances PHP..."
composer install --no-dev --optimize-autoloader
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation Composer"
    exit 1
fi

echo "✅ Dépendances PHP installées"
echo ""

echo "📦 Installation des dépendances Node.js..."
npm install --production
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation NPM"
    exit 1
fi

echo "✅ Dépendances Node.js installées"
echo ""

echo "🔧 Configuration de l'environnement..."
cp .env.example .env
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la copie du fichier .env"
    exit 1
fi

echo "✅ Fichier .env créé"
echo ""

echo "🔑 Génération de la clé d'application..."
php artisan key:generate
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la génération de la clé"
    exit 1
fi

echo "✅ Clé d'application générée"
echo ""

echo "🗄️ Configuration de la base de données..."
echo ""
echo "📝 Veuillez configurer votre base de données dans le fichier .env"
echo ""
echo "Exemple de configuration:"
echo "DB_CONNECTION=mysql"
echo "DB_HOST=127.0.0.1"
echo "DB_PORT=3306"
echo "DB_DATABASE=bagisto_bazar"
echo "DB_USERNAME=root"
echo "DB_PASSWORD=votre_mot_de_passe"
echo ""
echo "Appuyez sur Entrée quand vous avez configuré la base de données..."
read

echo "🚀 Installation de Bagisto..."
php artisan bagisto:install
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation de Bagisto"
    echo "💡 Vérifiez votre configuration de base de données"
    exit 1
fi

echo "✅ Bagisto installé avec succès!"
echo ""

echo "⚡ Optimisation pour la production..."
php artisan optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✅ Optimisations appliquées"
echo ""

echo "🎉 INSTALLATION TERMINÉE!"
echo "========================"
echo ""
echo "🌐 Accès admin: http://localhost:8000/admin"
echo "🛒 Accès boutique: http://localhost:8000"
echo ""
echo "📋 Prochaines étapes:"
echo "1. Configurez votre boutique dans l'admin"
echo "2. Ajoutez des produits"
echo "3. Configurez les paiements"
echo "4. Testez l'API GraphQL"
echo ""
echo "Appuyez sur Entrée pour démarrer le serveur..."
read

echo "🚀 Démarrage du serveur de développement..."
php artisan serve --host=0.0.0.0 --port=8000
