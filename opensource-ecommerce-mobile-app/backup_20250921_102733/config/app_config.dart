/*
 * Configuration unifiée pour BAZAR Marketplace
 * Remplace server_configuration.dart et bagisto_config.dart
 */

import 'dart:ui';

/// Configuration centralisée pour BAZAR Marketplace
class AppConfig {
  // ========================================
  // ENVIRONNEMENTS
  // ========================================

  /// Environnement actuel (dev/staging/prod)
  static const Environment currentEnvironment = Environment.development;

  /// Configuration par environnement
  static const Map<Environment, EnvironmentConfig> environments = {
    Environment.development: EnvironmentConfig(
      baseDomain: 'https://jsonplaceholder.typicode.com',
      apiUrl: 'https://jsonplaceholder.typicode.com/posts',
      graphqlUrl: 'https://jsonplaceholder.typicode.com/graphql',
      enableLogging: true,
      enableAnalytics: false,
    ),
    Environment.staging: EnvironmentConfig(
      baseDomain: 'https://staging.bazar-marketplace.com',
      apiUrl: 'https://staging.bazar-marketplace.com/api',
      graphqlUrl: 'https://staging.bazar-marketplace.com/graphql',
      enableLogging: true,
      enableAnalytics: true,
    ),
    Environment.production: EnvironmentConfig(
      baseDomain: 'https://bazar-marketplace.com',
      apiUrl: 'https://bazar-marketplace.com/api',
      graphqlUrl: 'https://bazar-marketplace.com/graphql',
      enableLogging: false,
      enableAnalytics: true,
    ),
  };

  // ========================================
  // CONFIGURATION ACTUELLE
  // ========================================

  static EnvironmentConfig get current => environments[currentEnvironment]!;

  static String get baseDomain => current.baseDomain;
  static String get apiUrl => current.apiUrl;
  static String get graphqlUrl => current.graphqlUrl;
  static bool get enableLogging => current.enableLogging;
  static bool get enableAnalytics => current.enableAnalytics;

  // ========================================
  // ENDPOINTS API
  // ========================================

  static String get authEndpoint => '$apiUrl/users';
  static String get productsEndpoint => '$apiUrl/posts';
  static String get categoriesEndpoint => '$apiUrl/posts';
  static String get cartEndpoint => '$apiUrl/posts';
  static String get checkoutEndpoint => '$apiUrl/posts';
  static String get ordersEndpoint => '$apiUrl/posts';
  static String get shopsEndpoint => '$apiUrl/users';

  // ========================================
  // HEADERS HTTP
  // ========================================

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // ========================================
  // TIMEOUTS
  // ========================================

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ========================================
  // PAGINATION
  // ========================================

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ========================================
  // IMAGES
  // ========================================

  static String get imageBaseUrl => '$baseDomain/storage/';
  static String get productImagePath => 'products/';
  static String get categoryImagePath => 'categories/';
  static String get shopImagePath => 'shops/';

  static String getProductImageUrl(String imagePath) =>
      '$imageBaseUrl$productImagePath$imagePath';

  static String getCategoryImageUrl(String imagePath) =>
      '$imageBaseUrl$categoryImagePath$imagePath';

  static String getShopImageUrl(String imagePath) =>
      '$imageBaseUrl$shopImagePath$imagePath';

