/*
 * BAZAR Marketplace - Home Screen Golden Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart';

void main() {
  group('Home Screen Golden Tests', () {
    testWidgets('home screen golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BazarHomeScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Take golden screenshot
      await expectLater(
        find.byType(BazarHomeScreen),
        matchesGoldenFile('home_screen.png'),
      );
    });
    
    testWidgets('home screen with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: BazarHomeScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Take golden screenshot for dark theme
      await expectLater(
        find.byType(BazarHomeScreen),
        matchesGoldenFile('home_screen_dark.png'),
      );
    });
  });
}