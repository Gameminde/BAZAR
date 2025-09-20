import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Palette de couleurs BAZAR Marketplace
class BazarColors {
  // Couleurs primaires
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color secondaryGold = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);

  // Couleurs de fond
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Couleurs d'état
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Couleurs de surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Couleurs de bordure
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF1E40AF);
}

/// Thème BAZAR Marketplace
class BazarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BazarColors.primaryBlue,
        brightness: Brightness.light,
        primary: BazarColors.primaryBlue,
        secondary: BazarColors.secondaryGold,
        tertiary: BazarColors.accentGreen,
        surface: BazarColors.surface,
        background: BazarColors.backgroundLight,
        error: BazarColors.error,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: BazarColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: BazarColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: BazarColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: BazarColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: BazarColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: BazarColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: BazarColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BazarColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: BazarColors.textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: BazarColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: BazarColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: BazarColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BazarColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: BazarColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: BazarColors.textLight,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: BazarColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BazarColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BazarColors.primaryBlue,
          side: const BorderSide(color: BazarColors.primaryBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BazarColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: BazarColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BazarColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BazarColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BazarColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: BazarColors.borderFocus,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BazarColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BazarColors.secondaryGold,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BazarColors.surface,
        selectedItemColor: BazarColors.primaryBlue,
        unselectedItemColor: BazarColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: BazarColors.border,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BazarColors.primaryBlue,
        brightness: Brightness.dark,
        primary: BazarColors.primaryBlue,
        secondary: BazarColors.secondaryGold,
        tertiary: BazarColors.accentGreen,
        surface: const Color(0xFF1F2937),
        background: const Color(0xFF111827),
        error: BazarColors.error,
      ),

      // Dark theme specific overrides
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F2937),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1F2937),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Extensions pour faciliter l'utilisation des couleurs
extension BazarColorExtension on Color {
  /// Retourne une version plus claire de la couleur
  Color get lighter {
    return Color.fromARGB(
      alpha,
      (red + 255) ~/ 2,
      (green + 255) ~/ 2,
      (blue + 255) ~/ 2,
    );
  }

  /// Retourne une version plus sombre de la couleur
  Color get darker {
    return Color.fromARGB(alpha, red ~/ 2, green ~/ 2, blue ~/ 2);
  }
}

/// Configuration Glassmorphism 2025 pour BAZAR
class GlassmorphismTheme {
  // Configuration Glassmorphism
  static const double glassBlurRadius = 20.0;
  static const double glassOpacity = 0.1;
  static const double glassBorderRadius = 24.0;
  static const double glassElevation = 8.0;

  // Couleurs Glassmorphism 2025 - inspirées des images graphics
  static const Color glassPrimary = Color.fromRGBO(
    74,
    124,
    89,
    0.8,
  ); // Vert Algérie
  static const Color glassSecondary = Color.fromRGBO(91, 138, 103, 0.6);
  static const Color glassAccent = Color.fromRGBO(
    232,
    90,
    79,
    0.7,
  ); // Orange/corail
  static const Color glassSurface = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.2);

  // Gradients dynamiques
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(255, 255, 255, 0.15),
      Color.fromRGBO(255, 255, 255, 0.05),
    ],
  );

  // Ombres avancées pour glassmorphism
  static const List<BoxShadow> glassShadows = [
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      blurRadius: 20,
      spreadRadius: -5,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 20,
      spreadRadius: 5,
      offset: Offset(0, 8),
    ),
  ];

  // Animation configurations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeOutCubic;

  // Particules pour effets flottants
  static const List<Color> particleColors = [
    Color.fromRGBO(255, 255, 255, 0.3),
    Color.fromRGBO(74, 124, 89, 0.2),
    Color.fromRGBO(232, 90, 79, 0.2),
  ];
}

/// Extension pour accéder facilement aux propriétés glassmorphism
class GlassmorphismThemeExtension
    extends ThemeExtension<GlassmorphismThemeExtension> {
  final double blurRadius;
  final double opacity;
  final double borderRadius;
  final bool enableGlow;

  const GlassmorphismThemeExtension({
    this.blurRadius = GlassmorphismTheme.glassBlurRadius,
    this.opacity = GlassmorphismTheme.glassOpacity,
    this.borderRadius = GlassmorphismTheme.glassBorderRadius,
    this.enableGlow = false,
  });

  factory GlassmorphismThemeExtension.dark() {
    return const GlassmorphismThemeExtension(
      blurRadius: 25.0,
      opacity: 0.15,
      borderRadius: 28.0,
      enableGlow: true,
    );
  }

  factory GlassmorphismThemeExtension.glow() {
    return const GlassmorphismThemeExtension(enableGlow: true);
  }

  @override
  GlassmorphismThemeExtension copyWith({
    double? blurRadius,
    double? opacity,
    double? borderRadius,
    bool? enableGlow,
  }) {
    return GlassmorphismThemeExtension(
      blurRadius: blurRadius ?? this.blurRadius,
      opacity: opacity ?? this.opacity,
      borderRadius: borderRadius ?? this.borderRadius,
      enableGlow: enableGlow ?? this.enableGlow,
    );
  }

  @override
  GlassmorphismThemeExtension lerp(
    GlassmorphismThemeExtension? other,
    double t,
  ) {
    if (other is! GlassmorphismThemeExtension) return this;
    return GlassmorphismThemeExtension(
      blurRadius: lerpDouble(blurRadius, other.blurRadius, t) ?? blurRadius,
      opacity: lerpDouble(opacity, other.opacity, t) ?? opacity,
      borderRadius:
          lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      enableGlow: other.enableGlow, // Pas d'interpolation pour le booléen
    );
  }
}

/// Extensions pour les couleurs glassmorphism
extension GlassmorphismColorExtension on Color {
  /// Convertit une couleur en couleur glassmorphism avec opacité
  Color get glassmorphism {
    return withOpacity(GlassmorphismTheme.glassOpacity);
  }

  /// Retourne une couleur adaptée pour le glassmorphism
  Color get glassmorphismCompatible {
    // Pour les couleurs sombres, on augmente l'opacité
    if (computeLuminance() < 0.5) {
      return withOpacity(0.8);
    }
    return withOpacity(GlassmorphismTheme.glassOpacity);
  }
}

/// Utility pour les animations glassmorphism
class GlassmorphismAnimations {
  /// Animation d'apparition glassmorphism
  static SlideTransition slideInUp(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: GlassmorphismTheme.animationCurve,
            ),
          ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Animation de morphing glassmorphism
  static AnimatedContainer morphingContainer({
    required Widget child,
    required bool isActive,
    required VoidCallback? onTap,
    bool enableGlow = false,
  }) {
    return AnimatedContainer(
      duration: GlassmorphismTheme.animationDuration,
      curve: GlassmorphismTheme.animationCurve,
      transform: isActive
          ? Matrix4.identity()
          : (Matrix4.identity()..scale(0.95)),
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
