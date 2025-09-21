#!/usr/bin/env python3
"""
Script pour corriger la navigation bottom bar et la connecter aux routes
"""

import os
import re

def fix_navigation_in_bazar_home():
    """Corrige la navigation dans BazarHomeScreen"""
    
    file_path = "lib/screens/bazar_home/bazar_home_screen.dart"
    
    if not os.path.exists(file_path):
        print(f"❌ Fichier non trouvé: {file_path}")
        return False
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Ajouter les imports nécessaires
        if "import 'package:bazar_marketplace_app/utils/route_constants.dart';" not in content:
            # Trouver la dernière ligne d'import
            import_lines = [line for line in content.split('\n') if line.strip().startswith('import')]
            if import_lines:
                last_import_line = import_lines[-1]
                content = content.replace(last_import_line, f"{last_import_line}\nimport 'package:bazar_marketplace_app/utils/route_constants.dart';")
        
        # Modifier la fonction _onNavItemSelected
        nav_item_selected_pattern = r'_onNavItemSelected\(int index\) \{[^}]+\}'
        
        new_nav_method = '''_onNavItemSelected(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    
    // Navigation vers les écrans correspondants
    switch (index) {
      case 0: // Home
        // Déjà sur la page home
        break;
      case 1: // Categories
        Navigator.pushNamed(context, categoryScreen);
        break;
      case 2: // Cart
        Navigator.pushNamed(context, cartScreen);
        break;
      case 3: // Wishlist
        Navigator.pushNamed(context, wishlistScreen);
        break;
      case 4: // Profile
        Navigator.pushNamed(context, dashboardScreen);
        break;
      default:
        break;
    }
  }'''
        
        if re.search(nav_item_selected_pattern, content, re.DOTALL):
            content = re.sub(nav_item_selected_pattern, new_nav_method, content, flags=re.DOTALL)
        else:
            # Si la méthode n'existe pas, l'ajouter avant la méthode build
            build_pattern = r'@override\s+Widget build\(BuildContext context\)'
            content = re.sub(build_pattern, f'{new_nav_method}\n\n  @override\n  Widget build(BuildContext context)', content)
        
        # Sauvegarder le fichier
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Navigation corrigée dans {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de la correction: {e}")
        return False

def add_navigation_to_product_cards():
    """Ajoute la navigation aux cartes produits"""
    
    file_path = "lib/screens/bazar_home/widgets/product_card.dart"
    
    if not os.path.exists(file_path):
        print(f"❌ Fichier non trouvé: {file_path}")
        return False
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Ajouter l'import pour les routes
        if "import 'package:bazar_marketplace_app/utils/route_constants.dart';" not in content:
            import_lines = [line for line in content.split('\n') if line.strip().startswith('import')]
            if import_lines:
                last_import_line = import_lines[-1]
                content = content.replace(last_import_line, f"{last_import_line}\nimport 'package:bazar_marketplace_app/utils/route_constants.dart';")
        
        # Ajouter la navigation au tap de la carte
        # Chercher le GestureDetector ou InkWell qui entoure la carte
        if 'onTap:' in content and 'Navigator.pushNamed' not in content:
            # Remplacer onTap: () {} par onTap: () { Navigator.pushNamed(context, productScreen, arguments: PassProductData(...)); }
            on_tap_pattern = r'onTap:\s*\(\)\s*\{\s*\}'
            
            new_on_tap = '''onTap: () {
            Navigator.pushNamed(
              context, 
              productScreen,
              arguments: PassProductData(
                productId: product['id'],
                title: product['name'],
                urlKey: product['id'].toString(),
              ),
            );
          }'''
            
            content = re.sub(on_tap_pattern, new_on_tap, content)
        
        # Sauvegarder le fichier
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Navigation ajoutée aux cartes produits dans {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de l'ajout de navigation: {e}")
        return False

def add_navigation_to_categories():
    """Ajoute la navigation aux catégories"""
    
    file_path = "lib/screens/bazar_home/widgets/category_grid.dart"
    
    if not os.path.exists(file_path):
        print(f"❌ Fichier non trouvé: {file_path}")
        return False
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Ajouter l'import pour les routes
        if "import 'package:bazar_marketplace_app/utils/route_constants.dart';" not in content:
            import_lines = [line for line in content.split('\n') if line.strip().startswith('import')]
            if import_lines:
                last_import_line = import_lines[-1]
                content = content.replace(last_import_line, f"{last_import_line}\nimport 'package:bazar_marketplace_app/utils/route_constants.dart';")
        
        # Ajouter la navigation au tap des catégories
        if 'onTap:' in content and 'Navigator.pushNamed' not in content:
            on_tap_pattern = r'onTap:\s*\(\)\s*\{\s*\}'
            
            new_on_tap = '''onTap: () {
            Navigator.pushNamed(
              context, 
              categoryScreen,
              arguments: CategoriesArguments(
                title: category['name'],
                image: '',
                categorySlug: category['name'].toLowerCase(),
                metaDescription: 'Browse ${category['name']} products',
                id: category['name'],
                filters: {},
              ),
            );
          }'''
            
            content = re.sub(on_tap_pattern, new_on_tap, content)
        
        # Sauvegarder le fichier
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Navigation ajoutée aux catégories dans {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de l'ajout de navigation: {e}")
        return False

def create_pass_product_data_class():
    """Crée la classe PassProductData si elle n'existe pas"""
    
    # Vérifier si la classe existe déjà
    data_model_dir = "lib/data_model"
    if os.path.exists(data_model_dir):
        for file in os.listdir(data_model_dir):
            if 'pass_product_data' in file.lower():
                print("✅ Classe PassProductData existe déjà")
                return True
    
    # Créer la classe
    class_content = '''/*
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
}'''
    
    # Créer le fichier
    file_path = "lib/data_model/pass_product_data.dart"
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(class_content)
    
    print(f"✅ Classe PassProductData créée dans {file_path}")
    return True

def main():
    """Fonction principale"""
    print("🔧 CORRECTION DE LA NAVIGATION BOTTOM BAR")
    print("=" * 50)
    
    success_count = 0
    total_tasks = 4
    
    # Créer la classe PassProductData
    if create_pass_product_data_class():
        success_count += 1
    
    # Corriger la navigation dans BazarHomeScreen
    if fix_navigation_in_bazar_home():
        success_count += 1
    
    # Ajouter la navigation aux cartes produits
    if add_navigation_to_product_cards():
        success_count += 1
    
    # Ajouter la navigation aux catégories
    if add_navigation_to_categories():
        success_count += 1
    
    print(f"\n📊 RÉSULTAT: {success_count}/{total_tasks} tâches réussies")
    
    if success_count == total_tasks:
        print("🎉 Navigation bottom bar entièrement corrigée !")
        print("\n💡 PROCHAINES ÉTAPES:")
        print("   1. Tester la navigation entre écrans")
        print("   2. Vérifier que tous les écrans existent")
        print("   3. Ajuster les arguments si nécessaire")
    else:
        print("⚠️ Certaines corrections ont échoué. Vérifiez les erreurs ci-dessus.")

if __name__ == "__main__":
    main()
