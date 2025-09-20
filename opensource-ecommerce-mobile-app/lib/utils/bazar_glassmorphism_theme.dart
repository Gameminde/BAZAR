/*
 * BAZAR Glassmorphism Theme 2025
 * Thème premium avec effets glassmorphism
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' show lerpDouble;
import 'glassmorphism_theme.dart';
import 'glassmorphism_theme_extension.dart';

class BazarGlassmorphismTheme {
  // Couleurs BAZAR Algeria
  static const Color primaryGreen = Color(0xFF4A7C59);
  static const Color secondaryGreen = Color(0xFF5B8A67);
  static const Color backgroundGreen = Color(0xFFE8F5E8);
  static const Color priceGreen = Color(0xFF2E7D32);
  static const Color accentOrange = Color(0xFFE85A4F);
  static const Color accentYellow = Color(0xFFF4A261);

  // Configuration glassmorphism
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.1;
  static const double glassBorderRadius = 24.0;

  static ThemeData get lightGlassmorphismTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,

      // Extensions glassmorphism
      extensions: <ThemeExtension<dynamic>>[
        const GlassmorphismThemeExtension(
          glassmorphismTheme: GlassmorphismTheme(
            primaryBlur: glassBlur,
            secondaryBlur: 10.0,
            primaryOpacity: glassOpacity,
            secondaryOpacity: 0.05,
            glowColor: Colors.white,
            borderColor: Colors.white24,
          ),
        ),
      ],

      // Couleurs principales
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: Colors.white.withOpacity(0.1),
        background: backgroundGreen,
      ),

      // Scaffold transparent pour glassmorphism
      scaffoldBackgroundColor: backgroundGreen,

      // AppBar glassmorphism
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),

      // Card theme glassmorphism
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        margin: EdgeInsets.zero,
      ),

      // Button theme glassmorphism
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(glassBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Text theme optimisé pour glassmorphism
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.9),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.8),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Floating Action Button glassmorphism
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // Input decoration glassmorphism
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.6)),
        labelStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.8)),
      ),

      // Divider glassmorphism
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.2),
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkGlassmorphismTheme {
    return lightGlassmorphismTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      extensions: <ThemeExtension<dynamic>>[
        const GlassmorphismThemeExtension(
          glassmorphismTheme: GlassmorphismTheme(
            primaryBlur: 25.0,
            secondaryBlur: 15.0,
            primaryOpacity: 0.15,
            secondaryOpacity: 0.08,
            glowColor: Colors.white,
            borderColor: Colors.white24,
          ),
        ),
      ],
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: Colors.black.withOpacity(0.3),
        background: const Color.fromRGBO(18, 18, 18, 1),
      ),
    );
  }
}

// Extension pour accéder facilement aux propriétés glassmorphism dans les widgets
extension GlassmorphismThemeContext on BuildContext {
  GlassmorphismThemeExtension get glassmorphismTheme {
    return Theme.of(this).extension<GlassmorphismThemeExtension>() ??
        const GlassmorphismThemeExtension(
          glassmorphismTheme: GlassmorphismTheme.defaultTheme,
        );
  }
}
