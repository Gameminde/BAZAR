/*
 * Exemple d'utilisation des composants Glassmorphism - BAZAR 2025
 * Page de démonstration pour tester l'intégration
 */

import 'package:flutter/material.dart';
import 'index.dart';
import '../../utils/bazar_theme.dart';

/// Page de démonstration des composants glassmorphism
class GlassmorphismExample extends StatelessWidget {
  const GlassmorphismExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  'BAZAR Glassmorphism 2025',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Section Cards
                Text(
                  'Cards Glassmorphism',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // GlassmorphicCard basique
                GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carte Glassmorphism Basique',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Cette carte utilise l\'effet glassmorphism avec blur et transparence pour créer un effet moderne et premium.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassmorphicButton(
                        text: 'Action',
                        onPressed: () {},
                        isPrimary: true,
                        size: ButtonSize.small,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ProductGlassmorphicCard
                Text(
                  'Cartes Produits',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),

                ProductGlassmorphicCard(
                  image: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          GlassmorphismTheme.glassPrimary,
                          GlassmorphismTheme.glassSecondary,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  title: 'Produit Premium Glassmorphism',
                  price: '99,99 €',
                  onTap: () {},
                  isFavorite: true,
                  onFavoriteTap: () {},
                ),

                const SizedBox(height: 20),

                // Section Boutons
                Text(
                  'Boutons Glassmorphism',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: GlassmorphicButton(
                        text: 'Primary',
                        onPressed: () {},
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassmorphicButton(
                        text: 'Secondary',
                        onPressed: () {},
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    GlassmorphicIconButton(
                      icon: Icons.favorite,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    GlassmorphicIconButton(
                      icon: Icons.search,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    GlassmorphicIconButton(icon: Icons.add, onPressed: () {}),
                  ],
                ),

                const SizedBox(height: 20),

                // Section Catégories
                Text(
                  'Catégories',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CategoryGlassmorphicCard(
                        icon: Icons.category,
                        title: 'Électronique',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CategoryGlassmorphicCard(
                        icon: Icons.shopping_bag,
                        title: 'Mode',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Section Actions
                Text(
                  'Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ActionGlassmorphicCard(
                        icon: Icons.add_shopping_cart,
                        title: 'Panier',
                        onTap: () {},
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ActionGlassmorphicCard(
                        icon: Icons.account_circle,
                        title: 'Profil',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
