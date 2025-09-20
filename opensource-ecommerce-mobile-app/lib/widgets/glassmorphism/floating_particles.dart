/*
 * Système de Particules Flottantes - BAZAR 2025
 * Effets visuels avancés pour glassmorphism
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/bazar_theme.dart';
import 'glassmorphic_card.dart';

/// Système de particules flottantes pour effets glassmorphism
class FloatingParticlesWidget extends StatefulWidget {
  final int particleCount;
  final double particleSize;
  final List<Color> colors;
  final bool enableGlow;
  final bool enablePhysics;

  const FloatingParticlesWidget({
    Key? key,
    this.particleCount = 15,
    this.particleSize = 3.0,
    this.colors = const [
      Color.fromRGBO(255, 255, 255, 0.3),
      Color.fromRGBO(74, 124, 89, 0.2),
      Color.fromRGBO(232, 90, 79, 0.2),
    ],
    this.enableGlow = true,
    this.enablePhysics = true,
  }) : super(key: key);

  @override
  _FloatingParticlesWidgetState createState() =>
      _FloatingParticlesWidgetState();
}

class _FloatingParticlesWidgetState extends State<FloatingParticlesWidget>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        index: index,
        particleCount: widget.particleCount,
        colors: widget.colors,
        size: widget.particleSize,
        enableGlow: widget.enableGlow,
      ),
    );
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
      builder: (context, child) => RepaintBoundary(
        child: CustomPaint(
          painter: FloatingParticlesPainter(
            particles: particles,
            animation: _animation.value,
            enableGlow: widget.enableGlow,
            enablePhysics: widget.enablePhysics,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

/// Classe représentant une particule flottante
class Particle {
  final int index;
  final int particleCount;
  final List<Color> colors;
  final double size;
  final bool enableGlow;

  late Offset position;
  late Offset velocity;
  late double rotation;
  late double rotationSpeed;
  late Color color;
  late double opacity;
  late double glowIntensity;

  Particle({
    required this.index,
    required this.particleCount,
    required this.colors,
    required this.size,
    required this.enableGlow,
  }) {
    _initialize();
  }

  void _initialize() {
    final random = math.Random(index * 1000);

    // Position initiale aléatoire
    position = Offset(random.nextDouble() * 400, random.nextDouble() * 800);

    // Vitesse et direction aléatoires
    velocity = Offset(
      (random.nextDouble() - 0.5) * 0.5,
      (random.nextDouble() - 0.5) * 0.5,
    );

    // Rotation aléatoire
    rotation = random.nextDouble() * 2 * math.pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.02;

    // Couleur aléatoire
    color = colors[index % colors.length];

    // Opacité variable
    opacity = random.nextDouble() * 0.6 + 0.2;

    // Intensité du glow
    glowIntensity = enableGlow ? random.nextDouble() * 0.5 + 0.3 : 0.0;
  }

  void update(double time, Size screenSize) {
    // Mouvement sinusoïdal pour un effet plus naturel
    final waveX = math.sin(time + index * 0.5) * 0.3;
    final waveY = math.cos(time + index * 0.7) * 0.2;

    position += Offset(velocity.dx + waveX, velocity.dy + waveY);

    // Rotation continue
    rotation += rotationSpeed;

    // Rebondir sur les bords
    if (position.dx < 0 || position.dx > screenSize.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
      position = Offset(position.dx < 0 ? 0 : screenSize.width, position.dy);
    }

    if (position.dy < 0 || position.dy > screenSize.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
      position = Offset(position.dx, position.dy < 0 ? 0 : screenSize.height);
    }
  }
}

/// Painter pour dessiner les particules flottantes
class FloatingParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final bool enableGlow;
  final bool enablePhysics;

  FloatingParticlesPainter({
    required this.particles,
    required this.animation,
    required this.enableGlow,
    required this.enablePhysics,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Mettre à jour les particules si la physique est activée
    if (enablePhysics) {
      for (var particle in particles) {
        particle.update(animation, size);
      }
    }

    // Dessiner chaque particule
    for (var particle in particles) {
      _drawParticle(canvas, particle, size);
    }
  }

  void _drawParticle(Canvas canvas, Particle particle, Size size) {
    final paint = Paint()
      ..color = particle.color.withOpacity(particle.opacity)
      ..style = PaintingStyle.fill;

    // Sauvegarder le canvas pour les transformations
    canvas.save();

    // Appliquer la rotation
    canvas.translate(particle.position.dx, particle.position.dy);
    canvas.rotate(particle.rotation);

    // Dessiner la particule principale
    canvas.drawCircle(Offset.zero, particle.size, paint);

    // Ajouter l'effet glow si activé
    if (enableGlow && particle.glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.glowIntensity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 2);

      canvas.drawCircle(Offset.zero, particle.size * 3, glowPaint);
    }

    // Dessiner un halo subtil
    final haloPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);

    canvas.drawCircle(Offset.zero, particle.size * 2, haloPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Variante optimisée avec moins de particules
class OptimizedFloatingParticlesWidget extends StatelessWidget {
  final int particleCount;

  const OptimizedFloatingParticlesWidget({Key? key, this.particleCount = 8})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingParticlesWidget(
      particleCount: particleCount,
      enableGlow: false,
      enablePhysics: true,
    );
  }
}

/// Variante avec effets de lumière
class LightFloatingParticlesWidget extends StatelessWidget {
  final Offset lightPosition;
  final double lightIntensity;

  const LightFloatingParticlesWidget({
    Key? key,
    required this.lightPosition,
    this.lightIntensity = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particules de base
        const FloatingParticlesWidget(particleCount: 12, enableGlow: true),

        // Effets de lumière
        CustomPaint(
          painter: LightEffectPainter(
            lightPosition: lightPosition,
            intensity: lightIntensity,
          ),
          child: Container(),
        ),
      ],
    );
  }
}

/// Painter pour les effets de lumière
class LightEffectPainter extends CustomPainter {
  final Offset lightPosition;
  final double intensity;

  LightEffectPainter({required this.lightPosition, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    // Effet de lumière radial principal
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(intensity * 0.6),
          Colors.white.withOpacity(intensity * 0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: lightPosition, radius: 150));

    canvas.drawCircle(lightPosition, 150, lightPaint);

    // Effets de réflexion
    final reflectionPaint = Paint()
      ..color = Colors.white.withOpacity(intensity * 0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(
      Offset(lightPosition.dx, size.height - 20),
      40,
      reflectionPaint,
    );

    // Particules lumineuses supplémentaires
    final particlePaint = Paint()
      ..color = Colors.white.withOpacity(intensity * 0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        lightPosition.dx + (i - 2) * 30,
        lightPosition.dy + (i % 2 == 0 ? -20 : 20),
      );
      canvas.drawCircle(offset, (2 + i).toDouble(), particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget de démonstration pour les particules
class FloatingParticlesDemo extends StatefulWidget {
  const FloatingParticlesDemo({Key? key}) : super(key: key);

  @override
  _FloatingParticlesDemoState createState() => _FloatingParticlesDemoState();
}

class _FloatingParticlesDemoState extends State<FloatingParticlesDemo> {
  bool enableGlow = true;
  bool enablePhysics = true;
  int particleCount = 15;
  Offset lightPosition = const Offset(200, 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
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

          // Système de particules
          FloatingParticlesWidget(
            particleCount: particleCount,
            enableGlow: enableGlow,
            enablePhysics: enablePhysics,
          ),

          // Contrôles
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: GlassmorphicCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Activer le glow'),
                    value: enableGlow,
                    onChanged: (value) => setState(() => enableGlow = value),
                  ),
                  SwitchListTile(
                    title: const Text('Activer la physique'),
                    value: enablePhysics,
                    onChanged: (value) => setState(() => enablePhysics = value),
                  ),
                  ListTile(
                    title: const Text('Nombre de particules'),
                    subtitle: Slider(
                      value: particleCount.toDouble(),
                      min: 5,
                      max: 30,
                      onChanged: (value) =>
                          setState(() => particleCount = value.toInt()),
                    ),
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
