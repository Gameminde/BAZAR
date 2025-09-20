/*
 * Product Images - BAZAR 2025
 * Collection d'images de produits pour l'expérience glasmorphisme
 */

/// URLs d'images de produits de haute qualité pour l'e-commerce
class ProductImages {
  // Collection de produits électroniques
  static const String smartphone1 =
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop&auto=format';
  static const String smartphone2 =
      'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500&h=500&fit=crop&auto=format';
  static const String laptop1 =
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop&auto=format';
  static const String laptop2 =
      'https://images.unsplash.com/photo-1609081219090-a6d81d3085bf?w=500&h=500&fit=crop&auto=format';
  static const String headphones1 =
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop&auto=format';
  static const String headphones2 =
      'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop&auto=format';

  // Collection de vêtements
  static const String tshirt1 =
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop&auto=format';
  static const String tshirt2 =
      'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=500&h=500&fit=crop&auto=format';
  static const String jeans1 =
      'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500&h=500&fit=crop&auto=format';
  static const String jeans2 =
      'https://images.unsplash.com/photo-1473265455144-9b1f1b8b4e8e?w=500&h=500&fit=crop&auto=format';
  static const String dress1 =
      'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500&h=500&fit=crop&auto=format';
  static const String dress2 =
      'https://images.unsplash.com/photo-1566479179813-5f3d5e4e4b4e?w=500&h=500&fit=crop&auto=format';

  // Collection de chaussures
  static const String sneakers1 =
      'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500&h=500&fit=crop&auto=format';
  static const String sneakers2 =
      'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&h=500&fit=crop&auto=format';
  static const String boots1 =
      'https://images.unsplash.com/photo-1544966503-7cc5ac882d5c?w=500&h=500&fit=crop&auto=format';
  static const String boots2 =
      'https://images.unsplash.com/photo-1544966503-7cc5ac882d5c?w=500&h=500&fit=crop&auto=format';

  // Collection d'accessoires
  static const String watch1 =
      'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500&h=500&fit=crop&auto=format';
  static const String watch2 =
      'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=500&h=500&fit=crop&auto=format';
  static const String bag1 =
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop&auto=format';
  static const String bag2 =
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500&h=500&fit=crop&auto=format';

  // Collection d'articles ménagers
  static const String furniture1 =
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop&auto=format';
  static const String furniture2 =
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500&h=500&fit=crop&auto=format';
  static const String kitchen1 =
      'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=500&h=500&fit=crop&auto=format';
  static const String kitchen2 =
      'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&h=500&fit=crop&auto=format';

  // Méthode pour obtenir une image aléatoire selon la catégorie
  static String getRandomImageForCategory(String category) {
    final Map<String, List<String>> categoryImages = {
      'electronics': [
        smartphone1,
        smartphone2,
        laptop1,
        laptop2,
        headphones1,
        headphones2,
      ],
      'clothing': [tshirt1, tshirt2, jeans1, jeans2, dress1, dress2],
      'shoes': [sneakers1, sneakers2, boots1, boots2],
      'accessories': [watch1, watch2, bag1, bag2],
      'home': [furniture1, furniture2, kitchen1, kitchen2],
    };

    final images = categoryImages[category] ?? categoryImages['electronics']!;
    return images[DateTime.now().millisecondsSinceEpoch % images.length];
  }

  // Méthode pour obtenir une image aléatoire générale
  static String getRandomProductImage() {
    final allImages = [
      smartphone1,
      smartphone2,
      laptop1,
      laptop2,
      headphones1,
      headphones2,
      tshirt1,
      tshirt2,
      jeans1,
      jeans2,
      dress1,
      dress2,
      sneakers1,
      sneakers2,
      boots1,
      boots2,
      watch1,
      watch2,
      bag1,
      bag2,
      furniture1,
      furniture2,
      kitchen1,
      kitchen2,
    ];
    return allImages[DateTime.now().millisecondsSinceEpoch % allImages.length];
  }
}
