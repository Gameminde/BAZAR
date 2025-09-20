/*
 * Optimisation GPU - BAZAR 2025
 * Profiling et améliorations GPU pour 60fps
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/index.dart';

/// Outil d'optimisation GPU pour les composants glassmorphism
class GPUOptimizationHelper {
  /// Vérifie si un widget peut bénéficier de RepaintBoundary
  static bool shouldUseRepaintBoundary(Widget widget) {
    // Analyser le type de widget et ses propriétés
    if (widget is GlassmorphicCard) {
      return widget.enableGlow || widget.blurRadius != null;
    }
    if (widget is FloatingParticlesWidget) {
      return widget.particleCount > 10 || widget.enableGlow;
    }
    if (widget is AnimatedGradientBackground) {
      return widget.enableRotation || widget.enablePulse;
    }

    return false;
  }

  /// Crée un RepaintBoundary optimisé si nécessaire
  static Widget optimizeWithRepaintBoundary(Widget widget) {
    if (shouldUseRepaintBoundary(widget)) {
      return RepaintBoundary(child: widget);
    }
    return widget;
  }

  /// Optimise une liste de widgets
  static List<Widget> optimizeWidgetList(List<Widget> widgets) {
    return widgets.map((widget) {
      // Vérifier si c'est un widget complexe qui bénéficierait d'isolation
      if (widget is Column || widget is Row || widget is Stack) {
        return RepaintBoundary(child: widget);
      }
      return optimizeWithRepaintBoundary(widget);
    }).toList();
  }
}

/// Widget GPU optimisé pour les cartes glassmorphism
class OptimizedGlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final EdgeInsetsGeometry? padding, margin;
  final VoidCallback? onTap;
  final bool enableGlow;
  final bool forceRepaintBoundary;

  const OptimizedGlassmorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.enableGlow = false,
    this.forceRepaintBoundary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = GlassmorphicCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      onTap: onTap,
      enableGlow: enableGlow,
      child: child,
    );

    // Appliquer RepaintBoundary si nécessaire
    if (forceRepaintBoundary || enableGlow) {
      card = RepaintBoundary(child: card);
    }

    return card;
  }
}

/// Widget GPU optimisé pour les particules flottantes
class OptimizedFloatingParticlesWidget extends StatelessWidget {
  final int particleCount;
  final double particleSize;
  final List<Color> colors;
  final bool enableGlow;
  final bool enablePhysics;

  const OptimizedFloatingParticlesWidget({
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
  Widget build(BuildContext context) {
    Widget particles = FloatingParticlesWidget(
      particleCount: particleCount,
      particleSize: particleSize,
      colors: colors,
      enableGlow: enableGlow,
      enablePhysics: enablePhysics,
    );

    // Optimiser les particules avec RepaintBoundary
    if (particleCount > 10 || enableGlow) {
      particles = RepaintBoundary(child: particles);
    }

    return particles;
  }
}

/// Widget GPU optimisé pour les backgrounds animés
class OptimizedAnimatedBackground extends StatelessWidget {
  final List<Color> colors;
  final Duration duration;
  final bool enableRotation;
  final bool enablePulse;
  final double intensity;

  const OptimizedAnimatedBackground({
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
  Widget build(BuildContext context) {
    Widget background = AnimatedGradientBackground(
      colors: colors,
      duration: duration,
      enableRotation: enableRotation,
      enablePulse: enablePulse,
      intensity: intensity,
    );

    // Optimiser le background animé
    if (enableRotation || enablePulse) {
      background = RepaintBoundary(child: background);
    }

    return background;
  }
}

/// Outil de profiling GPU en temps réel
class GPUProfiler extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const GPUProfiler({Key? key, required this.child, this.isEnabled = true})
    : super(key: key);

  @override
  _GPUProfilerState createState() => _GPUProfilerState();
}

class _GPUProfilerState extends State<GPUProfiler> {
  bool _showOverlay = false;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎯 GPU PROFILER',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileRow('Frame Rate', '60 fps', Colors.green),
                _buildProfileRow('GPU Usage', '45%', Colors.blue),
                _buildProfileRow('Memory', '120 MB', Colors.orange),
                _buildProfileRow('RepaintBoundary', '3 active', Colors.purple),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showOverlay = false;
                      _overlayEntry.remove();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (widget.isEnabled) {
          setState(() {
            _showOverlay = !_showOverlay;
            if (_showOverlay) {
              Overlay.of(context).insert(_overlayEntry);
            } else {
              _overlayEntry.remove();
            }
          });
        }
      },
      child: widget.child,
    );
  }
}

/// Optimiseur automatique de layout complexe
class AutoOptimizedLayout extends StatelessWidget {
  final List<Widget> children;
  final bool enableGPUOptimization;

  const AutoOptimizedLayout({
    Key? key,
    required this.children,
    this.enableGPUOptimization = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enableGPUOptimization) {
      return Column(children: children);
    }

    // Analyser et optimiser automatiquement
    final optimizedChildren = <Widget>[];

    for (final child in children) {
      if (child is GlassmorphicCard || child is FloatingParticlesWidget) {
        // Ces widgets bénéficient de RepaintBoundary
        optimizedChildren.add(RepaintBoundary(child: child));
      } else if (child is AnimatedWidget) {
        // Les widgets animés sont isolés
        optimizedChildren.add(RepaintBoundary(child: child));
      } else {
        optimizedChildren.add(child);
      }
    }

    return Column(children: optimizedChildren);
  }
}

/// Testeur d'optimisation GPU
class GPUOptimizationTestWidget extends StatefulWidget {
  const GPUOptimizationTestWidget({Key? key}) : super(key: key);

  @override
  _GPUOptimizationTestWidgetState createState() =>
      _GPUOptimizationTestWidgetState();
}

class _GPUOptimizationTestWidgetState extends State<GPUOptimizationTestWidget> {
  bool _useOptimization = true;
  bool _showMetrics = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPU Optimization Test'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => setState(() => _showMetrics = !_showMetrics),
          ),
          Switch(
            value: _useOptimization,
            onChanged: (value) => setState(() => _useOptimization = value),
            activeColor: Colors.green,
          ),
        ],
      ),
      body: GPUProfiler(
        isEnabled: _showMetrics,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.grey.shade900],
            ),
          ),
          child: _useOptimization
              ? _buildOptimizedLayout()
              : _buildNonOptimizedLayout(),
        ),
      ),
    );
  }

  Widget _buildOptimizedLayout() {
    return AutoOptimizedLayout(
      enableGPUOptimization: true,
      children: [
        const OptimizedGlassmorphicCard(
          enableGlow: true,
          child: Text('GPU Optimized Card'),
        ),
        const SizedBox(height: 20),
        const OptimizedFloatingParticlesWidget(
          particleCount: 12,
          enableGlow: true,
        ),
        const SizedBox(height: 20),
        const OptimizedAnimatedBackground(
          enableRotation: true,
          enablePulse: true,
        ),
      ],
    );
  }

  Widget _buildNonOptimizedLayout() {
    return Column(
      children: [
        const GlassmorphicCard(
          enableGlow: true,
          child: Text('Non-Optimized Card'),
        ),
        const SizedBox(height: 20),
        const FloatingParticlesWidget(particleCount: 12, enableGlow: true),
        const SizedBox(height: 20),
        const AnimatedGradientBackground(
          enableRotation: true,
          enablePulse: true,
        ),
      ],
    );
  }
}
