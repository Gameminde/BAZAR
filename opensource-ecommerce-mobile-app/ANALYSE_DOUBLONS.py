#!/usr/bin/env python3
"""
Script d'analyse exhaustive des doublons - BAZAR Marketplace
Identifie tous les fichiers similaires, doublons et conflits
"""

import os
import re
from collections import defaultdict
from pathlib import Path

def analyze_dart_files():
    """Analyse tous les fichiers Dart du projet"""
    
    print("🔍 ANALYSE EXHAUSTIVE DES DOUBLONS - BAZAR MARKETPLACE")
    print("=" * 60)
    
    # Dossier racine du projet
    project_root = Path(".")
    lib_dir = project_root / "lib"
    
    # Collecte tous les fichiers Dart
    dart_files = list(lib_dir.rglob("*.dart"))
    
    print(f"📊 TOTAL FICHIERS DART: {len(dart_files)}")
    print()
    
    # Analyse par catégories
    categories = {
        'home_screens': [],
        'glassmorphic': [],
        'themes': [],
        'widgets': [],
        'models': [],
        'utils': [],
        'other': []
    }
    
    for file_path in dart_files:
        relative_path = file_path.relative_to(lib_dir)
        path_str = str(relative_path)
        
        if 'home' in path_str.lower():
            categories['home_screens'].append(path_str)
        elif 'glassmorphic' in path_str.lower() or 'glass' in path_str.lower():
            categories['glassmorphic'].append(path_str)
        elif 'theme' in path_str.lower():
            categories['themes'].append(path_str)
        elif 'widget' in path_str.lower():
            categories['widgets'].append(path_str)
        elif 'model' in path_str.lower() or 'data_model' in path_str.lower():
            categories['models'].append(path_str)
        elif 'util' in path_str.lower():
            categories['utils'].append(path_str)
        else:
            categories['other'].append(path_str)
    
    # Affichage des catégories
    for category, files in categories.items():
        if files:
            print(f"📁 {category.upper()}: {len(files)} fichiers")
            for file in sorted(files):
                print(f"   ├── {file}")
            print()
    
    return categories

def find_similar_files():
    """Trouve les fichiers avec des noms similaires"""
    
    print("🔍 RECHERCHE DE FICHIERS SIMILAIRES")
    print("=" * 40)
    
    lib_dir = Path("lib")
    dart_files = list(lib_dir.rglob("*.dart"))
    
    # Groupe par nom de fichier (sans extension)
    name_groups = defaultdict(list)
    
    for file_path in dart_files:
        relative_path = file_path.relative_to(lib_dir)
        name = relative_path.stem  # nom sans extension
        name_groups[name].append(str(relative_path))
    
    # Trouve les doublons potentiels
    duplicates = {name: paths for name, paths in name_groups.items() if len(paths) > 1}
    
    if duplicates:
        print("🚨 DOUBLONS POTENTIELS DÉTECTÉS:")
        for name, paths in duplicates.items():
            print(f"\n📄 {name}.dart:")
            for path in paths:
                print(f"   ├── {path}")
    else:
        print("✅ Aucun doublon exact détecté")
    
    return duplicates

def analyze_imports():
    """Analyse les imports pour détecter les conflits"""
    
    print("\n🔍 ANALYSE DES IMPORTS")
    print("=" * 30)
    
    lib_dir = Path("lib")
    dart_files = list(lib_dir.rglob("*.dart"))
    
    import_patterns = defaultdict(list)
    glassmorphic_imports = []
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
                # Trouve tous les imports
                imports = re.findall(r"import\s+['\"]([^'\"]+)['\"]", content)
                
                for imp in imports:
                    if 'glassmorphic' in imp.lower() or 'glass' in imp.lower():
                        glassmorphic_imports.append({
                            'file': str(file_path.relative_to(lib_dir)),
                            'import': imp
                        })
                    
                    # Groupe par pattern d'import
                    if 'widgets/' in imp:
                        import_patterns['widgets'].append({
                            'file': str(file_path.relative_to(lib_dir)),
                            'import': imp
                        })
                        
        except Exception as e:
            print(f"⚠️  Erreur lecture {file_path}: {e}")
    
    print(f"📊 IMPORTS GLASSMORPHIC DÉTECTÉS: {len(glassmorphic_imports)}")
    for item in glassmorphic_imports:
        print(f"   📄 {item['file']}")
        print(f"      └── {item['import']}")
    
    return glassmorphic_imports

