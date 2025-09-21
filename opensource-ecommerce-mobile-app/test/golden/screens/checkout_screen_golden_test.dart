/*
 * BAZAR Marketplace - Checkout Screen Golden Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/features/cart/checkout/checkout_screen.dart';

void main() {
  group('Checkout Screen Golden Tests', () {
    testWidgets('checkout screen golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CheckoutScreen(
            total: 99.99,
            cartScreenBloc: null,
            cartDetailsModel: null,
            isDownloadable: false,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Take golden screenshot
      await expectLater(
        find.byType(CheckoutScreen),
        matchesGoldenFile('checkout_screen.png'),
      );
    });
  });
}