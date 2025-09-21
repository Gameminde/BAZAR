/*
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
}