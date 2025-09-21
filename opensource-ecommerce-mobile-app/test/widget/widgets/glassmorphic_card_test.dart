/*
 * BAZAR Marketplace - GlassmorphicCard Widget Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart';

void main() {
  group('GlassmorphicCard', () {
    testWidgets('should render with required properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassmorphicCard(
              child: Text('Test Card'),
            ),
          ),
        ),
      );
      
      expect(find.text('Test Card'), findsOneWidget);
      expect(find.byType(GlassmorphicCard), findsOneWidget);
    });
    
    testWidgets('should apply custom opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassmorphicCard(
              opacity: 0.1,
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      expect(find.byType(GlassmorphicCard), findsOneWidget);
    });
    
    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassmorphicCard(
              onTap: () => tapped = true,
              child: Text('Tap me'),
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(GlassmorphicCard));
      expect(tapped, isTrue);
    });
  });
}