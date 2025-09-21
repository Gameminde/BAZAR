/*
 * Repository abstrait pour le panier
 * Interface commune pour GraphQL et REST
 */

/// Repository abstrait pour le panier
abstract class CartRepository {
  /// Obtenir le contenu du panier
  Future<CartResult> getCart();

  /// Ajouter un produit au panier
  Future<CartResult> addToCart({
    required String productId,
    required int quantity,
    Map<String, dynamic>? attributes,
  });

  /// Mettre à jour la quantité d'un article
  Future<CartResult> updateCartItem({
    required String cartItemId,
    required int quantity,
  });

  /// Retirer un article du panier
  Future<CartResult> removeFromCart(String cartItemId);

  /// Vider le panier
  Future<CartResult> clearCart();

  /// Obtenir le nombre d'articles dans le panier
  int get cartItemCount;

  /// Obtenir le total du panier
  double get cartTotal;
}

/// Résultat d'une opération sur le panier
class CartResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? cartData;
  final String? errorCode;

  const CartResult({
    required this.success,
    required this.message,
    this.cartData,
    this.errorCode,
  });

  factory CartResult.success({
    required String message,
    Map<String, dynamic>? cartData,
  }) {
    return CartResult(success: true, message: message, cartData: cartData);
  }

  factory CartResult.error({required String message, String? errorCode}) {
    return CartResult(success: false, message: message, errorCode: errorCode);
  }
}
