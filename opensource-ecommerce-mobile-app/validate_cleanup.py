#!/usr/bin/env python3
"""
Script de validation après nettoyage
Vérifie que le nettoyage a été effectué correctement
"""

import os
from pathlib import Path

def validate_cleanup():
    """Valide que le nettoyage a été effectué correctement"""
    
    print("🔍 VALIDATION POST-NETTOYAGE")
    print("=" * 40)
    
    lib_dir = Path("lib")
    
    # Fichiers qui DOIVENT être supprimés
    files_to_be_removed = [
        # Écrans home doublons
        "lib/screens/home_page/home_page.dart",
        "lib/screens/home_page/simple_glassmorphic_home.dart", 
        "lib/screens/home_page/glassmorphic_home_page.dart",
        
        # Composants glassmorphic doublons
        "lib/widgets/glassmorphic_appbar_simple.dart",
        "lib/widgets/glassmorphism_app_bar.dart",
        "lib/widgets/glassmorphism/glassmorphic_appbar.dart",
        "lib/widgets/glassmorphism/glassmorphic_button.dart",
        "lib/widgets/glassmorphism/glassmorphic_button_clean.dart",
        
        # Thèmes doublons
        "lib/utils/mobikul_theme.dart",
        "lib/utils/glassmorphism_theme.dart",
        "lib/utils/glassmorphism_theme_extension.dart",
    ]
    
    # Fichiers qui DOIVENT être présents
    files_to_be_present = [
        # Écran home unifié
        "lib/screens/bazar_home/bazar_home_screen.dart",
        
        # Composant glassmorphic consolidé
        "lib/widgets/glassmorphism/glassmorphic_components.dart",
        
        # Thème unifié
        "lib/utils/bazar_theme.dart",
    ]
    
    print("📋 VÉRIFICATION DES FICHIERS SUPPRIMÉS")
    print("-" * 40)
    
    removed_count = 0
    still_present = []
    
    for file_path in files_to_be_removed:
        if Path(file_path).exists():
            still_present.append(file_path)
            print(f"❌ {file_path} - ENCORE PRÉSENT")
        else:
            removed_count += 1
            print(f"✅ {file_path} - SUPPRIMÉ")
    
    print()
    print("📋 VÉRIFICATION DES FICHIERS CONSERVÉS")
    print("-" * 40)
    
    present_count = 0
    missing_files = []
    
    for file_path in files_to_be_present:
        if Path(file_path).exists():
            present_count += 1
            print(f"✅ {file_path} - PRÉSENT")
        else:
            missing_files.append(file_path)
            print(f"❌ {file_path} - MANQUANT")
    
    print()
    print("📊 STATISTIQUES")
    print("-" * 20)
    print(f"Fichiers supprimés: {removed_count}/{len(files_to_be_removed)}")
    print(f"Fichiers conservés: {present_count}/{len(files_to_be_present)}")
    
    if still_present:
        print(f"⚠️  Fichiers encore présents: {len(still_present)}")
    if missing_files:
        print(f"❌ Fichiers manquants: {len(missing_files)}")
    
    # Vérification des imports cassés
    print()
    print("🔍 VÉRIFICATION DES IMPORTS")
    print("-" * 30)
    
    dart_files = list(lib_dir.rglob("*.dart"))
    broken_imports = []
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Vérifie les imports vers des fichiers supprimés
            for removed_file in files_to_be_removed:
                if removed_file.replace("lib/", "package:bazar_marketplace_app/") in content:
                    broken_imports.append({
                        'file': str(file_path.relative_to(lib_dir)),
                        'import': removed_file
                    })
                    
        except Exception as e:
            print(f"⚠️  Erreur lecture {file_path}: {e}")
    
    if broken_imports:
        print(f"❌ {len(broken_imports)} imports cassés détectés:")
        for broken in broken_imports:
            print(f"   📄 {broken['file']}")
            print(f"      └── {broken['import']}")
    else:
        print("✅ Aucun import cassé détecté")
    
    # Résumé final
    print()
    print("=" * 40)
    print("📋 RÉSUMÉ DE VALIDATION")
    print("=" * 40)
    
    success = (removed_count == len(files_to_be_removed) and 
               present_count == len(files_to_be_present) and 
               len(broken_imports) == 0)
    
    if success:
        print("🎉 NETTOYAGE RÉUSSI!")
        print("✅ Tous les fichiers ont été supprimés/conservés correctement")
        print("✅ Aucun import cassé détecté")
        print()
        print("Prochaines étapes:")
        print("1. flutter clean && flutter pub get")
        print("2. flutter analyze")
        print("3. flutter build web --no-wasm-dry-run")
        print("4. Tester l'application")
    else:
        print("⚠️  NETTOYAGE PARTIEL")
        if still_present:
            print(f"❌ {len(still_present)} fichier(s) encore présent(s)")
        if missing_files:
            print(f"❌ {len(missing_files)} fichier(s) manquant(s)")
        if broken_imports:
            print(f"❌ {len(broken_imports)} import(s) cassé(s)")
        
        print()
        print("Actions requises:")
        print("1. Supprimer manuellement les fichiers encore présents")
        print("2. Restaurer les fichiers manquants si nécessaire")
        print("3. Corriger les imports cassés")
    
    return success

def check_project_structure():
    """Vérifie la structure finale du projet"""
    
    print()
    print("🏗️  VÉRIFICATION DE LA STRUCTURE")
    print("-" * 35)
    
    # Structure attendue après nettoyage
    expected_structure = {
        "lib/screens/bazar_home/": "Écran home unifié",
        "lib/widgets/glassmorphism/glassmorphic_components.dart": "Composants glassmorphic consolidés",
        "lib/utils/bazar_theme.dart": "Thème BAZAR unifié",
        "lib/main.dart": "Point d'entrée principal",
        "lib/utils/app_navigation.dart": "Navigation configurée",
    }
    
    structure_ok = True
    
    for path, description in expected_structure.items():
        if Path(path).exists():
            print(f"✅ {path} - {description}")
        else:
            print(f"❌ {path} - {description} - MANQUANT")
            structure_ok = False
    
    return structure_ok

if __name__ == "__main__":
    try:
        cleanup_success = validate_cleanup()
        structure_ok = check_project_structure()
        
        print()
        print("=" * 50)
        print("🏁 VALIDATION TERMINÉE")
        print("=" * 50)
        
        if cleanup_success and structure_ok:
            print("🎉 PROJET PRÊT POUR LE DÉVELOPPEMENT!")
            print("✅ Nettoyage réussi")
            print("✅ Structure correcte")
            print("✅ Aucun problème détecté")
        else:
            print("⚠️  PROJET NÉCESSITE ENCORE DES CORRECTIONS")
            print("Veuillez corriger les problèmes identifiés avant de continuer")
            
    except Exception as e:
        print(f"❌ Erreur lors de la validation: {e}")
        print("💡 Vérifiez que vous êtes dans le bon répertoire du projet")

