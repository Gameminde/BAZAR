/*
 * Glassmorphic Card Basic - BAZAR 2025
 * Version minimaliste fonctionnelle
 */

import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/theme/glassmorphism_theme_extension.dart';

class GlassmorphicCard extends StatelessWidget {
  const GlassmorphicCard({
    Key? key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.1,
    this.borderRadius = 12.0,
    this.border = true,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final bool border;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.glassmorphismTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border
            ? Border.all(color: theme.borderColor, width: 1.0)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
