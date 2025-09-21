/*
 * BAZAR Marketplace - Home to Product Integration Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bazar_marketplace_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Home to Product Flow', () {
    testWidgets('should navigate from home to product detail', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Wait for home screen to load
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Find and tap a product card
      final productCard = find.byType(ProductCard).first;
      expect(productCard, findsOneWidget);
      
      await tester.tap(productCard);
      await tester.pumpAndSettle();
      
      // Verify navigation to product detail
      expect(find.byType(ProductDetailScreen), findsOneWidget);
    });
    
    testWidgets('should display product information correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to product detail
      final productCard = find.byType(ProductCard).first;
      await tester.tap(productCard);
      await tester.pumpAndSettle();
      
      // Verify product details are displayed
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(ProductImageView), findsOneWidget);
    });
  });
}