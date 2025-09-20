/*
 * Floating Particles Widget Basic - BAZAR 2025
 * Version minimaliste fonctionnelle
 */

import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticlesWidget extends StatefulWidget {
  const FloatingParticlesWidget({
    Key? key,
    this.particleCount = 5,
    this.colors = const [Colors.white24, Colors.white12],
  }) : super(key: key);

  final int particleCount;
  final List<Color> colors;

  @override
  State<FloatingParticlesWidget> createState() =>
      _FloatingParticlesWidgetState();
}

class _FloatingParticlesWidgetState extends State<FloatingParticlesWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 6 + 2,
          color: widget.colors[random.nextInt(widget.colors.length)],
          speed: random.nextDouble() * 0.5 + 0.1,
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
          painter: ParticlesPainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlesPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y =
          (particle.y + animationValue * particle.speed) % 1.0 * size.height;

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
