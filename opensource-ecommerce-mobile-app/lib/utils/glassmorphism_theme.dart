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

  // Constantes statiques pour accès facile
  static const double blurRadius = 20.0;
  static const double opacity = 0.1;
  static const double borderRadius = 16.0;
  static const Color glassAccent = Color(0xFFF4A261);
  static const Color glassPrimary = Color(0xFF4A7C59);
  static const Color glassSecondary = Color(0xFF5B8A67);
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A7C59), Color(0xFF5B8A67)],
  );
  static const double glassOpacity = 0.1;
  static const Color glassBorder = Colors.white24;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

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
