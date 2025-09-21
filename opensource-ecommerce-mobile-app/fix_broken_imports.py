#!/usr/bin/env python3
"""
Script pour corriger automatiquement les imports cassés après le nettoyage
"""

import os
import re
import glob

def fix_imports():
    """Corrige tous les imports cassés dans le projet"""
    
    # Patterns de corrections
    fixes = [
        # MobiKulTheme -> BazarTheme
        (r'MobiKulTheme', 'BazarTheme'),
        
        # Imports cassés
        (r"import 'package:bazar_marketplace_app/utils/mobikul_theme.dart';", 
         "import 'package:bazar_marketplace_app/utils/bazar_theme.dart';"),
        (r"import 'mobikul_theme.dart';", 
         "import 'bazar_theme.dart';"),
        
        # Imports de fichiers supprimés
        (r"import 'package:bazar_marketplace_app/widgets/glassmorphism/final_test_demo.dart';", ""),
        (r"import 'package:bazar_marketplace_app/widgets/glassmorphic_appbar_simple.dart';", ""),
        (r"import 'package:bazar_marketplace_app/widgets/glassmorphism/glassmorphism_example.dart';", ""),
        
        # Index cassés
        (r"import 'final_test_demo.dart';", ""),
        (r"import 'glassmorphic_appbar_simple.dart';", ""),
    ]
    
    # Trouver tous les fichiers Dart
    dart_files = []
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                dart_files.append(os.path.join(root, file))
    
    # Ajouter les fichiers de test
    for file in glob.glob('test*.dart'):
        dart_files.append(file)
    
    fixed_count = 0
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Appliquer les corrections
            for pattern, replacement in fixes:
                content = re.sub(pattern, replacement, content)
            
            # Nettoyer les lignes vides multiples
            content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
            
            # Si le contenu a changé, sauvegarder
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Corrigé: {file_path}")
                fixed_count += 1
        
        except Exception as e:
            print(f"❌ Erreur avec {file_path}: {e}")
    
    print(f"\n🎯 {fixed_count} fichiers corrigés")
    return fixed_count

def remove_broken_imports():
    """Supprime les imports cassés qui ne peuvent pas être corrigés"""
    
    broken_files = [
        'lib/widgets/glassmorphism.dart',
        'lib/widgets/glassmorphic_app_bar.dart',
    ]
    
    for file_path in broken_files:
        if os.path.exists(file_path):
            try:
                os.remove(file_path)
                print(f"🗑️ Supprimé: {file_path}")
            except Exception as e:
                print(f"❌ Erreur suppression {file_path}: {e}")

if __name__ == "__main__":
    print("🔧 Correction des imports cassés...")
    fixed = fix_imports()
    remove_broken_imports()
    print(f"\n✅ Nettoyage terminé ! {fixed} fichiers corrigés")
