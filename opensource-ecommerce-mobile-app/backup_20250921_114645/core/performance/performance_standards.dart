/*
 * BAZAR Marketplace - Performance Standards
 */

import 'dart:ui';
import 'package:flutter/material.dart';

class PerformanceStandards {
  // Blur standards
  static const double maxBlur = 25.0;
  static const double optimalBlur = 10.0;
  static const double minBlur = 5.0;
  
  // Texture layer standards
  static const int maxTextureLayers = 2000;
  static const int optimalTextureLayers = 1000;
  static const int maxNestedStacks = 3;
  
  // Image standards
  static const int maxImageSize = 1000;
  static const int optimalImageSize = 500;
  
  // Animation standards
  static const int maxAnimations = 10;
  static const int optimalAnimations = 5;
  
  // Performance helpers
  static Widget optimizedBlur({
    required Widget child,
    double blur = optimalBlur,
  }) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur.clamp(minBlur, maxBlur),
          sigmaY: blur.clamp(minBlur, maxBlur),
        ),
        child: child,
      ),
    );
  }
  
  static Widget optimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      imageUrl,
      width: width?.clamp(0, maxImageSize.toDouble()),
      height: height?.clamp(0, maxImageSize.toDouble()),
      fit: fit,
      cacheWidth: width?.toInt() ?? optimalImageSize,
      cacheHeight: height?.toInt() ?? optimalImageSize,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
    );
  }
  
  static Widget performanceBoundary({required Widget child}) {
    return RepaintBoundary(child: child);
  }
  
  static Widget optimizedStack({
    required List<Widget> children,
    Alignment alignment = Alignment.topLeft,
  }) {
    // Limiter le nombre d'enfants pour éviter trop de couches
    final optimizedChildren = children.take(10).toList();
    
    return Stack(
      alignment: alignment,
      children: optimizedChildren,
    );
  }
  
  // Performance monitoring
  static void logPerformanceMetrics() {
    debugPrint('=== PERFORMANCE METRICS ===');
    debugPrint('Blur effects: Monitor < 25px');
    debugPrint('Texture layers: Monitor < 2000');
    debugPrint('Image sizes: Monitor < 1000px');
    debugPrint('Animations: Monitor < 10');
    debugPrint('==========================');
  }
}