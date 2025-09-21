/*
 *   BAZAR Marketplace
 *   Data model for passing product data between screens
 */

class PassProductData {
  final int? productId;
  final String? title;
  final String? urlKey;
  final String? image;
  final double? price;

  PassProductData({
    this.productId,
    this.title,
    this.urlKey,
    this.image,
    this.price,
  });
}

class CategoriesArguments {
  final String title;
  final String image;
  final String categorySlug;
  final String metaDescription;
  final String id;
  final Map<String, dynamic> filters;

  CategoriesArguments({
    required this.title,
    required this.image,
    required this.categorySlug,
    required this.metaDescription,
    required this.id,
    required this.filters,
  });
}