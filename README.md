# 🏪 **BAZAR Marketplace**

> **Your Ultimate Marketplace** - Une plateforme e-commerce moderne et complète avec backend Laravel et application mobile Flutter.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Laravel-11.x-red.svg)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP-8.3+-purple.svg)](https://php.net)

---

## 🎯 **Vue d'ensemble**

**BAZAR Marketplace** est une solution e-commerce complète comprenant :

- 🖥️ **Backend Laravel** - API REST robuste avec Bagisto
- 📱 **Application Mobile Flutter** - Interface utilisateur moderne et responsive
- 🌐 **Support Web** - Application web compatible Chrome/Firefox/Safari
- 🔐 **Authentification sécurisée** - JWT avec refresh tokens
- 🛒 **Gestion complète** - Produits, panier, commandes, paiements
- 🌍 **Multi-langue** - Support RTL/LTR (Arabe, Français, Anglais)

---

## 🏗️ **Architecture**

```
BAZAR Marketplace/
├── 📁 backend-bagisto/          # Backend Laravel + Bagisto
│   ├── 🖥️ API REST complète
│   ├── 🗄️ Base de données MySQL/PostgreSQL
│   ├── 🔐 Authentification JWT
│   └── 💳 Intégration paiements Stripe
│
└── 📁 opensource-ecommerce-mobile-app/  # Application Flutter
    ├── 📱 Interface mobile native
    ├── 🌐 Support web (Chrome, Firefox, Safari)
    ├── 🎨 Design Material Design 3
    └── 🔄 Synchronisation temps réel
```

---

## 🚀 **Installation Rapide**

### **Prérequis**
- **PHP 8.3+** avec extensions Laravel
- **Composer 2.x**
- **Node.js 18+** et npm
- **Flutter 3.19+**
- **MySQL 8.0+** ou PostgreSQL 13+
- **Git**

### **1. Backend Laravel (Bagisto)**

```bash
# Cloner le repository
git clone https://github.com/Gameminde/BAZAR.git
cd BAZAR/backend-bagisto

# Installer les dépendances
composer install
npm install

# Configuration
cp .env.example .env
php artisan key:generate

# Base de données
php artisan migrate
php artisan db:seed

# Démarrer le serveur
php artisan serve
# Backend disponible sur http://localhost:8000
```

### **2. Application Mobile Flutter**

```bash
# Aller dans le dossier mobile
cd ../opensource-ecommerce-mobile-app

# Installer les dépendances
flutter pub get

# Lancer sur Chrome (Web)
flutter run -d chrome --web-port=8080

# Lancer sur Android
flutter run -d android

# Lancer sur iOS
flutter run -d ios
```

---

## 📱 **Fonctionnalités**

### **🛍️ E-commerce**
- ✅ **Catalogue produits** avec filtres avancés
- ✅ **Panier intelligent** avec sauvegarde locale
- ✅ **Liste de souhaits** personnalisée
- ✅ **Recherche en temps réel**
- ✅ **Catégories dynamiques**

### **👤 Gestion Utilisateurs**
- ✅ **Inscription/Connexion** sécurisée
- ✅ **Profil utilisateur** complet
- ✅ **Historique des commandes**
- ✅ **Adresses de livraison**

### **💳 Paiements**
- ✅ **Stripe Connect** pour marketplace
- ✅ **PayPal** intégration
- ✅ **Paiement à la livraison**
- ✅ **Gestion des remboursements**

### **🌍 Internationalisation**
- ✅ **Support RTL** (Arabe)
- ✅ **Support LTR** (Français, Anglais)
- ✅ **Devises multiples**
- ✅ **Localisation complète**

---

## 🛠️ **Technologies**

### **Backend**
- **Laravel 11.x** - Framework PHP moderne
- **Bagisto** - Plateforme e-commerce Laravel
- **MySQL/PostgreSQL** - Base de données
- **JWT** - Authentification sécurisée
- **Stripe API** - Paiements en ligne
- **Redis** - Cache et sessions

### **Frontend Mobile**
- **Flutter 3.19+** - Framework cross-platform
- **Material Design 3** - Design system Google
- **Dio** - Client HTTP avancé
- **GetX** - State management
- **Hive** - Base de données locale
- **GoRouter** - Navigation avancée

### **DevOps & Outils**
- **GitHub Actions** - CI/CD automatisé
- **Docker** - Containerisation
- **Playwright** - Tests end-to-end
- **Pest** - Tests PHP unitaires
- **Flutter Test** - Tests Dart

---

## 📊 **API Endpoints**

### **Authentification**
```
POST /api/auth/login          # Connexion utilisateur
POST /api/auth/register       # Inscription utilisateur
POST /api/auth/refresh        # Refresh token
POST /api/auth/logout         # Déconnexion
GET  /api/auth/profile        # Profil utilisateur
```

### **Produits**
```
GET  /api/products            # Liste des produits
GET  /api/products/{id}       # Détails produit
GET  /api/categories          # Catégories
GET  /api/search              # Recherche produits
```

### **Panier & Commandes**
```
GET  /api/cart                # Panier utilisateur
POST /api/cart/add            # Ajouter au panier
PUT  /api/cart/{id}           # Modifier quantité
DELETE /api/cart/{id}         # Retirer du panier
GET  /api/orders              # Commandes utilisateur
POST /api/orders              # Créer commande
```

---

## 🧪 **Tests**

### **Backend Tests**
```bash
cd backend-bagisto
vendor/bin/pest --parallel
```

### **Frontend Tests**
```bash
cd opensource-ecommerce-mobile-app
flutter test
```

### **Tests E2E**
```bash
# Tests Playwright (Backend)
cd backend-bagisto/packages/Webkul/Admin
npx playwright test

# Tests Flutter Integration
cd opensource-ecommerce-mobile-app
flutter test integration_test/
```

---

## 📈 **Performance**

### **Métriques Cibles**
- ⚡ **API Response Time** : < 200ms
- 📱 **App Launch Time** : < 3s
- 🖼️ **Image Loading** : < 1s
- 🔍 **Search Response** : < 500ms
- 📊 **Uptime** : > 99.9%

### **Optimisations**
- ✅ **Cache Redis** pour les données fréquentes
- ✅ **Compression images** automatique
- ✅ **Lazy loading** des composants
- ✅ **Code splitting** Flutter
- ✅ **CDN** pour les assets statiques

---

## 🔒 **Sécurité**

### **Mesures Implémentées**
- 🔐 **JWT avec rotation** automatique des tokens
- 🛡️ **bcrypt 12 rounds** pour les mots de passe
- 🚫 **Rate limiting** : 100 req/15min général, 5 req/15min auth
- ✅ **Validation Joi** stricte sur tous les inputs
- 🛡️ **XSS + injection prevention**
- 🔒 **HTTPS enforce** partout

### **Audit Sécurité**
- ✅ **OWASP Top 10** compliance
- ✅ **Dependency scanning** automatique
- ✅ **Code quality** analysis
- ✅ **Security headers** configurés

---

## 🌍 **Déploiement**

### **Environnements**
- 🟢 **Production** : `https://bazar-marketplace.com`
- 🟡 **Staging** : `https://staging.bazar-marketplace.com`
- 🔵 **Development** : `http://localhost:8000`

### **Services Gratuits Utilisés**
- **MongoDB Atlas** : 512MB gratuit (50k produits)
- **Neon PostgreSQL** : 1GB gratuit (users, orders)
- **Fly.io** : 3 VMs 256MB gratuit (API)
- **Google Cloud** : $300 credits + always free
- **Cloudflare** : 100GB/mois CDN gratuit
- **Firebase** : Notifications push illimitées

---

## 🤝 **Contribution**

### **Comment Contribuer**
1. **Fork** le repository
2. **Créer** une branche feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### **Standards de Code**
- **PSR-12** pour PHP
- **Effective Dart** pour Flutter
- **Conventional Commits** pour les messages
- **Tests** obligatoires pour les nouvelles fonctionnalités

---

## 📄 **Licence**

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👥 **Équipe**

- **Développement** : [@Gameminde](https://github.com/Gameminde)
- **Design** : BAZAR Design Team
- **DevOps** : BAZAR Infrastructure Team

---

## 📞 **Support**

- 🐛 **Bugs** : [Issues GitHub](https://github.com/Gameminde/BAZAR/issues)
- 💬 **Discussions** : [Discussions GitHub](https://github.com/Gameminde/BAZAR/discussions)
- 📧 **Email** : support@bazar-marketplace.com
- 📖 **Documentation** : [Wiki GitHub](https://github.com/Gameminde/BAZAR/wiki)

---

## 🎉 **Remerciements**

- **Laravel Team** pour le framework exceptionnel
- **Flutter Team** pour l'outil cross-platform
- **Bagisto Community** pour la base e-commerce
- **Contributors** qui participent au projet

---

<div align="center">

**⭐ Si ce projet vous aide, n'hésitez pas à lui donner une étoile ! ⭐**

[![GitHub stars](https://img.shields.io/github/stars/Gameminde/BAZAR?style=social)](https://github.com/Gameminde/BAZAR/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Gameminde/BAZAR?style=social)](https://github.com/Gameminde/BAZAR/network)
[![GitHub watchers](https://img.shields.io/github/watchers/Gameminde/BAZAR?style=social)](https://github.com/Gameminde/BAZAR/watchers)

</div>

---

*Dernière mise à jour : Janvier 2025*
