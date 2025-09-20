/*
 * Test des composants Glassmorphism - BAZAR 2025
 * Validation complète de la Phase 1
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'index.dart';
import '../../utils/bazar_theme.dart';

/// Test widget pour valider les composants glassmorphism
class GlassmorphismTestWidget extends StatelessWidget {
  const GlassmorphismTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          const GlassmorphismThemeExtension(),
        ],
      ),
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test GlassmorphicCard
              const Text(
                '🃏 Test GlassmorphicCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GlassmorphicCard(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'GlassmorphicCard - Test réussi',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Test GlassmorphicButton
              const Text(
                '🔘 Test GlassmorphicButton',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GlassmorphicButton(
                    text: 'Primary',
                    onPressed: () {},
                    isPrimary: true,
                  ),
                  const SizedBox(width: 10),
                  GlassmorphicButton(
                    text: 'Secondary',
                    onPressed: () {},
                    isPrimary: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Test GlassmorphicIconButton
              const Text(
                '🔍 Test GlassmorphicIconButton',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GlassmorphicIconButton(
                    icon: Icons.favorite,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  GlassmorphicIconButton(icon: Icons.search, onPressed: () {}),
                ],
              ),
              const SizedBox(height: 20),

              // Test GlassmorphicFloatingActionButton
              const Text(
                '➕ Test GlassmorphicFloatingActionButton',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GlassmorphicIconButton(icon: Icons.add, onPressed: () {}),
              const SizedBox(height: 20),

              // Test ProductGlassmorphicCard
              const Text(
                '🛒 Test ProductGlassmorphicCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ProductGlassmorphicCard(
                image: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        GlassmorphismTheme.glassPrimary,
                        GlassmorphismTheme.glassSecondary,
                      ],
                    ),
                  ),
                  child: const Icon(Icons.image, color: Colors.white, size: 48),
                ),
                title: 'Test Produit',
                price: '29,99 €',
                onTap: () {},
                isFavorite: true,
                onFavoriteTap: () {},
              ),
              const SizedBox(height: 20),

              // Test CategoryGlassmorphicCard
              const Text(
                '📂 Test CategoryGlassmorphicCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CategoryGlassmorphicCard(
                icon: Icons.category,
                title: 'Test Catégorie',
                onTap: () {},
              ),
              const SizedBox(height: 20),

              // Test ActionGlassmorphicCard
              const Text(
                '⚡ Test ActionGlassmorphicCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ActionGlassmorphicCard(
                icon: Icons.add_shopping_cart,
                title: 'Test Action',
                onTap: () {},
                isPrimary: true,
              ),
              const SizedBox(height: 20),

              // Test OptimizedGlassmorphicCard
              const Text(
                '⚡ Test OptimizedGlassmorphicCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              OptimizedGlassmorphicCard(
                enableGlow: true,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'OptimizedGlassmorphicCard - GPU Optimized',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget de test pour l'AppBar glassmorphism
class GlassmorphicAppBarTest extends StatelessWidget {
  const GlassmorphicAppBarTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          const GlassmorphismThemeExtension(),
        ],
      ),
      home: Scaffold(
        appBar: GlassmorphicAppBar(
          title: 'BAZAR Glassmorphism',
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
          showBackButton: true,
          onBackPressed: () {},
        ),
        body: Container(
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
          child: const Center(
            child: Text(
              'Test AppBar Glassmorphism',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de test pour CompactGlassmorphicAppBar
class CompactGlassmorphicAppBarTest extends StatelessWidget {
  const CompactGlassmorphicAppBarTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          const GlassmorphismThemeExtension(),
        ],
      ),
      home: Scaffold(
        appBar: const CompactGlassmorphicAppBar(
          title: 'Compact AppBar',
          showBackButton: true,
        ),
        body: Container(
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
          child: const Center(
            child: Text(
              'Test Compact AppBar',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de test pour AnimatedGlassmorphicAppBar
class AnimatedGlassmorphicAppBarTest extends StatefulWidget {
  const AnimatedGlassmorphicAppBarTest({Key? key}) : super(key: key);

  @override
  _AnimatedGlassmorphicAppBarTestState createState() =>
      _AnimatedGlassmorphicAppBarTestState();
}

class _AnimatedGlassmorphicAppBarTestState
    extends State<AnimatedGlassmorphicAppBarTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          const GlassmorphismThemeExtension(),
        ],
      ),
      home: Scaffold(
        appBar: const AnimatedGlassmorphicAppBar(
          title: 'Animated AppBar',
          showBackButton: true,
        ),
        body: Container(
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
          child: const Center(
            child: Text(
              'Test Animated AppBar avec particules',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tests unitaires pour les composants glassmorphism
void runGlassmorphismTests() {
  testWidgets('GlassmorphicCard renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            const GlassmorphismThemeExtension(),
          ],
        ),
        home: const GlassmorphicCard(child: Text('Test')),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('GlassmorphicButton renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            const GlassmorphismThemeExtension(),
          ],
        ),
        home: GlassmorphicButton(text: 'Test Button', onPressed: () {}),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('GlassmorphicAppBar renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: GlassmorphicAppBar(title: 'Test')),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('ProductGlassmorphicCard renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            const GlassmorphismThemeExtension(),
          ],
        ),
        home: ProductGlassmorphicCard(
          image: Container(),
          title: 'Test Product',
          price: '€9.99',
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('€9.99'), findsOneWidget);
  });

  testWidgets('CategoryGlassmorphicCard renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            const GlassmorphismThemeExtension(),
          ],
        ),
        home: CategoryGlassmorphicCard(
          icon: Icons.category,
          title: 'Test Category',
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Test Category'), findsOneWidget);
  });
}
