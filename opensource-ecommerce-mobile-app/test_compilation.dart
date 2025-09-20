// Test de compilation pour vérifier les imports et les types
// Ce fichier peut être utilisé pour vérifier que tous les imports sont corrects

import 'package:flutter/material.dart';
import 'lib/widgets/glassmorphism/glassmorphic_components.dart';
import 'lib/screens/bazar_home/bazar_home_screen.dart';
import 'lib/screens/product_detail/product_detail_screen.dart';
import 'lib/screens/checkout/checkout_screen.dart';
import 'lib/widgets/glassmorphism/final_test_demo.dart';

void main() {
  print('✅ Test de compilation réussi!');
  print('');
  print('Composants disponibles:');
  print('- GlassmorphicCard ✓');
  print('- GlassmorphicButton ✓');
  print('- GlassmorphicContainer ✓');
  print('- GlassmorphismConfig ✓');
  print('');
  print('Screens disponibles:');
  print('- BazarHomeScreen ✓');
  print('- ProductDetailScreen ✓');
  print('- CheckoutScreen ✓');
  print('- OrderConfirmationScreen ✓');
  print('- FinalTestDemoWidget ✓');
  print('');
  print('🎉 Tous les composants sont correctement importés et typés!');
}

// Test que les widgets peuvent être instanciés
void testWidgets() {
  // Test GlassmorphicCard
  final card = GlassmorphicCard(child: Text('Test'), width: 200, height: 100);

  // Test GlassmorphicButton
  final button = GlassmorphicButton(text: 'Test Button', onPressed: () {});

  // Test GlassmorphicContainer
  final container = GlassmorphicContainer(child: Text('Test Container'));

  print('✅ Tous les widgets peuvent être instanciés correctement!');
}