  // ========================================
  // LANGUE ET LOCALISATION
  // ========================================

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
    Locale('es'),
    Locale('de'),
    Locale('it'),
    Locale('pt'),
    Locale('nl'),
    Locale('tr'),
    Locale('hi', 'IN'),
  ];

  static const List<String> supportedLocaleCodes = [
    'en',
    'fr',
    'ar',
    'es',
    'de',
    'it',
    'pt',
    'nl',
    'tr',
    'hi',
  ];

  static const String defaultLocale = 'en';
  static const String defaultLanguageName = 'English';

  // ========================================
  // DEVISES
  // ========================================

  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
    'JPY',
    'CHF',
    'SEK',
    'NOK',
    'DKK',
    'DZD', // Dinar algérien
  ];

  static const String defaultCurrency = 'USD';
  static const String defaultCurrencyName = 'US Dollar';

  // ========================================
  // TEMPLATES BOUTIQUES
  // ========================================

  static const List<String> availableTemplates = [
    'feminin',
    'masculin',
    'neutre',
    'urbain',
    'minimal',
  ];

  // ========================================
  // LIMITES
  // ========================================

  static const int maxCartItems = 50;
  static const int maxWishlistItems = 100;
  static const int maxSearchResults = 1000;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ];

  // ========================================
  // CACHE
  // ========================================

  static const Duration productCacheDuration = Duration(minutes: 30);
  static const Duration categoryCacheDuration = Duration(hours: 2);
  static const Duration userCacheDuration = Duration(minutes: 15);
  static const Duration promotionCacheDuration = Duration(minutes: 5);

  // ========================================
  // RETRY
  // ========================================

  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // ========================================
  // REVIEWS
  // ========================================

  static const int minReviewLength = 10;
  static const int maxReviewLength = 500;
  static const int maxRating = 5;
  static const int minRating = 1;

  // ========================================
  // RECOMMANDATIONS
  // ========================================

  static const int maxRecommendedProducts = 12;
  static const int maxRelatedProducts = 8;
  static const int maxRecentlyViewed = 20;

  // ========================================
  // FILTRES ET TRI
  // ========================================

  static const Map<String, dynamic> defaultFilters = {
    'price_min': 0,
    'price_max': 10000,
    'rating_min': 0,
    'in_stock': true,
    'featured': false,
  };

  static const List<String> sortOptions = [
    'relevance',
    'price_low_to_high',
    'price_high_to_low',
    'newest',
    'oldest',
    'rating',
    'popularity',
  ];

  // ========================================
  // MESSAGES
  // ========================================

  static const Map<String, String> errorMessages = {
    'network_error': 'Erreur de connexion. Vérifiez votre internet.',
    'server_error': 'Erreur du serveur. Réessayez plus tard.',
    'auth_error': 'Erreur d\'authentification. Reconnectez-vous.',
    'validation_error': 'Données invalides. Vérifiez vos informations.',
    'not_found': 'Ressource non trouvée.',
    'forbidden': 'Accès refusé.',
    'rate_limit': 'Trop de requêtes. Attendez un moment.',
  };

  static const Map<String, String> successMessages = {
    'login_success': 'Connexion réussie!',
    'register_success': 'Inscription réussie!',
    'order_success': 'Commande passée avec succès!',
    'review_success': 'Avis ajouté avec succès!',
    'wishlist_add': 'Ajouté aux favoris!',
    'cart_add': 'Ajouté au panier!',
  };

  // ========================================
  // PAYEMENTS
  // ========================================

  static const List<String> availablePaymentMethods = [
    'cashondelivery',
    'moneytransfer',
    'paypal_standard',
    'paypal_smart_button',
    'stripe',
  ];

  // ========================================
  // AUTRES CONSTANTES
  // ========================================

  static const int defaultSplashDelay = 3;
  static const String defaultChannelId = '1';
  static const String defaultChannelName = 'com.webkul.bagisto_mobikul/channel';
  static const String defaultAppTitle = 'BAZAR Marketplace';
  static const bool isPreFetchingEnable = true;

  // ========================================
  // MÉTHODES UTILITAIRES
  // ========================================

  static Map<String, String> getHeaders([String? token]) {
    if (token != null) {
      return getAuthHeaders(token);
    }
    return defaultHeaders;
  }

  static String getErrorMessage(String errorCode) {
    return errorMessages[errorCode] ?? 'Erreur inconnue';
  }

  static String getSuccessMessage(String successCode) {
    return successMessages[successCode] ?? 'Opération réussie';
  }

  static bool isSupportedLocale(String localeCode) {
    return supportedLocaleCodes.contains(localeCode);
  }

  static bool isSupportedCurrency(String currencyCode) {
    return supportedCurrencies.contains(currencyCode);
  }
}

/// Environnements supportés
enum Environment { development, staging, production }

/// Configuration par environnement
class EnvironmentConfig {
  final String baseDomain;
  final String apiUrl;
  final String graphqlUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  const EnvironmentConfig({
    required this.baseDomain,
    required this.apiUrl,
    required this.graphqlUrl,
    required this.enableLogging,
    required this.enableAnalytics,
  });
}
