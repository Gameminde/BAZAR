/*
 * Glassmorphic AppBar Component - BAZAR 2025
 * Navigation premium avec effets glassmorphism
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/bazar_theme.dart';

/// AppBar glassmorphism premium pour BAZAR 2025
class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  const GlassmorphicAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppBar(
              title: _buildTitle(context),
              centerTitle: centerTitle,
              elevation: elevation,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: automaticallyImplyLeading,
              leading: showBackButton ? _buildBackButton(context) : null,
              actions: _buildActions(context),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              iconTheme: const IconThemeData(color: Colors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: GlassmorphismTheme.glassGradient,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(GlassmorphismTheme.glassOpacity),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: GlassmorphismTheme.glassGradient,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(GlassmorphismTheme.glassOpacity),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        padding: const EdgeInsets.all(12),
        style: IconButton.styleFrom(backgroundColor: Colors.transparent),
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return actions!.map((action) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: GlassmorphismTheme.glassGradient,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(
                  GlassmorphismTheme.glassOpacity,
                ),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: action,
            ),
          ),
        ),
      );
    }).toList();
  }
}

/// Variante compacte pour les écrans secondaires
class CompactGlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CompactGlassmorphicAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            leading: showBackButton ? _buildBackButton(context) : null,
            actions: _buildActions(context),
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            iconTheme: const IconThemeData(color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      padding: const EdgeInsets.all(12),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return actions!.map((action) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.1),
          ),
          child: action,
        ),
      );
    }).toList();
  }
}

/// AppBar avec effets de particules flottantes
class AnimatedGlassmorphicAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AnimatedGlassmorphicAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  _AnimatedGlassmorphicAppBarState createState() =>
      _AnimatedGlassmorphicAppBarState();
}

class _AnimatedGlassmorphicAppBarState extends State<AnimatedGlassmorphicAppBar>
    with TickerProviderStateMixin {
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    _particlesController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Particules flottantes
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) => CustomPaint(
              painter: FloatingParticlesPainter(_particlesController.value),
              child: Container(),
            ),
          ),

          // AppBar glassmorphism
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppBar(
                  title: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  leading: widget.showBackButton
                      ? IconButton(
                          onPressed:
                              widget.onBackPressed ??
                              () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(12),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      : null,
                  actions: widget.actions,
                  titleTextStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  iconTheme: const IconThemeData(color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter pour les particules flottantes dans l'AppBar
class FloatingParticlesPainter extends CustomPainter {
  final double animationValue;

  FloatingParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final particles = List.generate(
      8,
      (index) => _createParticle(index, size, animationValue),
    );

    for (var particle in particles) {
      final paint = Paint()
        ..color = particle['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle['x'] as double, particle['y'] as double),
        particle['size'] as double,
        paint,
      );
    }
  }

  Map<String, dynamic> _createParticle(int index, Size size, double animation) {
    final random =
        (index * 0.618033988749) % 1; // Golden ratio for pseudo-random

    return {
      'x': size.width * (0.1 + random * 0.8 + 0.1 * animation),
      'y': size.height * (0.2 + (index % 3) * 0.2 + 0.05 * animation),
      'size': 1.0 + random * 2.0,
      'color': GlassmorphismTheme
          .particleColors[index % GlassmorphismTheme.particleColors.length],
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
