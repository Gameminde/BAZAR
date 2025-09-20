/*
 * Démonstration de la Transformation Glassmorphism - BAZAR 2025
 * Showcase complet de la Phase 3 - Transformation Écrans
 */

import 'package:flutter/material.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/index.dart';
import 'package:bazar_marketplace_app/data_model/product_model/product_screen_model.dart';
import 'package:bazar_marketplace_app/utils/glassmorphism_theme_extension.dart';
import 'package:bazar_marketplace_app/utils/glassmorphism_theme.dart';

class GlassmorphismTransformationDemo extends StatefulWidget {
  const GlassmorphismTransformationDemo({Key? key}) : super(key: key);

  @override
  _GlassmorphismTransformationDemoState createState() =>
      _GlassmorphismTransformationDemoState();
}

class _GlassmorphismTransformationDemoState
    extends State<GlassmorphismTransformationDemo> {
  bool showOriginalDesign = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          const GlassmorphismThemeExtension(
            glassmorphismTheme: GlassmorphismTheme.defaultTheme,
          ),
        ],
      ),
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        appBar: GlassmorphicAppBar(
          title: '🚀 BAZAR 2025 - Transformation Spectaculaire',
          actions: [
            GlassmorphicIconButton(
              icon: Icons.lightbulb,
              onPressed: () =>
                  setState(() => showOriginalDesign = !showOriginalDesign),
            ),
          ],
        ),
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
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de présentation
                  GlassmorphicCard(
                    enableGlow: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎨 TRANSFORMATION GLASSMORPHISM 2025',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Découvrez la transformation spectaculaire de BAZAR avec les effets glassmorphism premium tendance 2025.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              GlassmorphicButton(
                                text: 'Phase 3 Active',
                                isPrimary: true,
                                icon: Icons.rocket_launch,
                                size: ButtonSize.small,
                              ),
                              const SizedBox(width: 16),
                              GlassmorphicButton(
                                text: '60fps Animations',
                                isPrimary: false,
                                icon: Icons.speed,
                                size: ButtonSize.small,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Comparaison avant/après
                  Text(
                    '🔄 COMPARAISON AVANT/APRÈS',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: GlassmorphicCard(
                          enableGlow: true,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.smartphone,
                                color: Colors.white,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Design Original',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Interface standard\nsans effets visuels',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GlassmorphicCard(
                          enableGlow: true,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.diamond,
                                color: GlassmorphismTheme.glassAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Glassmorphism 2025',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Effets premium\nAnimations fluides 60fps',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Fonctionnalités implémentées
                  Text(
                    '✅ FONCTIONNALITÉS IMPLÉMENTÉES',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phase 1
                  _buildFeatureCard(
                    title: 'Phase 1 - Système de Thèmes',
                    description:
                        'Extension GlassmorphismTheme avec couleurs, gradients et animations configurables',
                    icon: Icons.palette,
                    isCompleted: true,
                  ),

                  const SizedBox(height: 16),

                  // Phase 2
                  _buildFeatureCard(
                    title: 'Phase 2 - Effets Visuels Avancés',
                    description:
                        'Particules flottantes, backgrounds animés, lumière dynamique et vagues',
                    icon: Icons.auto_awesome,
                    isCompleted: true,
                  ),

                  const SizedBox(height: 16),

                  // Phase 3
                  _buildFeatureCard(
                    title: 'Phase 3 - Transformation Écrans',
                    description:
                        'HomePage glassmorphism avec hero section, catégories premium et footer immersif',
                    icon: Icons.smartphone,
                    isCompleted: true,
                  ),

                  const SizedBox(height: 30),

                  // Composants disponibles
                  Text(
                    '🧰 COMPOSANTS DISPONIBLES',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Composants Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildComponentCard(
                        title: 'GlassmorphicCard',
                        description: 'Cartes avec blur et transparence',
                        icon: Icons.credit_card,
                      ),
                      _buildComponentCard(
                        title: 'GlassmorphicButton',
                        description: 'Boutons premium animés',
                        icon: Icons.smart_button,
                      ),
                      _buildComponentCard(
                        title: 'GlassmorphicAppBar',
                        description: 'Navigation avec particules',
                        icon: Icons.navigation,
                      ),
                      _buildComponentCard(
                        title: 'FloatingParticles',
                        description: 'Système de particules flottantes',
                        icon: Icons.grain,
                      ),
                      _buildComponentCard(
                        title: 'AnimatedBackgrounds',
                        description: 'Gradients et vagues animés',
                        icon: Icons.wallpaper,
                      ),
                      _buildComponentCard(
                        title: 'GlassmorphicHomePage',
                        description: 'Page d\'accueil complète',
                        icon: Icons.home,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Performance metrics
                  Text(
                    '⚡ MÉTRIQUES DE PERFORMANCE',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Animations',
                          value: '60fps',
                          icon: Icons.speed,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Composants',
                          value: '15+',
                          icon: Icons.widgets,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Effets',
                          value: '8',
                          icon: Icons.auto_awesome,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  GlassmorphicCard(
                    enableGlow: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '🎊 TRANSFORMATION RÉUSSIE !',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'BAZAR 2025 dispose maintenant d\'une interface premium avec glassmorphism qui impressionnera les utilisateurs et positionnera l\'application comme une référence mondiale en design mobile Flutter.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          GlassmorphicButton(
                            text: 'Continuer vers Phase 4',
                            icon: Icons.arrow_forward,
                            onPressed: () {},
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isCompleted,
  }) {
    return GlassmorphicCard(
      enableGlow: isCompleted,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isCompleted
                  ? GlassmorphismTheme.glassAccent
                  : Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: isCompleted ? Colors.green : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: GlassmorphismTheme.glassAccent, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
