/*
 * Configuration Bagisto pour BAZAR Marketplace
 * Remplace la configuration Node.js par Bagisto
 */

class BagistoConfig {
  // Configuration de base - Utilisation d'une API de démonstration
  static const String baseDomain = "https://jsonplaceholder.typicode.com";
  static const String apiUrl = "$baseDomain/posts"; // Utiliser un endpoint spécifique
  static const String graphqlUrl = "$baseDomain/graphql";

  // Configuration pour production
  static const String productionDomain = "https://votre-domaine.com";
  static const String productionApiUrl = "$productionDomain/api";
  static const String productionGraphqlUrl = "$productionDomain/graphql";

  // Endpoints API de démonstration
  static const String authEndpoint = "$apiUrl/users";
  static const String productsEndpoint = "$apiUrl/posts";
  static const String categoriesEndpoint = "$apiUrl/posts";
  static const String cartEndpoint = "$apiUrl/posts";
  static const String checkoutEndpoint = "$apiUrl/posts";
  static const String ordersEndpoint = "$apiUrl/posts";
  static const String shopsEndpoint = "$apiUrl/users";

  // Configuration GraphQL
  static const String graphqlEndpoint = graphqlUrl;

  // Headers par défaut
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Headers avec authentification
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Configuration des timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Configuration de pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Configuration des images
  static const String imageBaseUrl = "$baseDomain/storage/";
  static const String productImagePath = "products/";
  static const String categoryImagePath = "categories/";
  static const String shopImagePath = "shops/";

  // URLs complètes pour les images
  static String getProductImageUrl(String imagePath) =>
      "$imageBaseUrl$productImagePath$imagePath";

  static String getCategoryImageUrl(String imagePath) =>
      "$imageBaseUrl$categoryImagePath$imagePath";

  static String getShopImageUrl(String imagePath) =>
      "$imageBaseUrl$shopImagePath$imagePath";

  // Configuration des paiements
  static const String stripePublishableKey = "pk_test_..."; // À remplacer
  static const String paypalClientId = "your_paypal_client_id"; // À remplacer

  // Configuration des notifications
  static const String fcmServerKey = "your_fcm_server_key"; // À remplacer

  // Configuration de l'environnement
  static const bool isDevelopment = true; // Changer pour production
  static const bool enableLogging = true;
  static const bool enableAnalytics = false; // Activer en production

  // Configuration des langues supportées
  static const List<String> supportedLocales = [
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

  // Configuration des devises supportées
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
  ];

  // Configuration par défaut
  static const String defaultLocale = 'en';
  static const String defaultCurrency = 'USD';

  // Configuration des templates (si applicable)
  static const List<String> availableTemplates = [
    'feminin',
    'masculin',
    'neutre',
    'urbain',
    'minimal',
  ];

  // Configuration des limites
  static const int maxCartItems = 50;
  static const int maxWishlistItems = 100;
  static const int maxSearchResults = 1000;

  // Configuration des caches
  static const Duration productCacheDuration = Duration(minutes: 30);
  static const Duration categoryCacheDuration = Duration(hours: 2);
  static const Duration userCacheDuration = Duration(minutes: 15);

  // Configuration des retry
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Configuration des uploads
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ];

  // Configuration des reviews
  static const int minReviewLength = 10;
  static const int maxReviewLength = 500;
  static const int maxRating = 5;
  static const int minRating = 1;

  // Configuration des promotions
  static const Duration promotionCacheDuration = Duration(minutes: 5);
  static const int maxPromotionsPerPage = 10;

  // Configuration des recommandations
  static const int maxRecommendedProducts = 12;
  static const int maxRelatedProducts = 8;
  static const int maxRecentlyViewed = 20;

  // Configuration des filtres
  static const Map<String, dynamic> defaultFilters = {
    'price_min': 0,
    'price_max': 10000,
    'rating_min': 0,
    'in_stock': true,
    'featured': false,
  };

  // Configuration des tri
  static const List<String> sortOptions = [
    'relevance',
    'price_low_to_high',
    'price_high_to_low',
    'newest',
    'oldest',
    'rating',
    'popularity',
  ];

  // Configuration des erreurs
  static const Map<String, String> errorMessages = {
    'network_error': 'Erreur de connexion. Vérifiez votre internet.',
    'server_error': 'Erreur du serveur. Réessayez plus tard.',
    'auth_error': 'Erreur d\'authentification. Reconnectez-vous.',
    'validation_error': 'Données invalides. Vérifiez vos informations.',
    'not_found': 'Ressource non trouvée.',
    'forbidden': 'Accès refusé.',
    'rate_limit': 'Trop de requêtes. Attendez un moment.',
  };

  // Configuration des succès
  static const Map<String, String> successMessages = {
    'login_success': 'Connexion réussie!',
    'register_success': 'Inscription réussie!',
    'order_success': 'Commande passée avec succès!',
    'review_success': 'Avis ajouté avec succès!',
    'wishlist_add': 'Ajouté aux favoris!',
    'cart_add': 'Ajouté au panier!',
  };

  // Méthodes utilitaires
  static String getCurrentApiUrl() {
    return isDevelopment ? apiUrl : productionApiUrl;
  }

  static String getCurrentGraphqlUrl() {
    return isDevelopment ? graphqlUrl : productionGraphqlUrl;
  }

  static String getCurrentDomain() {
    return isDevelopment ? baseDomain : productionDomain;
  }

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
}
