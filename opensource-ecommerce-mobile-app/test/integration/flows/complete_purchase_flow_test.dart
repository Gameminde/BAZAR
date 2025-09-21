/*
 * BAZAR Marketplace - Complete Purchase Flow Integration Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bazar_marketplace_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Complete Purchase Flow', () {
    testWidgets('should complete full purchase flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 1. Navigate to product detail
      final productCard = find.byType(ProductCard).first;
      await tester.tap(productCard);
      await tester.pumpAndSettle();
      
      // 2. Add product to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      
      // 3. Navigate to cart
      final cartButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // 4. Proceed to checkout
      final checkoutButton = find.text('Proceed to Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();
      
      // 5. Verify checkout screen
      expect(find.byType(CheckoutScreen), findsOneWidget);
    });
    
    testWidgets('should handle empty cart scenario', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to cart when empty
      final cartButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // Verify empty cart message
      expect(find.text('Your cart is empty'), findsOneWidget);
    });
  });
}