def generate_cleanup_recommendations():
    """Génère des recommandations de nettoyage"""
    
    print("\n🎯 RECOMMANDATIONS DE NETTOYAGE")
    print("=" * 40)
    
    recommendations = [
        {
            'priority': '🚨 CRITIQUE',
            'action': 'Supprimer les écrans home doublons',
            'files': [
                'lib/screens/home_page/home_page.dart',
                'lib/screens/home_page/simple_glassmorphic_home.dart',
                'lib/screens/home_page/glassmorphic_home_page.dart'
            ],
            'keep': 'lib/screens/bazar_home/bazar_home_screen.dart'
        },
        {
            'priority': '🚨 CRITIQUE', 
            'action': 'Supprimer les composants glassmorphic doublons',
            'files': [
                'lib/widgets/glassmorphic_appbar_simple.dart',
                'lib/widgets/glassmorphism_app_bar.dart',
                'lib/widgets/glassmorphism/glassmorphic_appbar.dart',
                'lib/widgets/glassmorphism/glassmorphic_button.dart',
                'lib/widgets/glassmorphism/glassmorphic_button_clean.dart'
            ],
            'keep': 'lib/widgets/glassmorphism/glassmorphic_components.dart'
        },
        {
            'priority': '⚠️  IMPORTANT',
            'action': 'Supprimer les thèmes doublons',
            'files': [
                'lib/utils/mobikul_theme.dart',
                'lib/utils/glassmorphism_theme.dart',
                'lib/utils/glassmorphism_theme_extension.dart'
            ],
            'keep': 'lib/utils/bazar_theme.dart'
        },
        {
            'priority': '🔧 OPTIONNEL',
            'action': 'Nettoyer les fichiers de test/démo',
            'files': [
                'lib/widgets/glassmorphism/final_test_demo.dart',
                'lib/widgets/glassmorphism/glassmorphism_test.dart',
                'lib/widgets/glassmorphism/glassmorphism_example.dart',
                'lib/widgets/glassmorphism/transformation_demo.dart',
                'lib/widgets/glassmorphism/performance_benchmark.dart',
                'lib/widgets/glassmorphism/multi_device_test.dart',
                'lib/widgets/glassmorphism/phase4_test_suite.dart',
                'lib/widgets/glassmorphism/real_test.dart'
            ],
            'keep': 'Garder seulement si nécessaire pour le développement'
        }
    ]
    
    for i, rec in enumerate(recommendations, 1):
        print(f"\n{i}. {rec['priority']} - {rec['action']}")
        print(f"   ✅ GARDER: {rec['keep']}")
        print(f"   ❌ SUPPRIMER:")
        for file in rec['files']:
            print(f"      ├── {file}")
    
    return recommendations

if __name__ == "__main__":
    try:
        # Exécute l'analyse complète
        categories = analyze_dart_files()
        duplicates = find_similar_files()
        glassmorphic_imports = analyze_imports()
        recommendations = generate_cleanup_recommendations()
        
        print("\n" + "=" * 60)
        print("✅ ANALYSE TERMINÉE")
        print("📋 Voir AUDIT_EXHAUSTIF_RAPPORT.md pour le rapport complet")
        print("🎯 Prêt pour le nettoyage selon les recommandations")
        
    except Exception as e:
        print(f"❌ Erreur lors de l'analyse: {e}")
        print("💡 Vérifiez que vous êtes dans le bon répertoire du projet")
