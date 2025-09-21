#!/usr/bin/env python3
"""
🏗️ AGENT FRONTEND OPS – BAZAR MARKETPLACE
Étape A - Analyse rapide complète de la structure
"""

import os
import json
import re
from datetime import datetime
from difflib import SequenceMatcher

class FlutterStructureAnalyzer:
    def __init__(self, lib_dir="lib"):
        self.lib_dir = lib_dir
        self.files_data = []
        self.duplicates = []
        self.imports_map = {}
        self.structure_stats = {
            "total_files": 0,
            "total_lines": 0,
            "directories": [],
            "file_types": {},
            "imports_count": 0,
            "duplicates_found": 0
        }

    def analyze_file(self, file_path):
        """Analyse un fichier Dart individuel"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            lines = content.split('\n')
            line_count = len(lines)
            
            # Extraire les imports
            imports = []
            for line in lines:
                if line.strip().startswith('import '):
                    import_match = re.match(r"import\s+['\"]([^'\"]+)['\"]", line.strip())
                    if import_match:
                        imports.append(import_match.group(1))
            
            # Extraire les classes et widgets
            classes = re.findall(r'class\s+(\w+)', content)
            widgets = [cls for cls in classes if cls.endswith('Widget') or cls.endswith('Screen') or cls.endswith('Page')]
            
            file_data = {
                "path": file_path.replace("\\", "/"),
                "name": os.path.basename(file_path),
                "directory": os.path.dirname(file_path).replace("\\", "/"),
                "lines": line_count,
                "imports": imports,
                "classes": classes,
                "widgets": widgets,
                "size_bytes": os.path.getsize(file_path),
                "modified": datetime.fromtimestamp(os.path.getmtime(file_path)).isoformat()
            }
            
            self.files_data.append(file_data)
            self.structure_stats["total_files"] += 1
            self.structure_stats["total_lines"] += line_count
            self.structure_stats["imports_count"] += len(imports)
            
            return file_data
            
        except Exception as e:
            print(f"❌ Erreur analyse {file_path}: {e}")
            return None

    def scan_directory(self, directory):
        """Parcourt récursivement le dossier lib/"""
        if not os.path.exists(directory):
            print(f"❌ Dossier non trouvé: {directory}")
            return
        
        for root, dirs, files in os.walk(directory):
            # Ajouter le répertoire à la liste
            rel_dir = os.path.relpath(root, directory)
            if rel_dir not in self.structure_stats["directories"] and rel_dir != ".":
                self.structure_stats["directories"].append(rel_dir)
            
            for file in files:
                if file.endswith('.dart'):
                    file_path = os.path.join(root, file)
                    self.analyze_file(file_path)
                    
                    # Compter les types de fichiers
                    file_type = os.path.splitext(file)[1]
                    self.structure_stats["file_types"][file_type] = self.structure_stats["file_types"].get(file_type, 0) + 1

    def find_duplicates(self):
        """Détecte les fichiers doublons (même nom ou contenu similaire)"""
        name_groups = {}
        content_groups = {}
        
        # Grouper par nom
        for file_data in self.files_data:
            name = file_data["name"]
            if name in name_groups:
                name_groups[name].append(file_data)
            else:
                name_groups[name] = [file_data]
        
        # Identifier les doublons par nom
        for name, files in name_groups.items():
            if len(files) > 1:
                self.duplicates.append({
                    "type": "name_duplicate",
                    "name": name,
                    "files": files,
                    "severity": "high"
                })
        
        # Grouper par contenu similaire (>80%)
        for i, file1 in enumerate(self.files_data):
            for file2 in self.files_data[i+1:]:
                similarity = self.calculate_similarity(file1["path"], file2["path"])
                if similarity > 0.8:
                    self.duplicates.append({
                        "type": "content_similar",
                        "similarity": similarity,
                        "files": [file1, file2],
                        "severity": "medium"
                    })
        
        self.structure_stats["duplicates_found"] = len(self.duplicates)

    def calculate_similarity(self, file1_path, file2_path):
        """Calcule la similarité entre deux fichiers"""
        try:
            with open(file1_path, 'r', encoding='utf-8') as f1:
                content1 = f1.read()
            with open(file2_path, 'r', encoding='utf-8') as f2:
                content2 = f2.read()
            
            return SequenceMatcher(None, content1, content2).ratio()
        except:
            return 0.0

    def analyze_imports(self):
        """Analyse les imports et dépendances"""
        for file_data in self.files_data:
            for import_path in file_data["imports"]:
                if import_path.startswith('package:'):
                    package = import_path.split('/')[0].replace('package:', '')
                    if package not in self.imports_map:
                        self.imports_map[package] = []
                    self.imports_map[package].append(file_data["path"])

    def generate_structure_json(self):
        """Génère le fichier STRUCTURE.json"""
        structure_data = {
            "metadata": {
                "generated_at": datetime.now().isoformat(),
                "analyzer_version": "1.0.0",
                "flutter_version": "3.22",
                "project": "BAZAR Marketplace"
            },
            "statistics": self.structure_stats,
            "files": self.files_data,
            "duplicates": self.duplicates,
            "imports_analysis": self.imports_map,
            "recommendations": self.generate_recommendations()
        }
        
        with open('STRUCTURE.json', 'w', encoding='utf-8') as f:
            json.dump(structure_data, f, indent=2, ensure_ascii=False)
        
        print("✅ STRUCTURE.json généré")
        return structure_data

    def generate_recommendations(self):
        """Génère des recommandations basées sur l'analyse"""
        recommendations = []
        
        # Recommandations basées sur les doublons
        if self.duplicates:
            recommendations.append({
                "category": "duplicates",
                "priority": "high",
                "description": f"{len(self.duplicates)} doublons détectés",
                "action": "Supprimer ou fusionner les fichiers doublons"
            })
        
        # Recommandations basées sur la taille des fichiers
        large_files = [f for f in self.files_data if f["lines"] > 500]
        if large_files:
            recommendations.append({
                "category": "large_files",
                "priority": "medium",
                "description": f"{len(large_files)} fichiers >500 lignes",
                "action": "Refactoriser les gros fichiers"
            })
        
        # Recommandations basées sur les imports
        if len(self.imports_map) > 20:
            recommendations.append({
                "category": "dependencies",
                "priority": "medium",
                "description": f"{len(self.imports_map)} packages externes",
                "action": "Vérifier les dépendances non utilisées"
            })
        
        return recommendations

    def generate_readme_audit(self):
        """Génère le README_AUDIT.md"""
        readme_content = f"""# 📊 AUDIT STRUCTURE - BAZAR MARKETPLACE

**Date d'analyse :** {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}
**Analyseur :** Flutter Structure Analyzer v1.0.0

## 📈 STATISTIQUES GÉNÉRALES

- **📁 Total fichiers :** {self.structure_stats['total_files']}
- **📄 Total lignes :** {self.structure_stats['total_lines']:,}
- **📦 Répertoires :** {len(self.structure_stats['directories'])}
- **🔗 Total imports :** {self.structure_stats['imports_count']}
- **⚠️ Doublons détectés :** {self.structure_stats['duplicates_found']}

## 📂 STRUCTURE DES RÉPERTOIRES

"""
        
        for directory in sorted(self.structure_stats["directories"]):
            files_in_dir = [f for f in self.files_data if f["directory"].endswith(directory)]
            readme_content += f"- **`{directory}/`** : {len(files_in_dir)} fichiers\n"
        
        readme_content += f"""

## ⚠️ DOUBLONS DÉTECTÉS

"""
        
        if self.duplicates:
            for i, duplicate in enumerate(self.duplicates, 1):
                readme_content += f"### {i}. {duplicate['type'].upper()} - {duplicate['severity'].upper()}\n"
                if duplicate['type'] == 'name_duplicate':
                    readme_content += f"**Nom :** `{duplicate['name']}`\n"
                    readme_content += f"**Fichiers :**\n"
                    for file in duplicate['files']:
                        readme_content += f"- `{file['path']}`\n"
                elif duplicate['type'] == 'content_similar':
                    readme_content += f"**Similarité :** {duplicate['similarity']:.1%}\n"
                    for file in duplicate['files']:
                        readme_content += f"- `{file['path']}`\n"
                readme_content += "\n"
        else:
            readme_content += "✅ Aucun doublon détecté\n"
        
        readme_content += f"""

## 📦 ANALYSE DES IMPORTS

**Packages externes utilisés :**
"""
        
        for package, files in sorted(self.imports_map.items()):
            readme_content += f"- **{package}** : {len(files)} fichiers\n"
        
        readme_content += f"""

## 💡 RECOMMANDATIONS

"""
        
        recommendations = self.generate_recommendations()
        for rec in recommendations:
            priority_emoji = {"high": "🔴", "medium": "🟡", "low": "🟢"}.get(rec["priority"], "⚪")
            readme_content += f"{priority_emoji} **{rec['priority'].upper()}** : {rec['description']}\n"
            readme_content += f"   → {rec['action']}\n\n"
        
        readme_content += f"""

## 📊 FICHIERS LES PLUS VOLUMINEUX

"""
        
        # Top 10 des plus gros fichiers
        large_files = sorted(self.files_data, key=lambda x: x["lines"], reverse=True)[:10]
        for i, file_data in enumerate(large_files, 1):
            readme_content += f"{i}. **`{file_data['path']}`** - {file_data['lines']} lignes\n"
        
        readme_content += f"""

---

**📋 Rapport complet disponible dans :** `STRUCTURE.json`
**🔄 Prochaine étape :** Organisation et suppression des doublons
"""
        
        with open('README_AUDIT.md', 'w', encoding='utf-8') as f:
            f.write(readme_content)
        
        print("✅ README_AUDIT.md généré")

    def run_analysis(self):
        """Exécute l'analyse complète"""
        print("🔍 ÉTAPE A - ANALYSE RAPIDE BAZAR MARKETPLACE")
        print("=" * 60)
        
        # Scanner le répertoire lib/
        print("📂 Analyse du répertoire lib/...")
        self.scan_directory(self.lib_dir)
        
        # Analyser les imports
        print("🔗 Analyse des imports...")
        self.analyze_imports()
        
        # Détecter les doublons
        print("🔍 Détection des doublons...")
        self.find_duplicates()
        
        # Générer les rapports
        print("📊 Génération des rapports...")
        self.generate_structure_json()
        self.generate_readme_audit()
        
        # Résumé
        print("\n📈 RÉSUMÉ DE L'ANALYSE")
        print("-" * 30)
        print(f"✅ Fichiers analysés: {self.structure_stats['total_files']}")
        print(f"✅ Lignes totales: {self.structure_stats['total_lines']:,}")
        print(f"✅ Répertoires: {len(self.structure_stats['directories'])}")
        print(f"⚠️ Doublons: {self.structure_stats['duplicates_found']}")
        print(f"📦 Packages: {len(self.imports_map)}")
        
        print(f"\n📄 Fichiers générés:")
        print(f"   • STRUCTURE.json")
        print(f"   • README_AUDIT.md")
        
        return True

if __name__ == "__main__":
    analyzer = FlutterStructureAnalyzer()
    analyzer.run_analysis()
