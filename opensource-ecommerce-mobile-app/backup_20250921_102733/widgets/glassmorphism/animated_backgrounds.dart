/*
 * Backgrounds Animés - BAZAR 2025
 * Système de gradients dynamiques et effets de fond
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'floating_particles.dart';

/// Background animé avec gradients dynamiques
class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final bool enableRotation;
  final bool enablePulse;
  final double intensity;

  const AnimatedGradientBackground({
    Key? key,
    this.colors = const [
      Color.fromRGBO(255, 255, 255, 0.1),
      Color.fromRGBO(74, 124, 89, 0.15),
      Color.fromRGBO(232, 90, 79, 0.1),
      Color.fromRGBO(255, 255, 255, 0.05),
    ],
    this.duration = const Duration(seconds: 8),
    this.enableRotation = true,
    this.enablePulse = true,
    this.intensity = 1.0,
  }) : super(key: key);

  @override
  _AnimatedGradientBackgroundState createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: _getGradientTransform(),
            colors: widget.colors.map((color) {
              return color.withOpacity(
                color.opacity * widget.intensity * _pulseAnimation.value,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  GradientTransform _getGradientTransform() {
    if (!widget.enableRotation) {
      return const GradientRotation(0);
    }

    return GradientRotation(_rotationAnimation.value);
  }
}

/// Background avec mesh gradient animé
class MeshGradientBackground extends StatefulWidget {
  final List<List<Color>> meshColors;
  final Duration duration;
  final int meshWidth;
  final int meshHeight;

  const MeshGradientBackground({
    Key? key,
    this.meshColors = const [
      [
        Color.fromRGBO(255, 255, 255, 0.2),
        Color.fromRGBO(74, 124, 89, 0.3),
        Color.fromRGBO(255, 255, 255, 0.2),
      ],
      [
        Color.fromRGBO(74, 124, 89, 0.2),
        Color.fromRGBO(232, 90, 79, 0.4),
        Color.fromRGBO(74, 124, 89, 0.2),
      ],
      [
        Color.fromRGBO(255, 255, 255, 0.2),
        Color.fromRGBO(74, 124, 89, 0.3),
        Color.fromRGBO(255, 255, 255, 0.2),
      ],
    ],
    this.duration = const Duration(seconds: 10),
    this.meshWidth = 3,
    this.meshHeight = 3,
  }) : super(key: key);

  @override
  _MeshGradientBackgroundState createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CustomPaint(
        painter: MeshGradientPainter(
          meshColors: widget.meshColors,
          animation: _animation.value,
        ),
        child: Container(),
      ),
    );
  }
}

/// Painter pour le mesh gradient
class MeshGradientPainter extends CustomPainter {
  final List<List<Color>> meshColors;
  final double animation;

  MeshGradientPainter({required this.meshColors, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Créer un shader de mesh gradient
    final mesh = _createMesh(
      size,
      4, // meshWidth
      4, // meshHeight
      [
        [Colors.blue, Colors.purple],
        [Colors.purple, Colors.pink],
      ], // meshColors
    );

    for (int i = 0; i < mesh.length - 1; i++) {
      for (int j = 0; j < mesh[i].length - 1; j++) {
        final topLeft = mesh[i][j];
        final topRight = mesh[i][j + 1];
        final bottomLeft = mesh[i + 1][j];
        final bottomRight = mesh[i + 1][j + 1];

        final colors = [
          topLeft.withOpacity(topLeft.opacity + animation * 0.1),
          topRight.withOpacity(topRight.opacity + animation * 0.1),
          bottomRight.withOpacity(bottomRight.opacity + animation * 0.1),
          bottomLeft.withOpacity(bottomLeft.opacity + animation * 0.1),
        ];

        final rect = Rect.fromPoints(
          Offset(
            j * size.width / (mesh[i].length - 1),
            i * size.height / (mesh.length - 1),
          ),
          Offset(
            (j + 1) * size.width / (mesh[i].length - 1),
            (i + 1) * size.height / (mesh.length - 1),
          ),
        );

        paint.shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(rect);

        canvas.drawRect(rect, paint);
      }
    }
  }

  List<List<Color>> _createMesh(
    Size size,
    int meshWidth,
    int meshHeight,
    List<List<Color>> meshColors,
  ) {
    final mesh = <List<Color>>[];

    for (int i = 0; i < meshHeight; i++) {
      final row = <Color>[];
      for (int j = 0; j < meshWidth; j++) {
        row.add(meshColors[i][j]);
      }
      mesh.add(row);
    }

    return mesh;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Background avec vagues animées
class WaveBackground extends StatefulWidget {
  final List<Color> colors;
  final int waveCount;
  final double waveAmplitude;
  final double waveFrequency;

  const WaveBackground({
    Key? key,
    this.colors = const [
      Color.fromRGBO(74, 124, 89, 0.3),
      Color.fromRGBO(232, 90, 79, 0.2),
      Color.fromRGBO(255, 255, 255, 0.1),
    ],
    this.waveCount = 3,
    this.waveAmplitude = 20.0,
    this.waveFrequency = 0.01,
  }) : super(key: key);

  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CustomPaint(
        painter: WavePainter(
          colors: widget.colors,
          waveCount: widget.waveCount,
          waveAmplitude: widget.waveAmplitude,
          waveFrequency: widget.waveFrequency,
          animation: _animation.value,
        ),
        child: Container(),
      ),
    );
  }
}

/// Painter pour les vagues
class WavePainter extends CustomPainter {
  final List<Color> colors;
  final int waveCount;
  final double waveAmplitude;
  final double waveFrequency;
  final double animation;

  WavePainter({
    required this.colors,
    required this.waveCount,
    required this.waveAmplitude,
    required this.waveFrequency,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()..style = PaintingStyle.fill;

    for (int wave = 0; wave < waveCount; wave++) {
      path.reset();

      final color = colors[wave % colors.length];
      paint.color = color.withOpacity(0.3 - wave * 0.1);

      path.moveTo(0, size.height);

      for (double x = 0; x <= size.width; x += 1) {
        final y =
            size.height * 0.5 +
            math.sin(
                  (x * waveFrequency) + (animation * 2) + (wave * math.pi / 3),
                ) *
                waveAmplitude *
                (1 - wave * 0.3);

        path.lineTo(x.toDouble(), y);
      }

      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Background avec particules et lumière dynamique
class DynamicLightBackground extends StatefulWidget {
  final Offset lightPosition;
  final double lightIntensity;
  final bool enableParticles;

  const DynamicLightBackground({
    Key? key,
    this.lightPosition = const Offset(200, 300),
    this.lightIntensity = 1.0,
    this.enableParticles = true,
  }) : super(key: key);

  @override
  _DynamicLightBackgroundState createState() => _DynamicLightBackgroundState();
}

class _DynamicLightBackgroundState extends State<DynamicLightBackground>
    with TickerProviderStateMixin {
  late AnimationController _lightController;
  late Animation<Offset> _lightAnimation;

  @override
  void initState() {
    super.initState();
    _lightController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _lightAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(100, 200),
          end: const Offset(300, 400),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(300, 400),
          end: const Offset(200, 100),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(200, 100),
          end: const Offset(350, 300),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(350, 300),
          end: const Offset(100, 200),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_lightController);
  }

  @override
  void dispose() {
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _lightAnimation,
      builder: (context, child) => Stack(
        children: [
          // Background de base
          Container(
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
          ),

          // Lumière dynamique
          CustomPaint(
            painter: DynamicLightPainter(
              lightPosition: _lightAnimation.value,
              intensity: widget.lightIntensity,
            ),
            child: Container(),
          ),

          // Particules flottantes
          if (widget.enableParticles)
            const FloatingParticlesWidget(
              particleCount: 10,
              enableGlow: true,
              enablePhysics: true,
            ),
        ],
      ),
    );
  }
}

/// Painter pour la lumière dynamique
class DynamicLightPainter extends CustomPainter {
  final Offset lightPosition;
  final double intensity;

  DynamicLightPainter({required this.lightPosition, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    // Lumière principale
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(intensity * 0.8),
          Colors.white.withOpacity(intensity * 0.4),
          Colors.white.withOpacity(intensity * 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: lightPosition, radius: 200));

    canvas.drawCircle(lightPosition, 200, lightPaint);

    // Réflexions
    final reflectionPaint = Paint()
      ..color = Colors.white.withOpacity(intensity * 0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(lightPosition.dx, size.height - 30),
      60,
      reflectionPaint,
    );

    // Effets de halo
    final haloPaint = Paint()
      ..color = Colors.white.withOpacity(intensity * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(lightPosition, 180, haloPaint);
    canvas.drawCircle(lightPosition, 220, haloPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
