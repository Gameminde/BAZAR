/*
 * BAZAR Marketplace - ProductCard Widget Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/product_card.dart';

void main() {
  group('ProductCard', () {
    final testProduct = {
      'id': '1',
      'name': 'Test Product',
      'price': 99.99,
      'oldPrice': 149.99,
      'rating': 4.5,
      'reviews': 123,
      'image': 'https://example.com/image.jpg',
      'isNew': true,
      'discount': 33,
    };
    
    testWidgets('should display product information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );
      
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text(r'\$99.99'), findsOneWidget);
      expect(find.text(r'\$149.99'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });
    
    testWidgets('should show new badge when product is new', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );
      
      expect(find.text('NEW'), findsOneWidget);
    });
    
    testWidgets('should show discount percentage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );
      
      expect(find.text('-33%'), findsOneWidget);
    });
  });
}