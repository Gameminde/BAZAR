/*
 * Glassmorphism Theme - BAZAR 2025
 * Classe de base pour le thème glassmorphism
 */

import 'package:flutter/material.dart';

@immutable
class GlassmorphismTheme {
  const GlassmorphismTheme({
    required this.primaryBlur,
    required this.secondaryBlur,
    required this.primaryOpacity,
    required this.secondaryOpacity,
    required this.glowColor,
    required this.borderColor,
  });

  final double primaryBlur;
  final double secondaryBlur;
  final double primaryOpacity;
  final double secondaryOpacity;
  final Color glowColor;
  final Color borderColor;

  static const GlassmorphismTheme defaultTheme = GlassmorphismTheme(
    primaryBlur: 20.0,
    secondaryBlur: 10.0,
    primaryOpacity: 0.1,
    secondaryOpacity: 0.05,
    glowColor: Colors.white,
    borderColor: Colors.white24,
  );

  GlassmorphismTheme copyWith({
    double? primaryBlur,
    double? secondaryBlur,
    double? primaryOpacity,
    double? secondaryOpacity,
    Color? glowColor,
    Color? borderColor,
  }) {
    return GlassmorphismTheme(
      primaryBlur: primaryBlur ?? this.primaryBlur,
      secondaryBlur: secondaryBlur ?? this.secondaryBlur,
      primaryOpacity: primaryOpacity ?? this.primaryOpacity,
      secondaryOpacity: secondaryOpacity ?? this.secondaryOpacity,
      glowColor: glowColor ?? this.glowColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}
