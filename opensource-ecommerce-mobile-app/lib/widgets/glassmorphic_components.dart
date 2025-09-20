/*
 * Glassmorphic Components - BAZAR 2025
 * Version consolidée et corrigée pour Flutter Web
 */

import 'dart:ui';
import 'package:flutter/material.dart';

/// Configuration des thèmes glassmorphism
class GlassmorphismConfig {
  static const double glassBlurRadius = 15.0;
  static const double glassBorderRadius = 20.0;
  static const double glassOpacity = 0.15;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;
  
  static const Color glassPrimary = Color(0x40FFFFFF);
  static const Color glassSecondary = Color(0x10FFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glassAccent = Color(0xFF4A7C59);
  
  static final LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassPrimary, glassSecondary],
  );
  
  static const List<Color> particleColors = [
    Color(0x20FFFFFF),
    Color(0x15FFFFFF),
    Color(0x10FFFFFF),
  ];
}

/// Composant GlassmorphicCard avec effets avancés
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
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
    final effectiveBlurRadius = blurRadius ?? GlassmorphismConfig.glassBlurRadius;
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(GlassmorphismConfig.glassBorderRadius);

    return AnimatedContainer(
      duration: GlassmorphismConfig.animationDuration,
      curve: GlassmorphismConfig.animationCurve,
      width: width,
      height: height,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurRadius,
              sigmaY: effectiveBlurRadius,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                gradient: GlassmorphismConfig.glassGradient,
                border: Border.all(
                  color: GlassmorphismConfig.glassBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  // Ombre interne pour effet glassmorphism
                  BoxShadow(
                    color: Colors.white.withOpacity(GlassmorphismConfig.glassOpacity),
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
                  if (enableGlow)
                    BoxShadow(
                      color: GlassmorphismConfig.glassAccent.withOpacity(0.3),
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

/// Composant GlassmorphicButton avec animations
class GlassmorphicButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const GlassmorphicButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 56,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.borderRadius = 28,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<GlassmorphicButton> createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<GlassmorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = true);
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onPressed();
        }
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.backgroundColor?.withOpacity(0.8) ?? 
                    GlassmorphismConfig.glassPrimary,
                widget.backgroundColor?.withOpacity(0.6) ?? 
                    GlassmorphismConfig.glassSecondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? GlassmorphismConfig.glassAccent)
                    .withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: widget.padding ?? 
                    const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.textColor ?? Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: widget.textColor ?? Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: widget.textColor ?? Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Container glassmorphique de base
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  const GlassmorphicContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderColor,
    this.borderWidth = 1.5,
    this.gradient,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(opacity),
                      Colors.white.withOpacity(opacity * 0.5),
                    ],
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.2),
                width: borderWidth,
              ),
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}