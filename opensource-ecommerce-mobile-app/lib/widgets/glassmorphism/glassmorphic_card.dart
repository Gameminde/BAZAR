/*
 * Glassmorphic Card Component - BAZAR 2025
 * Composant principal pour l'effet glassmorphism
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/bazar_theme.dart';

/// Composant GlassmorphicCard avec effets avancés
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final EdgeInsetsGeometry? padding, margin;
  final VoidCallback? onTap;
  final bool enableGlow;
  final double? blurRadius;
  final Color? glassColor;
  final BorderRadius? borderRadius;

  const GlassmorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.enableGlow = false,
    this.blurRadius,
    this.glassColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final glassTheme = Theme.of(
      context,
    ).extension<GlassmorphismThemeExtension>();
    final defaultBlurRadius =
        glassTheme?.blurRadius ?? GlassmorphismTheme.glassBlurRadius;
    final defaultBorderRadius =
        glassTheme?.borderRadius ?? GlassmorphismTheme.glassBorderRadius;

    return AnimatedContainer(
      duration: GlassmorphismTheme.animationDuration,
      curve: GlassmorphismTheme.animationCurve,
      width: width,
      height: height,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius:
              borderRadius ?? BorderRadius.circular(defaultBorderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurRadius ?? defaultBlurRadius,
              sigmaY: blurRadius ?? defaultBlurRadius,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(defaultBorderRadius),
                gradient: GlassmorphismTheme.glassGradient,
                border: Border.all(
                  color: GlassmorphismTheme.glassBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  // Ombre interne pour effet glassmorphism
                  BoxShadow(
                    color: Colors.white.withOpacity(
                      glassTheme?.opacity ?? GlassmorphismTheme.glassOpacity,
                    ),
                    blurRadius: 20,
                    spreadRadius: -5,
                    offset: const Offset(0, 4),
                  ),
                  // Ombre externe
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                  // Effet glow optionnel
                  if (enableGlow || (glassTheme?.enableGlow ?? false))
                    BoxShadow(
                      color: GlassmorphismTheme.glassAccent.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Variante optimisée pour les performances GPU
class OptimizedGlassmorphicCard extends StatelessWidget {
  final Widget child;
  final bool enableGlow;

  const OptimizedGlassmorphicCard({
    Key? key,
    required this.child,
    this.enableGlow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset.zero, // Force GPU composition
        child: GlassmorphicCard(child: child, enableGlow: enableGlow),
      ),
    );
  }
}

/// Variante pour les cartes de produits
class ProductGlassmorphicCard extends StatelessWidget {
  final Widget image;
  final String title;
  final String price;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ProductGlassmorphicCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container avec glassmorphism
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    GlassmorphismTheme.glassPrimary,
                    GlassmorphismTheme.glassSecondary,
                  ],
                ),
              ),
              child: image,
            ),
          ),

          const SizedBox(height: 12),

          // Titre
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Prix
          Text(
            price,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GlassmorphismTheme.glassAccent,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Bouton favori
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? GlassmorphismTheme.glassAccent
                    : Colors.white70,
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Variante pour les catégories
class CategoryGlassmorphicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;

  const CategoryGlassmorphicCard({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Variante pour les boutons d'action
class ActionGlassmorphicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isPrimary;

  const ActionGlassmorphicCard({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      onTap: onTap,
      enableGlow: isPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPrimary
                    ? [
                        GlassmorphismTheme.glassPrimary,
                        GlassmorphismTheme.glassSecondary,
                      ]
                    : [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: GlassmorphismTheme.glassAccent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
