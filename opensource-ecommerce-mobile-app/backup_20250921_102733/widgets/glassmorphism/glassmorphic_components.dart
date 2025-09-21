/*
 * Glassmorphic Components - BAZAR 2025
 * Version consolidée avec types explicites et null-safe
 */

import 'package:flutter/material.dart';
import 'dart:ui';

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
  final double opacity;
  final double blur;

  const GlassmorphicCard({
    super.key,
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
    this.opacity = 0.1,
    this.blur = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBlurRadius = blurRadius ?? blur;
    final effectiveBorderRadius =
        borderRadius ??
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
                color: Colors.white.withOpacity(opacity),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  // Ombre interne pour effet glassmorphism
                  BoxShadow(
                    color: Colors.white.withOpacity(
                      GlassmorphismConfig.glassOpacity,
                    ),
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
  final bool isPrimary;
  final ButtonSize size;

  const GlassmorphicButton({
    super.key,
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
    this.isPrimary = true,
    this.size = ButtonSize.medium,
  });

  @override
  State<GlassmorphicButton> createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<GlassmorphicButton>
    with SingleTickerProviderStateMixin {
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
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          _controller.reverse();
          widget.onPressed();
        }
      },
      onTapCancel: () {
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
                color:
                    (widget.backgroundColor ?? GlassmorphismConfig.glassAccent)
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
                padding:
                    widget.padding ??
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
    super.key,
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
  });

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
              gradient:
                  gradient ??
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
              boxShadow:
                  boxShadow ??
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

/// Enum pour les tailles de boutons
enum ButtonSize { small, medium, large }

/// Widget de fond animé avec gradient
class AnimatedGradientBackground extends StatefulWidget {
  final bool enableRotation;
  final bool enablePulse;
  final List<Color>? colors;

  const AnimatedGradientBackground({
    super.key,
    this.enableRotation = true,
    this.enablePulse = true,
    this.colors,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.enableRotation) {
      _rotationController.repeat();
    }
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        widget.colors ??
        [
          const Color(0xFF1a1a2e),
          const Color(0xFF16213e),
          const Color(0xFF0f3460),
          const Color(0xFF533483),
        ];

    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: _pulseAnimation.value,
              colors: effectiveColors,
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Widget de particules flottantes
class FloatingParticlesWidget extends StatefulWidget {
  final int particleCount;
  final bool enableGlow;
  final bool enablePhysics;
  final List<Color>? particleColors;

  const FloatingParticlesWidget({
    super.key,
    this.particleCount = 20,
    this.enableGlow = false,
    this.enablePhysics = true,
    this.particleColors,
  });

  @override
  State<FloatingParticlesWidget> createState() =>
      _FloatingParticlesWidgetState();
}

class _FloatingParticlesWidgetState extends State<FloatingParticlesWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _initializeParticles();
    _controller.repeat();
  }

  void _initializeParticles() {
    particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      particles.add(
        Particle(
          x: (i * 50.0) % 400,
          y: (i * 30.0) % 300,
          size: 2.0 + (i % 3) * 2.0,
          speed: 0.5 + (i % 3) * 0.3,
          color:
              (widget.particleColors ?? GlassmorphismConfig.particleColors)[i %
                  3],
        ),
      );
    }
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
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: FloatingParticlesPainter(
            particles: particles,
            animationValue: _controller.value,
            enableGlow: widget.enableGlow,
            enablePhysics: widget.enablePhysics,
          ),
        );
      },
    );
  }
}

/// Classe pour représenter une particule
class Particle {
  double x;
  double y;
  double size;
  double speed;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

/// Painter pour les particules flottantes
class FloatingParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final bool enableGlow;
  final bool enablePhysics;

  FloatingParticlesPainter({
    required this.particles,
    required this.animationValue,
    required this.enableGlow,
    required this.enablePhysics,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      if (enableGlow) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      }

      // Calculer la position animée
      double animatedX =
          particle.x + (particle.speed * animationValue * 100) % size.width;
      double animatedY =
          particle.y + (particle.speed * animationValue * 50) % size.height;

      canvas.drawCircle(Offset(animatedX, animatedY), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// AppBar glassmorphique
class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const GlassmorphicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: actions,
          leading: leading,
          centerTitle: centerTitle,
          backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.1),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

/// Bouton icône glassmorphique
class GlassmorphicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const GlassmorphicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      width: 48,
      height: 48,
      padding: padding ?? const EdgeInsets.all(12),
      onTap: onPressed,
      child: Icon(icon, color: iconColor ?? Colors.white, size: size ?? 20),
    );
  }
}

/// Page d'accueil glassmorphique complète
class GlassmorphicHomePage extends StatelessWidget {
  const GlassmorphicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background animé
          const AnimatedGradientBackground(
            enableRotation: true,
            enablePulse: true,
          ),

          // Particules flottantes
          const FloatingParticlesWidget(
            particleCount: 15,
            enableGlow: true,
            enablePhysics: true,
          ),

          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header
                  GlassmorphicCard(
                    enableGlow: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'BAZAR 2025',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Marketplace Premium Glassmorphism',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: GlassmorphicButton(
                          text: 'Explorer',
                          icon: Icons.explore,
                          onPressed: () {},
                          isPrimary: true,
                          size: ButtonSize.medium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassmorphicButton(
                          text: 'Catégories',
                          icon: Icons.category,
                          onPressed: () {},
                          isPrimary: false,
                          size: ButtonSize.medium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Cards de démonstration
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      for (int i = 0; i < 4; i++)
                        GlassmorphicCard(
                          height: 120,
                          child: Center(
                            child: Icon(
                              [
                                Icons.star,
                                Icons.favorite,
                                Icons.thumb_up,
                                Icons.lightbulb,
                              ][i],
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
