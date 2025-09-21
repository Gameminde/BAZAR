/*
 * Repository abstrait pour les produits
 * Interface commune pour GraphQL et REST
 */

/// Repository abstrait pour les produits
abstract class ProductRepository {
  /// Obtenir la liste des produits
  Future<ProductResult> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    Map<String, dynamic>? filters,
    String? sort,
  });

  /// Obtenir un produit par ID
  Future<ProductResult> getProduct(String productId);

  /// Obtenir les produits liés
  Future<ProductResult> getRelatedProducts(String productId);

  /// Obtenir les produits recommandés
  Future<ProductResult> getRecommendedProducts(String? userId);

  /// Rechercher des produits
  Future<ProductResult> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  });
}

/// Résultat d'une opération sur les produits
class ProductResult {
  final bool success;
  final String message;
  final List<Map<String, dynamic>>? products;
  final Map<String, dynamic>? pagination;
  final String? errorCode;

  const ProductResult({
    required this.success,
    required this.message,
    this.products,
    this.pagination,
    this.errorCode,
  });

  factory ProductResult.success({
    required String message,
    List<Map<String, dynamic>>? products,
    Map<String, dynamic>? pagination,
  }) {
    return ProductResult(
      success: true,
      message: message,
      products: products,
      pagination: pagination,
    );
  }

  factory ProductResult.error({required String message, String? errorCode}) {
    return ProductResult(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }
}
