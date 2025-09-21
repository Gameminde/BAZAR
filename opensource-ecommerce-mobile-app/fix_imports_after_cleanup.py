#!/usr/bin/env python3
"""
Script de correction automatique des imports après nettoyage
Corrige tous les imports cassés suite à la suppression des doublons
"""

import os
import re
from pathlib import Path

def fix_imports():
    """Corrige tous les imports cassés après nettoyage"""
    
    print("🔧 CORRECTION AUTOMATIQUE DES IMPORTS")
    print("=" * 50)
    
    # Dossier racine du projet
    lib_dir = Path("lib")
    
    # Mappings de remplacement
    import_replacements = {
        # Thèmes
        "package:bazar_marketplace_app/utils/mobikul_theme.dart": "package:bazar_marketplace_app/utils/bazar_theme.dart",
        "package:bazar_marketplace_app/utils/glassmorphism_theme.dart": "package:bazar_marketplace_app/utils/bazar_theme.dart",
        "package:bazar_marketplace_app/utils/glassmorphism_theme_extension.dart": "package:bazar_marketplace_app/utils/bazar_theme.dart",
        
        # Composants glassmorphic doublons
        "package:bazar_marketplace_app/widgets/glassmorphic_appbar_simple.dart": "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart",
        "package:bazar_marketplace_app/widgets/glassmorphism_app_bar.dart": "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart",
        "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_appbar.dart": "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart",
        "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_button.dart": "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart",
        "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_button_clean.dart": "package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart",
        
        # Écrans home doublons
        "package:bazar_marketplace_app/screens/home_page/home_page.dart": "package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart",
        "package:bazar_marketplace_app/screens/home_page/simple_glassmorphic_home.dart": "package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart",
        "package:bazar_marketplace_app/screens/home_page/glassmorphic_home_page.dart": "package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart",
    }
    
    # Classes de remplacement
    class_replacements = {
        # Thèmes
        "MobiKulTheme": "BazarTheme",
        "GlassmorphismTheme": "BazarTheme",
        
        # Composants glassmorphic
        "GlassmorphicAppBar": "GlassmorphicAppBar",  # Garde le même nom
        "GlassmorphicButton": "GlassmorphicButton",  # Garde le même nom
        "GlassmorphicIconButton": "GlassmorphicIconButton",  # Garde le même nom
        
        # Écrans home
        "HomeScreen": "BazarHomeScreen",
        "SimpleGlassmorphicHome": "BazarHomeScreen",
        "GlassmorphicHomePage": "BazarHomeScreen",
    }
    
    # Collecte tous les fichiers Dart
    dart_files = list(lib_dir.rglob("*.dart"))
    
    files_modified = 0
    total_replacements = 0
    
    print(f"📊 Analyse de {len(dart_files)} fichiers Dart...")
    print()
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            file_replacements = 0
            
            # Remplace les imports
            for old_import, new_import in import_replacements.items():
                if old_import in content:
                    content = content.replace(old_import, new_import)
                    file_replacements += 1
            
            # Remplace les classes
            for old_class, new_class in class_replacements.items():
                if old_class in content:
                    content = content.replace(old_class, new_class)
                    file_replacements += 1
            
            # Écrit le fichier modifié si nécessaire
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                files_modified += 1
                total_replacements += file_replacements
                
                relative_path = file_path.relative_to(lib_dir)
                print(f"✅ {relative_path} - {file_replacements} remplacement(s)")
                
        except Exception as e:
            print(f"⚠️  Erreur avec {file_path}: {e}")
    
    print()
    print("=" * 50)
    print(f"✅ CORRECTION TERMINÉE")
    print(f"📄 Fichiers modifiés: {files_modified}")
    print(f"🔄 Total remplacements: {total_replacements}")
    print()
    
    return files_modified, total_replacements

