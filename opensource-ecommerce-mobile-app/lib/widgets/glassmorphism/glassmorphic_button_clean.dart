/*
 * Glassmorphic Button Component - BAZAR 2025
 * Boutons premium avec effets glassmorphism
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glassmorphic_card.dart';

/// Énumération pour les tailles de boutons
enum ButtonSize { small, medium, large }

/// Énumération pour les types de boutons
enum GlassmorphicButtonType { filled, outlined, gradient }

/// Bouton glassmorphism premium pour BAZAR 2025
class GlassmorphicButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double? width;
  final ButtonSize size;
  final GlassmorphicButtonType type;

  const GlassmorphicButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.width,
    this.size = ButtonSize.medium,
    this.type = GlassmorphicButtonType.filled,
  }) : super(key: key);

  @override
  _GlassmorphicButtonState createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<GlassmorphicButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: widget.onPressed,
          child: GlassmorphicCard(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            enableGlow: widget.isPrimary,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isPrimary
                        ? [const Color(0xFF4A7C59), const Color(0xFF5B8A67)]
                        : [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                  ),
                  boxShadow: [
                    if (widget.isPrimary)
                      BoxShadow(
                        color: const Color(
                          0xFFF4A261,
                        ).withValues(alpha: 0.3 * _glowAnimation.value),
                        blurRadius: 20 + (10 * _glowAnimation.value),
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    if (widget.isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      Text(
                        widget.text,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphic Icon Button avec badge pour panier, favoris, etc.
class GlassmorphicIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final int? badgeCount;
  final bool enableGlow;

  const GlassmorphicIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.badgeCount,
    this.enableGlow = false,
  }) : super(key: key);

  @override
  _GlassmorphicIconButtonState createState() => _GlassmorphicIconButtonState();
}

class _GlassmorphicIconButtonState extends State<GlassmorphicIconButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: widget.onPressed,
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(12),
            enableGlow: widget.enableGlow,
            child: Stack(
              children: [
                Icon(widget.icon, color: Colors.white, size: 24),
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4A261),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        widget.badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
