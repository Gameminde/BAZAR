/*
 * Tests Multi-Devices - BAZAR 2025
 * Validation sur tous les supports et résolutions
 */

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bazar_marketplace_app/widgets/glassmorphism/index.dart';

/// Configuration des devices de test
class DeviceConfig {
  final String name;
  final double width;
  final double height;
  final double pixelRatio;
  final String description;

  const DeviceConfig({
    required this.name,
    required this.width,
    required this.height,
    this.pixelRatio = 1.0,
    required this.description,
  });
}

/// Devices de test prédéfinis
class TestDevices {
  static const DeviceConfig iPhoneSE = DeviceConfig(
    name: 'iPhone SE',
    width: 375,
    height: 667,
    pixelRatio: 2.0,
    description: 'Petit écran - 4 pouces',
  );

  static const DeviceConfig iPhone12 = DeviceConfig(
    name: 'iPhone 12',
    width: 390,
    height: 844,
    pixelRatio: 3.0,
    description: 'Écran moyen - 6.1 pouces',
  );

  static const DeviceConfig iPhone12ProMax = DeviceConfig(
    name: 'iPhone 12 Pro Max',
    width: 428,
    height: 926,
    pixelRatio: 3.0,
    description: 'Grand écran - 6.7 pouces',
  );

  static const DeviceConfig iPad = DeviceConfig(
    name: 'iPad',
    width: 768,
    height: 1024,
    pixelRatio: 2.0,
    description: 'Tablette - 10.2 pouces',
  );

  static const DeviceConfig iPadPro = DeviceConfig(
    name: 'iPad Pro',
    width: 1024,
    height: 1366,
    pixelRatio: 2.0,
    description: 'Tablette Pro - 12.9 pouces',
  );

  static const DeviceConfig androidSmall = DeviceConfig(
    name: 'Android Small',
    width: 360,
    height: 640,
    pixelRatio: 2.0,
    description: 'Android petit écran',
  );

  static const DeviceConfig androidTablet = DeviceConfig(
    name: 'Android Tablet',
    width: 800,
    height: 1280,
    pixelRatio: 2.0,
    description: 'Tablette Android',
  );

  static const DeviceConfig desktopSmall = DeviceConfig(
    name: 'Desktop Small',
    width: 1024,
    height: 768,
    pixelRatio: 1.0,
    description: 'Desktop petite résolution',
  );

  static const DeviceConfig desktopHD = DeviceConfig(
    name: 'Desktop HD',
    width: 1920,
    height: 1080,
    pixelRatio: 1.0,
    description: 'Desktop Full HD',
  );

  static List<DeviceConfig> get allDevices => [
    iPhoneSE,
    iPhone12,
    iPhone12ProMax,
    iPad,
    iPadPro,
    androidSmall,
    androidTablet,
    desktopSmall,
    desktopHD,
  ];
}

/// Widget de test multi-devices
class MultiDeviceTestWidget extends StatefulWidget {
  final Widget testWidget;
  final String testName;

  const MultiDeviceTestWidget({
    Key? key,
    required this.testWidget,
    required this.testName,
  }) : super(key: key);

  @override
  _MultiDeviceTestWidgetState createState() => _MultiDeviceTestWidgetState();
}

class _MultiDeviceTestWidgetState extends State<MultiDeviceTestWidget> {
  DeviceConfig? _selectedDevice;
  bool _showGrid = false;
  bool _showSafeArea = false;
  bool _showNotches = true;

