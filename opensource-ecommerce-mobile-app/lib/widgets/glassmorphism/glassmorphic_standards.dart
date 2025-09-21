/*
 * BAZAR Marketplace - Glassmorphic Standards
 */

import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicStandards {
  // Opacity standards
  static const double minOpacity = 0.05;
  static const double maxOpacity = 0.15;
  static const double defaultOpacity = 0.1;
  
  // Blur standards
  static const double minBlur = 5.0;
  static const double maxBlur = 25.0;
  static const double defaultBlur = 10.0;
  
  // Border standards
  static const double defaultBorderWidth = 1.0;
  static const double defaultBorderRadius = 12.0;
  
  // Shadow standards
  static const List<BoxShadow> defaultShadows = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
  
  // Standard glassmorphic container
  static Widget createGlassmorphicContainer({
    required Widget child,
    double? width,
    double? height,
    double opacity = defaultOpacity,
    double blur = defaultBlur,
    double borderRadius = defaultBorderRadius,
    Color? color,
    List<BoxShadow>? shadows,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(
              opacity.clamp(minOpacity, maxOpacity)
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: defaultBorderWidth,
            ),
            boxShadow: shadows ?? defaultShadows,
          ),
          child: child,
        ),
      ),
    );
  }
  
  // Standard glassmorphic button
  static Widget createGlassmorphicButton({
    required String text,
    required VoidCallback onPressed,
    double opacity = defaultOpacity,
    double blur = defaultBlur,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = defaultBorderRadius,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: (backgroundColor ?? Colors.white).withOpacity(
                  opacity.clamp(minOpacity, maxOpacity)
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: defaultBorderWidth,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}