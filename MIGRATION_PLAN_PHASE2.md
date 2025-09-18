# 🚀 **PHASE 2 : MIGRATION COMPLÈTE VERS REST API**

## 📋 **PLAN DE MIGRATION SYSTÉMATIQUE**

### **🎯 OBJECTIF**
Remplacer tous les appels GraphQL (`ApiClient()`) par des appels REST (`BazarApiService()`) dans l'ensemble de l'application.

---

## 📊 **ANALYSE DES FICHIERS À MIGRER**

### **Repositories Identifiés (37 fichiers)**
```
✅ CRITIQUES (Fonctionnalités principales)
- home_page_repository.dart - Page d'accueil
- cart_screen_repository.dart - Panier
- product_page_repository.dart - Détails produit
- categories_repository.dart - Catégories
- search_repository.dart - Recherche
- sign_in_repository.dart - Connexion
- sign_up_repository.dart - Inscription

🔄 SECONDAIRES (Fonctionnalités avancées)
- wishlist_repository.dart - Liste de souhaits
- order_list_repo.dart - Liste des commandes
- order_detail_repository.dart - Détails commande
- checkout_*.dart - Processus de commande
- address_repository.dart - Gestion adresses
- account_info_repository.dart - Informations compte

⚡ UTILITAIRES (Fonctions support)
- drawer_repository.dart - Menu navigation
- cms_repository.dart - Contenu CMS
- contact_us_repository.dart - Contact
- review_repo.dart - Avis produits
```

---

## 🔧 **STRATÉGIE DE MIGRATION**

### **Phase 2.1 : Repositories Critiques**
1. **Créer les méthodes REST** dans `BazarApiService`
2. **Migrer les repositories** un par un
3. **Tester chaque migration** individuellement

### **Phase 2.2 : Repositories Secondaires**
1. **Adapter les modèles de données** pour REST
2. **Implémenter les nouvelles méthodes**
3. **Valider la compatibilité**

### **Phase 2.3 : Nettoyage**
1. **Supprimer ApiClient** et code GraphQL
2. **Nettoyer les imports** obsolètes
3. **Tests finaux** de l'application

---

## 🛠️ **IMPLÉMENTATION**

### **Étape 1 : Extension BazarApiService**
Ajouter les méthodes REST manquantes :
```dart
// Catégories
Future<Map<String, dynamic>> getCategories()
Future<Map<String, dynamic>> getCategoryProducts(String categoryId)

// Produits
Future<Map<String, dynamic>> getProducts({Map<String, dynamic>? filters})
Future<Map<String, dynamic>> getProductDetails(String productId)
Future<Map<String, dynamic>> searchProducts(String query)

// Panier
Future<Map<String, dynamic>> getCart()
Future<Map<String, dynamic>> addToCart(String productId, int quantity)
Future<Map<String, dynamic>> updateCartItem(String itemId, int quantity)
Future<Map<String, dynamic>> removeFromCart(String itemId)

// Wishlist
Future<Map<String, dynamic>> getWishlist()
Future<Map<String, dynamic>> addToWishlist(String productId)
Future<Map<String, dynamic>> removeFromWishlist(String productId)
```

### **Étape 2 : Migration Repository Pattern**
Remplacer dans chaque repository :
```dart
// AVANT (GraphQL)
await ApiClient().homeCategories(filters: filters);

// APRÈS (REST)
await BazarApiService().getCategories();
```

### **Étape 3 : Adaptation des Modèles**
Adapter les modèles de données pour les réponses REST :
```dart
// Transformer les réponses JSONPlaceholder en modèles existants
factory CategoryModel.fromRestApi(Map<String, dynamic> json) {
  return CategoryModel(
    id: json['id'],
    name: json['title'], // Mapping JSONPlaceholder
    // ...
  );
}
```

---

## ✅ **CRITÈRES DE VALIDATION**

### **Tests Fonctionnels**
- ✅ Navigation fluide
- ✅ Chargement des données
- ✅ Interactions utilisateur
- ✅ Gestion des erreurs

### **Tests Techniques**
- ✅ Pas d'erreurs 404
- ✅ Réponses API correctes
- ✅ Performance maintenue
- ✅ Logs propres

---

## 📈 **SUIVI DU PROGRÈS**

### **Repositories Migrés**
- [ ] home_page_repository.dart
- [ ] cart_screen_repository.dart
- [ ] product_page_repository.dart
- [ ] categories_repository.dart
- [ ] search_repository.dart
- [ ] sign_in_repository.dart
- [ ] sign_up_repository.dart

### **Métriques**
- **Progression** : 0/37 repositories (0%)
- **Erreurs GraphQL** : En cours d'élimination
- **Performance** : À valider

---

*Plan créé le : $(date)*
*Phase : Migration complète GraphQL → REST*
