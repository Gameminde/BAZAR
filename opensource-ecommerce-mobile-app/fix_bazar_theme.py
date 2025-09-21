#!/usr/bin/env python3
"""
Script pour ajouter les propriétés manquantes à BazarTheme
"""

import os
import re

def add_missing_properties_to_bazar_theme():
    """Ajoute les propriétés manquantes à BazarTheme"""
    
    theme_file = 'lib/utils/bazar_theme.dart'
    
    try:
        with open(theme_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Propriétés manquantes à ajouter
        missing_properties = [
            'static const Color accentColor = Color(0xFF4A7C59);',
            'static const Color primaryColor = Color(0xFF4A7C59);',
            'static const Color linkColor = Color(0xFF2E7D32);',
            'static const Color warningColor = Color(0xFFFF9800);',
            'static const Color greyColor = Color(0xFF9E9E9E);',
            'static const Color transparentColor = Colors.transparent;',
            'static const Color appbarTextColor = Colors.white;',
            'static const Color skeletonLoaderColorLight = Color(0xFFE0E0E0);',
            'static const Color skeletonLoaderColorDark = Color(0xFF424242);',
        ]
        
        # Trouver où insérer les propriétés (après la classe)
        class_match = re.search(r'class BazarTheme \{', content)
        if class_match:
            insert_pos = class_match.end()
            
            # Construire le texte à insérer
            properties_text = '\n  // Propriétés manquantes ajoutées automatiquement\n'
            for prop in missing_properties:
                properties_text += f'  {prop}\n'
            properties_text += '\n'
            
            # Insérer les propriétés
            content = content[:insert_pos] + properties_text + content[insert_pos:]
            
            # Sauvegarder
            with open(theme_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✅ Propriétés ajoutées à {theme_file}")
            return True
        else:
            print(f"❌ Classe BazarTheme non trouvée dans {theme_file}")
            return False
            
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False

def fix_remaining_imports():
    """Corrige les imports restants"""
    
    fixes = [
        # Supprimer l'import cassé
        (r"export 'glassmorphic_app_bar.dart';", ""),
        
        # Corriger les imports de fichiers supprimés
        (r"import 'lib/widgets/glassmorphism/final_test_demo.dart';", ""),
        (r"import '../../../utils/mobikul_theme.dart';", ""),
        
        # Remplacer les constantes invalides
        (r'const Color\(BazarTheme\.accentColor\)', 'BazarTheme.accentColor'),
        (r'const Color\(BazarTheme\.primaryColor\)', 'BazarTheme.primaryColor'),
        (r'const Color\(BazarTheme\.linkColor\)', 'BazarTheme.linkColor'),
        (r'const Color\(BazarTheme\.warningColor\)', 'BazarTheme.warningColor'),
        (r'const Color\(BazarTheme\.greyColor\)', 'BazarTheme.greyColor'),
        (r'const Color\(BazarTheme\.transparentColor\)', 'BazarTheme.transparentColor'),
    ]
    
    # Trouver tous les fichiers Dart
    dart_files = []
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                dart_files.append(os.path.join(root, file))
    
    # Ajouter les fichiers de test
    import glob
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

if __name__ == "__main__":
    print("🔧 Correction finale des thèmes et imports...")
    
    # Ajouter les propriétés manquantes à BazarTheme
    theme_fixed = add_missing_properties_to_bazar_theme()
    
    # Corriger les imports restants
    imports_fixed = fix_remaining_imports()
    
    print(f"\n✅ Nettoyage final terminé !")
    print(f"   - Thème: {'✅' if theme_fixed else '❌'}")
    print(f"   - Imports: {imports_fixed} fichiers")