  @override
  void initState() {
    super.initState();
    _selectedDevice = TestDevices.iPhone12; // Device par défaut
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Device Test: ${widget.testName}'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(_showSafeArea ? Icons.border_style : Icons.border_clear),
            onPressed: () => setState(() => _showSafeArea = !_showSafeArea),
            tooltip: 'Toggle Safe Area',
          ),
          IconButton(
            icon: Icon(_showNotches ? Icons.phone_android : Icons.smartphone),
            onPressed: () => setState(() => _showNotches = !_showNotches),
            tooltip: 'Toggle Notches',
          ),
          PopupMenuButton<DeviceConfig>(
            onSelected: (device) => setState(() => _selectedDevice = device),
            itemBuilder: (context) => TestDevices.allDevices.map((device) {
              return PopupMenuItem<DeviceConfig>(
                value: device,
                child: Text('${device.name} - ${device.description}'),
              );
            }).toList(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(_selectedDevice?.name ?? 'Select Device'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Métriques du device sélectionné
                  if (_selectedDevice != null)
                    GlassmorphicCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📱 DEVICE: ${_selectedDevice!.name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Description: ${_selectedDevice!.description}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Résolution: ${_selectedDevice!.width.toInt()} × ${_selectedDevice!.height.toInt()}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Pixel Ratio: ${_selectedDevice!.pixelRatio}x',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inches: ${_calculateInches(_selectedDevice!)}"',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Zone de test
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: _buildDevicePreview(),
              ),
            ),

            // Grille des devices disponibles
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: TestDevices.allDevices.length,
                itemBuilder: (context, index) {
                  final device = TestDevices.allDevices[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => setState(() => _selectedDevice = device),
                      child: GlassmorphicCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getDeviceIcon(device.name),
                              color: _selectedDevice == device
                                  ? const Color(0xFFF4A261)
                                  : Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              device.name,
                              style: TextStyle(
                                color: _selectedDevice == device
                                    ? const Color(0xFFF4A261)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${device.width.toInt()}×${device.height.toInt()}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicePreview() {
    if (_selectedDevice == null) {
      return const Center(
        child: Text(
          'Sélectionnez un device',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Center(
      child: GlassmorphicCard(
        child: Container(
          width: _selectedDevice!.width + 40,
          height: _selectedDevice!.height + 40,
          padding: const EdgeInsets.all(20),
          child: MediaQuery(
            data: MediaQueryData(
              size: Size(_selectedDevice!.width, _selectedDevice!.height),
              devicePixelRatio: _selectedDevice!.pixelRatio,
              padding: _showSafeArea
                  ? const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    )
                  : EdgeInsets.zero,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _showGrid ? Colors.white30 : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Device frame
                    _buildDeviceFrame(),

                    // Test widget
                    Positioned.fill(child: widget.testWidget),

                    // Grid overlay
                    if (_showGrid)
                      CustomPaint(
                        painter: GridPainter(
                          step: 20,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: Container(),
                      ),

                    // Notch simulation
                    if (_showNotches && _hasNotch(_selectedDevice!.name))
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
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

  Widget _buildDeviceFrame() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30, width: 4),
        borderRadius: BorderRadius.circular(22),
        color: Colors.black,
      ),
    );
  }

  IconData _getDeviceIcon(String deviceName) {
    if (deviceName.contains('iPhone')) return Icons.phone_iphone;
    if (deviceName.contains('iPad')) return Icons.tablet;
    if (deviceName.contains('Android')) return Icons.phone_android;
    return Icons.devices;
  }

  String _calculateInches(DeviceConfig device) {
    final diagonal =
        (device.width * device.width + device.height * device.height) /
        (device.pixelRatio * device.pixelRatio);
    return (math.sqrt(diagonal) / 96).toStringAsFixed(1); // 96 DPI
  }

  bool _hasNotch(String deviceName) {
    return deviceName.contains('iPhone') && !deviceName.contains('SE');
  }
}

/// Painter pour afficher une grille de guide
class GridPainter extends CustomPainter {
  final double step;
  final Color color;

  GridPainter({required this.step, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Lignes verticales
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Lignes horizontales
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tests multi-devices prédéfinis
class MultiDeviceTestSuite {
  static Widget get glassmorphismHomePageTest => const GlassmorphicHomePage();

  static Widget get glassmorphismCardTest =>
      const GlassmorphicCard(enableGlow: true, child: FlutterLogo(size: 100));

  static Widget get floatingParticlesTest => const FloatingParticlesWidget(
    particleCount: 15,
    enableGlow: true,
    enablePhysics: true,
  );

  static Widget get complexLayoutTest => Column(
    children: [
      const GlassmorphicCard(
        enableGlow: true,
        child: Text('Complex Layout Test'),
      ),
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

/// Widget de résultats des tests multi-devices
class MultiDeviceTestResults extends StatelessWidget {
  final Map<DeviceConfig, bool> testResults;
  final Map<DeviceConfig, String> notes;

  const MultiDeviceTestResults({
    Key? key,
    required this.testResults,
    this.notes = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Device Test Results'),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: testResults.length,
          itemBuilder: (context, index) {
            final device = testResults.keys.elementAt(index);
            final isPassed = testResults[device]!;
            final note = notes[device] ?? '';

            return GlassmorphicCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(
                  isPassed ? Icons.check_circle : Icons.error,
                  color: isPassed ? Colors.green : Colors.red,
                ),
                title: Text(
                  device.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.description,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (note.isNotEmpty)
                      Text(
                        'Note: $note',
                        style: const TextStyle(color: Colors.orange),
                      ),
                  ],
                ),
                trailing: Text(
                  '${device.width.toInt()}×${device.height.toInt()}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