def fix_app_navigation():
    """Corrige spécifiquement app_navigation.dart"""
    
    print("🔧 CORRECTION APP_NAVIGATION.DART")
    print("=" * 40)
    
    nav_file = Path("lib/utils/app_navigation.dart")
    
    if not nav_file.exists():
        print("⚠️  Fichier app_navigation.dart non trouvé")
        return False
    
    try:
        with open(nav_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remplace SimpleGlassmorphicHome par BazarHomeScreen
        if "SimpleGlassmorphicHome" in content:
            content = content.replace("SimpleGlassmorphicHome", "BazarHomeScreen")
            
            # Ajoute l'import si nécessaire
            if "package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart" not in content:
                # Trouve la ligne d'import et ajoute le nouvel import
                lines = content.split('\n')
                for i, line in enumerate(lines):
                    if line.startswith("import 'package:bazar_marketplace_app/screens/home_page/"):
                        lines.insert(i + 1, "import 'package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart';")
                        break
                
                content = '\n'.join(lines)
            
            # Supprime l'ancien import
            content = re.sub(
                r"import 'package:bazar_marketplace_app/screens/home_page/simple_glassmorphic_home\.dart';\n?",
                "",
                content
            )
            
            with open(nav_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print("✅ app_navigation.dart corrigé")
            return True
        else:
            print("ℹ️  Aucune correction nécessaire dans app_navigation.dart")
            return True
            
    except Exception as e:
        print(f"❌ Erreur lors de la correction de app_navigation.dart: {e}")
        return False

def validate_fixes():
    """Valide que les corrections sont correctes"""
    
    print("🔍 VALIDATION DES CORRECTIONS")
    print("=" * 35)
    
    # Vérifie que les fichiers supprimés ne sont plus importés
    lib_dir = Path("lib")
    dart_files = list(lib_dir.rglob("*.dart"))
    
    removed_files = [
        "mobikul_theme.dart",
        "glassmorphism_theme.dart", 
        "glassmorphic_appbar_simple.dart",
        "glassmorphic_app_bar.dart",
        "home_page.dart",
        "simple_glassmorphic_home.dart",
        "glassmorphic_home_page.dart"
    ]
    
    issues_found = 0
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            for removed_file in removed_files:
                if removed_file in content:
                    relative_path = file_path.relative_to(lib_dir)
                    print(f"⚠️  {relative_path} - Référence à {removed_file} trouvée")
                    issues_found += 1
                    
        except Exception as e:
            print(f"⚠️  Erreur lecture {file_path}: {e}")
    
    if issues_found == 0:
        print("✅ Aucun problème détecté")
    else:
        print(f"⚠️  {issues_found} problème(s) détecté(s)")
    
    return issues_found == 0

if __name__ == "__main__":
    try:
        # Exécute les corrections
        files_modified, total_replacements = fix_imports()
        nav_success = fix_app_navigation()
        validation_success = validate_fixes()
        
        print()
        print("=" * 50)
        print("📋 RAPPORT FINAL")
        print("=" * 50)
        print(f"📄 Fichiers modifiés: {files_modified}")
        print(f"🔄 Total remplacements: {total_replacements}")
        print(f"🔧 app_navigation.dart: {'✅ OK' if nav_success else '❌ ERREUR'}")
        print(f"🔍 Validation: {'✅ OK' if validation_success else '⚠️  PROBLÈMES'}")
        
        if validation_success and nav_success:
            print()
            print("🎉 TOUTES LES CORRECTIONS RÉUSSIES!")
            print()
            print("Prochaines étapes:")
            print("1. flutter clean && flutter pub get")
            print("2. flutter analyze")
            print("3. flutter build web --no-wasm-dry-run")
            print("4. Tester la navigation dans l'app")
        else:
            print()
            print("⚠️  CORRECTIONS PARTIELLES - Vérification manuelle requise")
            
    except Exception as e:
        print(f"❌ Erreur lors de l'exécution: {e}")
        print("💡 Vérifiez que vous êtes dans le bon répertoire du projet")

