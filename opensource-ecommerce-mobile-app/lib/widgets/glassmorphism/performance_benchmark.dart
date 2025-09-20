/*
 * Outil de Benchmark Performance - BAZAR 2025
 * Tests et métriques pour valider 60fps
 */

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/index.dart';

/// Outil de benchmark pour mesurer les performances des animations glassmorphism
class PerformanceBenchmark {
  static const int targetFrameRate = 60;
  static const Duration targetFrameTime = Duration(
    microseconds: 16666,
  ); // 1/60s

  /// Mesure les performances d'une animation sur une durée donnée
  static Future<PerformanceResult> measureAnimationPerformance({
    required Widget widget,
    required Duration testDuration,
    required TickerProvider vsync,
  }) async {
    final completer = Completer<PerformanceResult>();
    final frameTimes = <Duration>[];
    late Timer timer;

    int frameCount = 0;
    Duration? lastFrameTime;

    // Créer un FrameCallback pour mesurer chaque frame
    void frameCallback(Duration timestamp) {
      frameCount++;

      if (lastFrameTime != null) {
        final frameDuration = timestamp - lastFrameTime!;
        frameTimes.add(frameDuration);
      }

      lastFrameTime = timestamp;

      // Continuer la mesure
      SchedulerBinding.instance.scheduleFrameCallback(frameCallback);
    }

    // Démarrer la mesure
    SchedulerBinding.instance.scheduleFrameCallback(frameCallback);

    // Timer pour arrêter le test après testDuration
    timer = Timer(testDuration, () {
      SchedulerBinding.instance.cancelFrameCallbackWithId(0);

      final result = _calculatePerformanceResult(
        frameTimes,
        testDuration,
        frameCount,
      );
      completer.complete(result);
    });

    return completer.future;
  }

  static PerformanceResult _calculatePerformanceResult(
    List<Duration> frameTimes,
    Duration testDuration,
    int frameCount,
  ) {
    if (frameTimes.isEmpty) {
      return const PerformanceResult(
        averageFrameTime: Duration.zero,
        frameRate: 0.0,
        droppedFrames: 0,
        performanceScore: 0.0,
        isOptimal: false,
      );
    }

    final averageFrameTime =
        frameTimes.reduce((a, b) => a + b) ~/ frameTimes.length;
    final expectedFrameCount =
        (testDuration.inMicroseconds / targetFrameTime.inMicroseconds).round();
    final droppedFrames = (expectedFrameCount - frameCount).clamp(
      0,
      expectedFrameCount,
    );
    final frameRate = 1000000.0 / averageFrameTime.inMicroseconds;
    final performanceScore = (frameRate / targetFrameRate * 100).clamp(
      0.0,
      100.0,
    );
    final isOptimal =
        frameRate >= 55.0 && droppedFrames <= (expectedFrameCount * 0.05);

    return PerformanceResult(
      averageFrameTime: averageFrameTime,
      frameRate: frameRate,
      droppedFrames: droppedFrames,
      performanceScore: performanceScore,
      isOptimal: isOptimal,
    );
  }
}

/// Résultat des tests de performance
class PerformanceResult {
  final Duration averageFrameTime;
  final double frameRate;
  final int droppedFrames;
  final double performanceScore;
  final bool isOptimal;

  const PerformanceResult({
    required this.averageFrameTime,
    required this.frameRate,
    required this.droppedFrames,
    required this.performanceScore,
    required this.isOptimal,
  });

  @override
  String toString() {
    return '''
Performance Result:
- Frame Rate: ${frameRate.toStringAsFixed(2)} fps
- Average Frame Time: ${averageFrameTime.inMicroseconds}μs
- Dropped Frames: $droppedFrames
- Performance Score: ${performanceScore.toStringAsFixed(1)}%
- Status: ${isOptimal ? '✅ OPTIMAL' : '❌ NEEDS OPTIMIZATION'}
''';
  }
}

/// Widget de test de performance interactif
class PerformanceTestWidget extends StatefulWidget {
  final Widget testWidget;
  final String testName;

  const PerformanceTestWidget({
    Key? key,
    required this.testWidget,
    required this.testName,
  }) : super(key: key);

  @override
  _PerformanceTestWidgetState createState() => _PerformanceTestWidgetState();
}

