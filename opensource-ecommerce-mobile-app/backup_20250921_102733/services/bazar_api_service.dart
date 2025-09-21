/*
 * Service API Bagisto pour BAZAR Marketplace
 * Remplace le service GraphQL par l'API REST Bagisto
 */

import 'package:dio/dio.dart';
import '../utils/bagisto_config.dart';
import '../utils/shared_preference_helper.dart';
import '../utils/logger.dart';

class BazarApiService {
  static final BazarApiService _instance = BazarApiService._internal();
  factory BazarApiService() => _instance;
  BazarApiService._internal();

  late Dio _dio;
  String? _authToken;
  String? _refreshToken;

  // Initialisation du service
  Future<void> initialize() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: BagistoConfig.getCurrentApiUrl(),
        connectTimeout: BagistoConfig.connectTimeout,
        receiveTimeout: BagistoConfig.receiveTimeout,
        headers: BagistoConfig.defaultHeaders,
      ),
    );

    // Intercepteur pour l'authentification
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ajouter le token d'authentification
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }

          if (BagistoConfig.enableLogging) {
            Logger.networkRequest(options.method, options.path, options.data);
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (BagistoConfig.enableLogging) {
            Logger.networkResponse(
              response.statusCode ?? 0,
              response.requestOptions.path,
              response.data,
            );
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (BagistoConfig.enableLogging) {
            Logger.networkError(
              error.response?.statusCode,
              error.requestOptions.path,
              error.message ?? 'Unknown error',
            );
          }

          // Gérer le refresh token automatiquement
          if (error.response?.statusCode == 401 && _refreshToken != null) {
            try {
              await _refreshAuthToken();
              // Retry la requête originale
              final retryResponse = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              handler.resolve(retryResponse);
              return;
            } catch (e) {
              // Refresh token échoué, déconnecter l'utilisateur
              await logout();
            }
          }

          handler.next(error);
        },
      ),
    );

    // Charger les tokens depuis le stockage local
    await _loadTokens();
  }

  // Charger les tokens depuis le stockage local
  Future<void> _loadTokens() async {
    _authToken = appStoragePref.getCustomerToken();
    _refreshToken = appStoragePref.getRefreshToken();
  }

  // Sauvegarder les tokens
  Future<void> _saveTokens(String authToken, String refreshToken) async {
    _authToken = authToken;
    _refreshToken = refreshToken;
    appStoragePref.setCustomerToken(authToken);
    appStoragePref.setRefreshToken(refreshToken);
  }

  // Rafraîchir le token d'authentification
  Future<void> _refreshAuthToken() async {
    if (_refreshToken == null) throw Exception('No refresh token available');

    try {
      final response = await _dio.post(
        '/customer/auth/refresh',
        data: {'refresh_token': _refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _saveTokens(data['access_token'], data['refresh_token']);
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  // ========================================
  // AUTHENTIFICATION
  // ========================================

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/customer/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _saveTokens(data['access_token'], data['refresh_token']);

        return {
          'success': true,
          'data': data['customer'],
          'message': BagistoConfig.getSuccessMessage('login_success'),
        };
      }

      throw Exception('Login failed');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/customer/auth/register',
        data: {
          'first_name': userData['firstName'],
          'last_name': userData['lastName'],
          'email': userData['email'],
          'password': userData['password'],
          'password_confirmation': userData['passwordConfirmation'],
          'phone': userData['phone'],
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        await _saveTokens(data['access_token'], data['refresh_token']);

        return {
          'success': true,
          'data': data['customer'],
          'message': BagistoConfig.getSuccessMessage('register_success'),
        };
      }

      throw Exception('Registration failed');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      if (_authToken != null) {
        await _dio.post('/customer/auth/logout');
      }
    } catch (e) {
      // Ignorer les erreurs de logout
    } finally {
      _authToken = null;
      _refreshToken = null;
      appStoragePref.clearCustomerToken();
      appStoragePref.clearRefreshToken();
    }

    return {'success': true, 'message': 'Déconnexion réussie'};
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/customer/profile');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get profile');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // ANCIENNES MÉTHODES SUPPRIMÉES
  // ========================================

  // Anciennes méthodes getProduct et getRelatedProducts supprimées

  // ========================================
  // MÉTHODES ANCIENNES SUPPRIMÉES - REMPLACÉES PAR LES NOUVELLES EN BAS
  // ========================================

  // Ancienne méthode addToCart supprimée - voir nouvelle version en bas

  // Anciennes méthodes updateCartItem, removeFromCart, getOrders supprimées

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get order');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await _dio.post('/orders', data: orderData);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': BagistoConfig.getSuccessMessage('order_success'),
        };
      }

      throw Exception('Failed to create order');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // BOUTIQUES
  // ========================================

  Future<Map<String, dynamic>> getShops({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/shops',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'pagination': response.data['meta'],
        };
      }

      throw Exception('Failed to get shops');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getShop(String shopId) async {
    try {
      final response = await _dio.get('/shops/$shopId');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get shop');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // RECHERCHE
  // ========================================

  Future<Map<String, dynamic>> search({
    required String query,
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'page': page,
        'limit': limit,
      };

      if (filters != null) queryParams.addAll(filters);

      final response = await _dio.get('/search', queryParameters: queryParams);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'pagination': response.data['meta'],
        };
      }

      throw Exception('Failed to search');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // UTILITAIRES
  // ========================================

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return BagistoConfig.getErrorMessage('network_error');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 401:
              return BagistoConfig.getErrorMessage('auth_error');
            case 403:
              return BagistoConfig.getErrorMessage('forbidden');
            case 404:
              return BagistoConfig.getErrorMessage('not_found');
            case 422:
              return BagistoConfig.getErrorMessage('validation_error');
            case 429:
              return BagistoConfig.getErrorMessage('rate_limit');
            case 500:
            case 502:
            case 503:
              return BagistoConfig.getErrorMessage('server_error');
            default:
              return BagistoConfig.getErrorMessage('server_error');
          }
        case DioExceptionType.connectionError:
          return BagistoConfig.getErrorMessage('network_error');
        default:
          return BagistoConfig.getErrorMessage('network_error');
      }
    }

    return error.toString();
  }

  // Vérifier si l'utilisateur est connecté
  bool get isAuthenticated => _authToken != null;

  // Obtenir le token d'authentification
  String? get authToken => _authToken;

  // ========================================
  // MÉTHODES REST POUR REMPLACER GRAPHQL
  // ========================================

  /// Obtenir les catégories (remplace homeCategories GraphQL)
  Future<Map<String, dynamic>> getCategories({
    List<Map<String, dynamic>>? filters,
  }) async {
    try {
      final response = await _dio.get(
        '/users',
      ); // Utilise users comme catégories

      if (response.statusCode == 200) {
        final List<dynamic> users = response.data;

        // Transformer les users en catégories
        final categories = users
            .map(
              (user) => {
                'id': user['id'],
                'name': user['name'],
                'email': user['email'],
                'company': user['company']['name'],
                'description': user['company']['catchPhrase'],
              },
            )
            .toList();

        return {
          'success': true,
          'data': {'categories': categories, 'total': categories.length},
        };
      }

      return {
        'success': false,
        'message': 'Erreur de récupération des catégories',
      };
    } catch (e) {
      Logger.error('Erreur getCategories', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir les produits (remplace getProducts GraphQL)
  Future<Map<String, dynamic>> getProducts({
    List<Map<String, dynamic>>? filters,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/posts',
        queryParameters: {'_page': page, '_limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> posts = response.data;

        // Transformer les posts en produits
        final products = posts
            .map(
              (post) => {
                'id': post['id'],
                'name': post['title'],
                'description': post['body'],
                'price': (post['id'] * 10.99).toStringAsFixed(
                  2,
                ), // Prix fictif basé sur l'ID
                'category_id': post['userId'],
                'image_url':
                    'https://via.placeholder.com/300x300/4A7C59/FFFFFF?text=Product+${post['id']}',
                'in_stock': true,
                'rating': (4.0 + (post['id'] % 10) / 10).toStringAsFixed(1),
              },
            )
            .toList();

        return {
          'success': true,
          'data': {
            'products': products,
            'total': products.length,
            'page': page,
            'limit': limit,
          },
        };
      }

      return {
        'success': false,
        'message': 'Erreur de récupération des produits',
      };
    } catch (e) {
      Logger.error('Erreur getProducts', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir les détails d'un produit (remplace getProduct GraphQL)
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final response = await _dio.get('/posts/$productId');

      if (response.statusCode == 200) {
        final post = response.data;

        // Transformer le post en détails produit
        final product = {
          'id': post['id'],
          'name': post['title'],
          'description': post['body'],
          'price': (post['id'] * 10.99).toStringAsFixed(2),
          'category_id': post['userId'],
          'image_url':
              'https://via.placeholder.com/600x600/4A7C59/FFFFFF?text=Product+${post['id']}',
          'gallery': [
            'https://via.placeholder.com/600x600/4A7C59/FFFFFF?text=Product+${post['id']}+1',
            'https://via.placeholder.com/600x600/5B8A67/FFFFFF?text=Product+${post['id']}+2',
            'https://via.placeholder.com/600x600/2E7D32/FFFFFF?text=Product+${post['id']}+3',
          ],
          'in_stock': true,
          'stock_quantity': (post['id'] % 50) + 10,
          'rating': (4.0 + (post['id'] % 10) / 10).toStringAsFixed(1),
          'reviews_count': (post['id'] % 100) + 5,
          'specifications': {
            'brand': 'BAZAR',
            'model': 'Model-${post['id']}',
            'warranty': '2 ans',
          },
        };

        return {'success': true, 'data': product};
      }

      return {'success': false, 'message': 'Produit non trouvé'};
    } catch (e) {
      Logger.error('Erreur getProductDetails', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Rechercher des produits (remplace searchProducts GraphQL)
  Future<Map<String, dynamic>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/posts',
        queryParameters: {'title_like': query, '_page': page, '_limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> posts = response.data;

        // Transformer les posts en résultats de recherche
        final products = posts
            .map(
              (post) => {
                'id': post['id'],
                'name': post['title'],
                'description': post['body'],
                'price': (post['id'] * 10.99).toStringAsFixed(2),
                'category_id': post['userId'],
                'image_url':
                    'https://via.placeholder.com/300x300/4A7C59/FFFFFF?text=Product+${post['id']}',
                'in_stock': true,
                'rating': (4.0 + (post['id'] % 10) / 10).toStringAsFixed(1),
              },
            )
            .toList();

        return {
          'success': true,
          'data': {
            'products': products,
            'total': products.length,
            'query': query,
            'page': page,
            'limit': limit,
          },
        };
      }

      return {'success': false, 'message': 'Aucun produit trouvé'};
    } catch (e) {
      Logger.error('Erreur searchProducts', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir le panier (remplace getCart GraphQL)
  Future<Map<String, dynamic>> getCart() async {
    try {
      // Simulation d'un panier avec des données locales
      // En production, ceci ferait un appel à un endpoint dédié

      final cartItems = [
        {
          'id': '1',
          'product_id': '1',
          'product_name': 'Produit Example 1',
          'price': '10.99',
          'quantity': 2,
          'image_url':
              'https://via.placeholder.com/150x150/4A7C59/FFFFFF?text=Cart+1',
          'total': '21.98',
        },
        {
          'id': '2',
          'product_id': '2',
          'product_name': 'Produit Example 2',
          'price': '25.50',
          'quantity': 1,
          'image_url':
              'https://via.placeholder.com/150x150/5B8A67/FFFFFF?text=Cart+2',
          'total': '25.50',
        },
      ];

      final subtotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + double.parse(item['total'] as String),
      );

      return {
        'success': true,
        'data': {
          'items': cartItems,
          'items_count': cartItems.length,
          'subtotal': subtotal.toStringAsFixed(2),
          'tax': (subtotal * 0.1).toStringAsFixed(2),
          'shipping': '5.00',
          'total': (subtotal * 1.1 + 5.0).toStringAsFixed(2),
        },
      };
    } catch (e) {
      Logger.error('Erreur getCart', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Ajouter un produit au panier (remplace addToCart GraphQL)
  Future<Map<String, dynamic>> addToCart(String productId, int quantity) async {
    try {
      // Simulation d'ajout au panier
      // En production, ceci ferait un POST vers l'endpoint panier

      final response = await _dio.get('/posts/$productId');

      if (response.statusCode == 200) {
        final post = response.data;

        return {
          'success': true,
          'message': 'Produit ajouté au panier avec succès',
          'data': {
            'cart_item_id':
                'item_${productId}_${DateTime.now().millisecondsSinceEpoch}',
            'product_id': productId,
            'product_name': post['title'],
            'quantity': quantity,
            'price': (post['id'] * 10.99).toStringAsFixed(2),
          },
        };
      }

      return {'success': false, 'message': 'Produit non trouvé'};
    } catch (e) {
      Logger.error('Erreur addToCart', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir la liste de souhaits (remplace getWishlist GraphQL)
  Future<Map<String, dynamic>> getWishlist() async {
    try {
      // Simulation d'une liste de souhaits
      final wishlistItems = [
        {
          'id': '1',
          'product_id': '5',
          'product_name': 'Produit Favori 1',
          'price': '45.99',
          'image_url':
              'https://via.placeholder.com/200x200/4A7C59/FFFFFF?text=Wish+1',
          'in_stock': true,
        },
        {
          'id': '2',
          'product_id': '8',
          'product_name': 'Produit Favori 2',
          'price': '32.50',
          'image_url':
              'https://via.placeholder.com/200x200/5B8A67/FFFFFF?text=Wish+2',
          'in_stock': false,
        },
      ];

      return {
        'success': true,
        'data': {'items': wishlistItems, 'total': wishlistItems.length},
      };
    } catch (e) {
      Logger.error('Erreur getWishlist', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Ajouter à la liste de souhaits (remplace addToWishlist GraphQL)
  Future<Map<String, dynamic>> addToWishlist(String productId) async {
    try {
      final response = await _dio.get('/posts/$productId');

      if (response.statusCode == 200) {
        final post = response.data;

        return {
          'success': true,
          'message': 'Produit ajouté aux favoris',
          'data': {
            'wishlist_item_id':
                'wish_${productId}_${DateTime.now().millisecondsSinceEpoch}',
            'product_id': productId,
            'product_name': post['title'],
          },
        };
      }

      return {'success': false, 'message': 'Produit non trouvé'};
    } catch (e) {
      Logger.error('Erreur addToWishlist', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir les commandes (remplace getOrders GraphQL)
  Future<Map<String, dynamic>> getOrders({int page = 1, int limit = 10}) async {
    try {
      // Simulation des commandes utilisateur
      final orders = List.generate(
        5,
        (index) => {
          'id': 'ORDER_${1000 + index}',
          'date': DateTime.now()
              .subtract(Duration(days: index * 7))
              .toIso8601String(),
          'status': [
            'delivered',
            'shipped',
            'processing',
            'pending',
          ][index % 4],
          'total': ((index + 1) * 50.99).toStringAsFixed(2),
          'items_count': (index % 3) + 1,
          'shipping_address': 'Adresse de livraison ${index + 1}',
        },
      );

      return {
        'success': true,
        'data': {
          'orders': orders,
          'total': orders.length,
          'page': page,
          'limit': limit,
        },
      };
    } catch (e) {
      Logger.error('Erreur getOrders', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Obtenir les détails d'une commande (remplace getOrderDetails GraphQL)
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      // Simulation des détails de commande
      final orderDetails = {
        'id': orderId,
        'date': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        'status': 'shipped',
        'tracking_number': 'TRK${orderId}2024',
        'subtotal': '89.97',
        'tax': '8.99',
        'shipping': '5.00',
        'total': '103.96',
        'items': [
          {
            'id': '1',
            'product_name': 'Produit Commandé 1',
            'quantity': 2,
            'price': '29.99',
            'total': '59.98',
            'image_url':
                'https://via.placeholder.com/100x100/4A7C59/FFFFFF?text=Order+1',
          },
          {
            'id': '2',
            'product_name': 'Produit Commandé 2',
            'quantity': 1,
            'price': '29.99',
            'total': '29.99',
            'image_url':
                'https://via.placeholder.com/100x100/5B8A67/FFFFFF?text=Order+2',
          },
        ],
        'shipping_address': {
          'name': 'John Doe',
          'address': '123 Rue Example',
          'city': 'Alger',
          'postal_code': '16000',
          'country': 'Algérie',
        },
        'payment_method': 'Carte de crédit',
      };

      return {'success': true, 'data': orderDetails};
    } catch (e) {
      Logger.error('Erreur getOrderDetails', null, e);
      return {'success': false, 'message': e.toString()};
    }
  }
}
