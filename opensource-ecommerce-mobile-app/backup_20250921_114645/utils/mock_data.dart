/*
 * Données mock pour BAZAR - Test web sans serveur GraphQL
 */

class MockData {
  static const Map<String, dynamic> homePageData = {
    "data": {
      "homePageData": {
        "sliderData": [
          {
            "id": "1",
            "title": "BAZAR Marketplace",
            "subTitle": "Découvrez nos produits",
            "imageUrl": "assets/images/placeholder.png",
            "redirectUrl": "/products",
          },
        ],
        "featuredCategories": [
          {
            "id": "1",
            "name": "Électronique",
            "imageUrl": "assets/images/categorie_placeholder.png",
            "slug": "electronique",
          },
          {
            "id": "2",
            "name": "Mode",
            "imageUrl": "assets/images/categorie_placeholder.png",
            "slug": "mode",
          },
          {
            "id": "3",
            "name": "Maison",
            "imageUrl": "assets/images/categorie_placeholder.png",
            "slug": "maison",
          },
        ],
        "newProducts": [
          {
            "id": "1",
            "name": "Produit Exemple 1",
            "price": "29.99",
            "imageUrl": "assets/images/placeholder.png",
            "slug": "produit-exemple-1",
          },
          {
            "id": "2",
            "name": "Produit Exemple 2",
            "price": "49.99",
            "imageUrl": "assets/images/placeholder.png",
            "slug": "produit-exemple-2",
          },
        ],
      },
    },
  };

  static const Map<String, dynamic> categoriesData = {
    "data": {
      "categories": [
        {
          "id": "1",
          "name": "Électronique",
          "imageUrl": "assets/images/categorie_placeholder.png",
          "slug": "electronique",
          "productCount": 25,
        },
        {
          "id": "2",
          "name": "Mode & Accessoires",
          "imageUrl": "assets/images/categorie_placeholder.png",
          "slug": "mode",
          "productCount": 18,
        },
        {
          "id": "3",
          "name": "Maison & Jardin",
          "imageUrl": "assets/images/categorie_placeholder.png",
          "slug": "maison",
          "productCount": 32,
        },
        {
          "id": "4",
          "name": "Sports & Loisirs",
          "imageUrl": "assets/images/categorie_placeholder.png",
          "slug": "sports",
          "productCount": 15,
        },
      ],
    },
  };

  static const Map<String, dynamic> productsData = {
    "data": {
      "products": [
        {
          "id": "1",
          "name": "Smartphone BAZAR Pro",
          "price": "299.99",
          "originalPrice": "399.99",
          "imageUrl": "assets/images/placeholder.png",
          "slug": "smartphone-bazar-pro",
          "description":
              "Smartphone haut de gamme avec toutes les fonctionnalités modernes",
          "rating": 4.5,
          "reviewCount": 128,
        },
        {
          "id": "2",
          "name": "Laptop BAZAR Ultra",
          "price": "899.99",
          "originalPrice": "1199.99",
          "imageUrl": "assets/images/placeholder.png",
          "slug": "laptop-bazar-ultra",
          "description": "Laptop performant pour le travail et les loisirs",
          "rating": 4.8,
          "reviewCount": 89,
        },
        {
          "id": "3",
          "name": "Casque Audio BAZAR",
          "price": "79.99",
          "originalPrice": "99.99",
          "imageUrl": "assets/images/placeholder.png",
          "slug": "casque-audio-bazar",
          "description": "Casque audio sans fil avec réduction de bruit",
          "rating": 4.3,
          "reviewCount": 256,
        },
      ],
    },
  };
}
