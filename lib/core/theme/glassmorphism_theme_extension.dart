/*
 * Glassmorphism Theme Extension - BAZAR 2025
 * Extension de thème Flutter pour glassmorphism
 */

import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;
import 'glassmorphism_theme.dart';

@immutable
class GlassmorphismThemeExtension
    extends ThemeExtension<GlassmorphismThemeExtension> {
  const GlassmorphismThemeExtension({required this.glassmorphismTheme});

  final GlassmorphismTheme glassmorphismTheme;

  @override
  GlassmorphismThemeExtension copyWith({
    GlassmorphismTheme? glassmorphismTheme,
  }) {
    return GlassmorphismThemeExtension(
      glassmorphismTheme: glassmorphismTheme ?? this.glassmorphismTheme,
    );
  }

  @override
  GlassmorphismThemeExtension lerp(
    ThemeExtension<GlassmorphismThemeExtension>? other,
    double t,
  ) {
    if (other is! GlassmorphismThemeExtension) {
      return this;
    }

    return GlassmorphismThemeExtension(
      glassmorphismTheme: GlassmorphismTheme(
        primaryBlur:
            lerpDouble(
              glassmorphismTheme.primaryBlur,
              other.glassmorphismTheme.primaryBlur,
              t,
            ) ??
            glassmorphismTheme.primaryBlur,
        secondaryBlur:
            lerpDouble(
              glassmorphismTheme.secondaryBlur,
              other.glassmorphismTheme.secondaryBlur,
              t,
            ) ??
            glassmorphismTheme.secondaryBlur,
        primaryOpacity:
            lerpDouble(
              glassmorphismTheme.primaryOpacity,
              other.glassmorphismTheme.primaryOpacity,
              t,
            ) ??
            glassmorphismTheme.primaryOpacity,
        secondaryOpacity:
            lerpDouble(
              glassmorphismTheme.secondaryOpacity,
              other.glassmorphismTheme.secondaryOpacity,
              t,
            ) ??
            glassmorphismTheme.secondaryOpacity,
        glowColor:
            Color.lerp(
              glassmorphismTheme.glowColor,
              other.glassmorphismTheme.glowColor,
              t,
            ) ??
            glassmorphismTheme.glowColor,
        borderColor:
            Color.lerp(
              glassmorphismTheme.borderColor,
              other.glassmorphismTheme.borderColor,
              t,
            ) ??
            glassmorphismTheme.borderColor,
      ),
    );
  }
}

// Extension helper for easy access
extension GlassmorphismThemeExtensionHelper on BuildContext {
  GlassmorphismTheme get glassmorphismTheme {
    return Theme.of(
          this,
        ).extension<GlassmorphismThemeExtension>()?.glassmorphismTheme ??
        GlassmorphismTheme.defaultTheme;
  }
}
