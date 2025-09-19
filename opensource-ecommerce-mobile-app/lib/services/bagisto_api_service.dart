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
  // PRODUITS
  // ========================================

  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    Map<String, dynamic>? filters,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;
      if (filters != null) queryParams.addAll(filters);

      final response = await _dio.get(
        '/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'pagination': response.data['meta'],
        };
      }

      throw Exception('Failed to get products');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getProduct(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get product');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getRelatedProducts(String productId) async {
    try {
      final response = await _dio.get('/products/$productId/related');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get related products');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // CATÉGORIES
  // ========================================

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _dio.get('/categories');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get categories');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getCategory(String categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get category');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // PANIER
  // ========================================

  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get('/cart');

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to get cart');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    Map<String, dynamic>? attributes,
  }) async {
    try {
      final response = await _dio.post(
        '/cart/add',
        data: {
          'product_id': productId,
          'quantity': quantity,
          'attributes': attributes ?? {},
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': BagistoConfig.getSuccessMessage('cart_add'),
        };
      }

      throw Exception('Failed to add to cart');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.put(
        '/cart/$cartItemId',
        data: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }

      throw Exception('Failed to update cart item');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> removeFromCart(String cartItemId) async {
    try {
      final response = await _dio.delete('/cart/$cartItemId');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Produit retiré du panier'};
      }

      throw Exception('Failed to remove from cart');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ========================================
  // COMMANDES
  // ========================================

  Future<Map<String, dynamic>> getOrders({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/orders',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'pagination': response.data['meta'],
        };
      }

      throw Exception('Failed to get orders');
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

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
}