class _PerformanceTestWidgetState extends State<PerformanceTestWidget>
    with TickerProviderStateMixin {
  PerformanceResult? _result;
  bool _isTesting = false;
  late AnimationController _stressTestController;

  @override
  void initState() {
    super.initState();

    _stressTestController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _stressTestController.dispose();
    super.dispose();
  }

  Future<void> _runPerformanceTest() async {
    setState(() {
      _isTesting = true;
      _result = null;
    });

    // Widget à tester avec stress test
    final testWidget = _buildStressTestWidget();

    // Mesurer les performances
    final result = await PerformanceBenchmark.measureAnimationPerformance(
      widget: testWidget,
      testDuration: const Duration(seconds: 3),
      vsync: this,
    );

    setState(() {
      _result = result;
      _isTesting = false;
    });
  }

  Widget _buildStressTestWidget() {
    return AnimatedBuilder(
      animation: _stressTestController,
      builder: (context, child) {
        return Stack(
          children: [
            // Multiple glassmorphism cards
            for (int i = 0; i < 5; i++)
              Positioned(
                left: 20.0 + i * 50 * _stressTestController.value,
                top: 100.0 + i * 30 * _stressTestController.value,
                child: GlassmorphicCard(
                  width: 100,
                  height: 80,
                  enableGlow: true,
                  child: const FlutterLogo(),
                ),
              ),

            // Floating particles
            const FloatingParticlesWidget(
              particleCount: 20,
              enableGlow: true,
              enablePhysics: true,
            ),

            // Animated backgrounds
            const AnimatedGradientBackground(
              enableRotation: true,
              enablePulse: true,
            ),

            // Test widget
            Center(child: widget.testWidget),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Test: ${widget.testName}'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.grey.shade900],
          ),
        ),
        child: Column(
          children: [
            // Contrôles de test
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTesting ? null : _runPerformanceTest,
                    icon: _isTesting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.speed),
                    label: Text(_isTesting ? 'Testing...' : 'Run Benchmark'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Résultats
            if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: GlassmorphicCard(
                    enableGlow: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊 RÉSULTATS DU BENCHMARK',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 20),

                          // Métriques principales
                          _buildMetricRow(
                            'Frame Rate',
                            '${_result!.frameRate.toStringAsFixed(2)} fps',
                            _result!.frameRate >= 55
                                ? Colors.green
                                : Colors.red,
                          ),
                          _buildMetricRow(
                            'Temps Frame Moyen',
                            '${_result!.averageFrameTime.inMicroseconds}μs',
                            _result!.averageFrameTime <=
                                    PerformanceBenchmark.targetFrameTime
                                ? Colors.green
                                : Colors.red,
                          ),
                          _buildMetricRow(
                            'Frames Perdues',
                            '${_result!.droppedFrames}',
                            _result!.droppedFrames <= 3
                                ? Colors.green
                                : Colors.red,
                          ),
                          _buildMetricRow(
                            'Score Performance',
                            '${_result!.performanceScore.toStringAsFixed(1)}%',
                            _result!.isOptimal ? Colors.green : Colors.red,
                          ),

                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _result!.isOptimal
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _result!.isOptimal
                                    ? Colors.green
                                    : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _result!.isOptimal
                                  ? '✅ PERFORMANCE OPTIMALE - 60fps maintenu !'
                                  : '❌ OPTIMISATION REQUISE - Frame rate insuffisant',
                              style: TextStyle(
                                color: _result!.isOptimal
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Recommandations
                          if (!_result!.isOptimal)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🔧 RECOMMANDATIONS D\'OPTIMISATION:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '• Utiliser RepaintBoundary pour isoler les animations\n'
                                    '• Réduire le nombre de particules flottantes\n'
                                    '• Optimiser les CustomPainters\n'
                                    '• Utiliser des images optimisées\n'
                                    '• Implémenter le lazy loading',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Widget de test
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _buildStressTestWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tests de performance prédéfinis
class GlassmorphismPerformanceTests {
  static Widget get glassmorphicCardTest =>
      const GlassmorphicCard(enableGlow: true, child: FlutterLogo(size: 100));

  static Widget get glassmorphicButtonTest => GlassmorphicButton(
    text: 'Test Button',
    onPressed: () {},
    isPrimary: true,
  );

  static Widget get floatingParticlesTest => const FloatingParticlesWidget(
    particleCount: 15,
    enableGlow: true,
    enablePhysics: true,
  );

  static Widget get animatedBackgroundTest =>
      const AnimatedGradientBackground(enableRotation: true, enablePulse: true);

  static Widget get complexLayoutTest => Column(
    children: [
      const GlassmorphicCard(enableGlow: true, child: FlutterLogo(size: 80)),
      const SizedBox(height: 20),
      Row(
        children: [
          GlassmorphicButton(
            text: 'Button 1',
            onPressed: () {},
            isPrimary: true,
            size: ButtonSize.small,
          ),
          const SizedBox(width: 16),
          GlassmorphicButton(
            text: 'Button 2',
            onPressed: () {},
            isPrimary: false,
            size: ButtonSize.small,
          ),
        ],
      ),
    ],
  );
}
