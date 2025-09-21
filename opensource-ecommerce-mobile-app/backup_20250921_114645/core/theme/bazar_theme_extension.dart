/*
 * BAZAR Marketplace - Theme Extension
 */

import 'package:flutter/material.dart';

class BazarThemeExtension extends ThemeExtension<BazarThemeExtension> {
  final Color primaryGreen;
  final Color secondaryGreen;
  final Color accentGreen;
  final Color backgroundGreen;
  final Color errorRed;
  final Color warningOrange;
  final Color successGreen;
  final Color infoBlue;

  const BazarThemeExtension({
    required this.primaryGreen,
    required this.secondaryGreen,
    required this.accentGreen,
    required this.backgroundGreen,
    required this.errorRed,
    required this.warningOrange,
    required this.successGreen,
    required this.infoBlue,
  });

  @override
  BazarThemeExtension copyWith({
    Color? primaryGreen,
    Color? secondaryGreen,
    Color? accentGreen,
    Color? backgroundGreen,
    Color? errorRed,
    Color? warningOrange,
    Color? successGreen,
    Color? infoBlue,
  }) {
    return BazarThemeExtension(
      primaryGreen: primaryGreen ?? this.primaryGreen,
      secondaryGreen: secondaryGreen ?? this.secondaryGreen,
      accentGreen: accentGreen ?? this.accentGreen,
      backgroundGreen: backgroundGreen ?? this.backgroundGreen,
      errorRed: errorRed ?? this.errorRed,
      warningOrange: warningOrange ?? this.warningOrange,
      successGreen: successGreen ?? this.successGreen,
      infoBlue: infoBlue ?? this.infoBlue,
    );
  }

  @override
  BazarThemeExtension lerp(ThemeExtension<BazarThemeExtension>? other, double t) {
    if (other is! BazarThemeExtension) {
      return this;
    }
    return BazarThemeExtension(
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      secondaryGreen: Color.lerp(secondaryGreen, other.secondaryGreen, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      backgroundGreen: Color.lerp(backgroundGreen, other.backgroundGreen, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      warningOrange: Color.lerp(warningOrange, other.warningOrange, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      infoBlue: Color.lerp(infoBlue, other.infoBlue, t)!,
    );
  }

  // Light theme
  static const BazarThemeExtension light = BazarThemeExtension(
    primaryGreen: Color(0xFF4A7C59),
    secondaryGreen: Color(0xFF5B8A67),
    accentGreen: Color(0xFF2E7D32),
    backgroundGreen: Color(0xFFE8F5E8),
    errorRed: Color(0xFFD32F2F),
    warningOrange: Color(0xFFFF9800),
    successGreen: Color(0xFF4CAF50),
    infoBlue: Color(0xFF2196F3),
  );

  // Dark theme
  static const BazarThemeExtension dark = BazarThemeExtension(
    primaryGreen: Color(0xFF66BB6A),
    secondaryGreen: Color(0xFF81C784),
    accentGreen: Color(0xFF4CAF50),
    backgroundGreen: Color(0xFF1B1B1B),
    errorRed: Color(0xFFEF5350),
    warningOrange: Color(0xFFFFB74D),
    successGreen: Color(0xFF66BB6A),
    infoBlue: Color(0xFF42A5F5),
  );
}