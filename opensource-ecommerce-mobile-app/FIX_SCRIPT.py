#!/usr/bin/env python3
"""
🏗️ AGENT FRONTEND OPS – BAZAR MARKETPLACE
Étape B - Script d'organisation automatique
"""

import os
import shutil
from datetime import datetime

class FlutterOrganizer:
    def __init__(self):
        self.lib_dir = "lib"
        self.backup_dir = f"backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        self.changes_log = []

    def log_change(self, action, details):
        """Enregistre une modification"""
        self.changes_log.append({
            "timestamp": datetime.now().isoformat(),
            "action": action,
            "details": details
        })
        print(f"✅ {action}: {details}")

    def create_backup(self):
        """Crée une sauvegarde avant modifications"""
        if os.path.exists(self.lib_dir):
            shutil.copytree(self.lib_dir, self.backup_dir)
            self.log_change("BACKUP", f"Créé sauvegarde dans {self.backup_dir}")
            return True
        return False

    def create_core_architecture(self):
        """Crée l'architecture core manquante"""
        core_structure = {
            "lib/core/constants": [
                "app_constants.dart",
                "api_endpoints.dart", 
                "app_strings.dart"
            ],
            "lib/core/errors": [
                "failures.dart",
                "exceptions.dart"
            ],
            "lib/core/network": [
                "network_info.dart",
                "api_client.dart"
            ],
            "lib/core/usecases": [
                "usecase.dart"
            ],
            "lib/core/utils": [
                "input_validator.dart",
                "date_formatter.dart"
            ]
        }

        for directory, files in core_structure.items():
            os.makedirs(directory, exist_ok=True)
            self.log_change("CREATE_DIR", f"Créé {directory}")
            
            for file in files:
                file_path = os.path.join(directory, file)
                if not os.path.exists(file_path):
                    # Créer le contenu de base
                    content = self.generate_core_file_content(file, directory)
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    self.log_change("CREATE_FILE", f"Créé {file_path}")

    def generate_core_file_content(self, filename, directory):
        """Génère le contenu de base pour les fichiers core"""
        if "constants" in directory:
            if "app_constants" in filename:
                return '''/*
 * BAZAR Marketplace - App Constants
 */

class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.bazar.marketplace.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // App Configuration
  static const String appName = 'BAZAR Marketplace';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 4.0;
}'''
            elif "api_endpoints" in filename:
                return '''/*
 * BAZAR Marketplace - API Endpoints
 */

class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  
  // Products
  static const String products = '/products';
  static const String categories = '/categories';
  static const String search = '/search';
  
  // Cart & Orders
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  
  // User
  static const String profile = '/user/profile';
  static const String addresses = '/user/addresses';
}'''
            elif "app_strings" in filename:
                return '''/*
 * BAZAR Marketplace - App Strings
 */

class AppStrings {
  // Common
  static const String loading = 'Chargement...';
  static const String error = 'Erreur';
  static const String success = 'Succès';
  static const String retry = 'Réessayer';
  
  // Navigation
  static const String home = 'Accueil';
  static const String categories = 'Catégories';
  static const String cart = 'Panier';
  static const String profile = 'Profil';
  
  // Products
  static const String addToCart = 'Ajouter au panier';
  static const String buyNow = 'Acheter maintenant';
  static const String outOfStock = 'Rupture de stock';
}'''

        elif "errors" in directory:
            if "failures" in filename:
                return '''/*
 * BAZAR Marketplace - Failures
 */

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}'''
            elif "exceptions" in filename:
                return '''/*
 * BAZAR Marketplace - Exceptions
 */

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}'''

        elif "network" in directory:
            if "network_info" in filename:
                return '''/*
 * BAZAR Marketplace - Network Info
 */

import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}'''
            elif "api_client" in filename:
                return '''/*
 * BAZAR Marketplace - API Client
 */

import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio();
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth headers
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}'''

        elif "usecases" in directory:
            return '''/*
 * BAZAR Marketplace - Usecase Base
 */

import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}'''

        elif "utils" in directory:
            if "input_validator" in filename:
                return '''/*
 * BAZAR Marketplace - Input Validator
 */

class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email requis';
    }
    if (!RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$').hasMatch(value)) {
      return 'Format email invalide';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe requis';
    }
    if (value.length < 6) {
      return 'Minimum 6 caractères';
    }
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName requis';
    }
    return null;
  }
}'''
            elif "date_formatter" in filename:
                return '''/*
 * BAZAR Marketplace - Date Formatter
 */

import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} jour(s)';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure(s)';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s)';
    } else {
      return 'À l\'instant';
    }
  }
}'''

        return f"// {filename} - BAZAR Marketplace"

    def organize_screens_by_features(self):
        """Réorganise les screens par fonctionnalités"""
        feature_structure = {
            "lib/features/authentication": [
                "sign_in",
                "sign_up", 
                "forget_password"
            ],
            "lib/features/products": [
                "product_detail",
                "product_screen",
                "categories_screen",
                "search_screen"
            ],
            "lib/features/cart": [
                "cart_screen",
                "checkout"
            ],
            "lib/features/orders": [
                "orders",
                "order_detail",
                "order_invoices",
                "order_refund",
                "order_shipping"
            ],
            "lib/features/user": [
                "account",
                "dashboard",
                "address_list",
                "add_edit_address"
            ],
            "lib/features/common": [
                "splash_screen",
                "contact_us",
                "cms_screen",
                "currency",
                "language"
            ]
        }

        # Créer la structure features
        for feature_dir, screen_dirs in feature_structure.items():
            os.makedirs(feature_dir, exist_ok=True)
            self.log_change("CREATE_FEATURE", f"Créé {feature_dir}")
            
            for screen_dir in screen_dirs:
                old_path = os.path.join("lib/screens", screen_dir)
                new_path = os.path.join(feature_dir, screen_dir)
                
                if os.path.exists(old_path):
                    if not os.path.exists(new_path):
                        shutil.move(old_path, new_path)
                        self.log_change("MOVE_SCREEN", f"Déplacé {old_path} → {new_path}")

    def create_centralized_router(self):
        """Crée le routeur centralisé avec GoRouter"""
        router_content = '''/*
 * BAZAR Marketplace - Centralized Router
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/sign_in/sign_in_screen.dart';
import '../features/authentication/sign_up/sign_up_screen.dart';
import '../features/products/product_detail/product_detail_screen.dart';
import '../features/products/categories/categories_screen.dart';
import '../features/cart/cart_screen/cart_screen.dart';
import '../features/cart/checkout/checkout_screen.dart';
import '../features/user/dashboard/dashboard_screen.dart';
import '../screens/bazar_home/bazar_home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String productDetail = '/product/:id';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String dashboard = '/dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const BazarHomeScreen(),
      ),
      GoRoute(
        path: signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page non trouvée'),
      ),
    ),
  );
}'''

        router_path = "lib/router.dart"
        with open(router_path, 'w', encoding='utf-8') as f:
            f.write(router_content)
        self.log_change("CREATE_ROUTER", f"Créé routeur centralisé {router_path}")

    def update_main_dart(self):
        """Met à jour main.dart pour utiliser le nouveau routeur"""
        main_path = "lib/main.dart"
        if os.path.exists(main_path):
            with open(main_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Remplacer MaterialApp par GoRouter
            if 'MaterialApp(' in content and 'GoRouter' not in content:
                new_content = content.replace(
                    'MaterialApp(',
                    '''MaterialApp.router(
      routerConfig: AppRouter.router,'''
                )
                
                # Ajouter l'import du routeur
                if "import 'router.dart';" not in content:
                    import_line = "import 'package:flutter/material.dart';"
                    if import_line in content:
                        content = content.replace(
                            import_line,
                            f"{import_line}\nimport 'router.dart';"
                        )
                
                with open(main_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                self.log_change("UPDATE_MAIN", "Mis à jour main.dart pour GoRouter")

    def create_index_files(self):
        """Crée les fichiers index.dart uniques"""
        index_locations = [
            "lib/core/index.dart",
            "lib/features/index.dart",
            "lib/widgets/index.dart"
        ]
        
        for index_path in index_locations:
            directory = os.path.dirname(index_path)
            if os.path.exists(directory):
                # Lister les fichiers .dart dans le répertoire
                dart_files = [f for f in os.listdir(directory) 
                             if f.endswith('.dart') and f != 'index.dart']
                
                # Créer le contenu de l'index
                exports = []
                for dart_file in dart_files:
                    relative_path = os.path.relpath(os.path.join(directory, dart_file), "lib")
                    exports.append(f"export '{relative_path.replace(os.sep, '/')}';")
                
                index_content = f"""/*
 * BAZAR Marketplace - {os.path.basename(directory).title()} Index
 * Auto-generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
 */

{chr(10).join(exports)}
"""
                
                with open(index_path, 'w', encoding='utf-8') as f:
                    f.write(index_content)
                self.log_change("CREATE_INDEX", f"Créé {index_path}")

    def generate_organization_report(self):
        """Génère le rapport d'organisation"""
        report_content = f"""# 🏗️ RAPPORT D'ORGANISATION - BAZAR MARKETPLACE

**Date :** {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}
**Script :** Frontend OPS Agent v1.0

## 📊 CHANGEMENTS EFFECTUÉS

"""
        
        for change in self.changes_log:
            report_content += f"- **{change['action']}** : {change['details']}\n"
        
        report_content += f"""

## 📂 NOUVELLE STRUCTURE

```
lib/
├── core/                    # Architecture core
│   ├── constants/          # Constantes app
│   ├── errors/             # Gestion d'erreurs
│   ├── network/            # Couche réseau
│   ├── usecases/           # Cas d'usage
│   └── utils/              # Utilitaires core
├── features/               # Fonctionnalités par domaine
│   ├── authentication/     # Auth (sign_in, sign_up)
│   ├── products/           # Produits (detail, categories)
│   ├── cart/               # Panier (cart, checkout)
│   ├── orders/             # Commandes
│   ├── user/               # Utilisateur
│   └── common/             # Commun
├── widgets/                # Composants réutilisables
├── data_model/             # Modèles de données
├── services/               # Services métier
├── repositories/           # Couche d'accès données
├── router.dart             # Routeur centralisé GoRouter
└── main.dart               # Point d'entrée
```

## ✅ AMÉLIORATIONS APPORTÉES

1. **Architecture core** - Structure solide créée
2. **Organisation features** - Screens regroupés par domaine
3. **Routeur centralisé** - GoRouter v13 implémenté
4. **Index uniques** - Exports centralisés
5. **Sauvegarde** - Backup créé avant modifications

## 🎯 PROCHAINES ÉTAPES

1. **Tests de compilation** - Vérifier que tout compile
2. **Design check** - Valider BazarTheme cohérent
3. **Tests automatisés** - Ajouter la couverture
4. **CI/CD pipeline** - Automatiser les déploiements

---

**📋 Sauvegarde disponible dans :** `{self.backup_dir}/`
**🔄 Prochaine étape :** Design Check (Étape C)
"""
        
        with open('ORGANIZATION_REPORT.md', 'w', encoding='utf-8') as f:
            f.write(report_content)
        self.log_change("CREATE_REPORT", "Rapport d'organisation généré")

    def run_organization(self):
        """Exécute l'organisation complète"""
        print("🏗️ ÉTAPE B - ORGANISATION BAZAR MARKETPLACE")
        print("=" * 60)
        
        # Créer la sauvegarde
        print("💾 Création de la sauvegarde...")
        self.create_backup()
        
        # Créer l'architecture core
        print("🏛️ Création de l'architecture core...")
        self.create_core_architecture()
        
        # Organiser les screens par features
        print("📁 Organisation des screens par features...")
        self.organize_screens_by_features()
        
        # Créer le routeur centralisé
        print("🛣️ Création du routeur centralisé...")
        self.create_centralized_router()
        
        # Mettre à jour main.dart
        print("🔄 Mise à jour de main.dart...")
        self.update_main_dart()
        
        # Créer les index files
        print("📋 Création des index files...")
        self.create_index_files()
        
        # Générer le rapport
        print("📊 Génération du rapport...")
        self.generate_organization_report()
        
        print(f"\n🎉 ORGANISATION TERMINÉE !")
        print(f"📄 {len(self.changes_log)} modifications effectuées")
        print(f"💾 Sauvegarde : {self.backup_dir}")
        print(f"📋 Rapport : ORGANIZATION_REPORT.md")
        
        return True

if __name__ == "__main__":
    organizer = FlutterOrganizer()
    organizer.run_organization()
