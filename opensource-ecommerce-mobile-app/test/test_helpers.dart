/*
 * BAZAR Marketplace - Test Helpers
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/main.dart';

class TestHelpers {
  static Widget createTestApp({Widget? home, ThemeData? theme}) {
    return MaterialApp(
      home: home ?? const Scaffold(body: Text('Test')),
      theme: theme,
    );
  }
  
  static Widget createTestAppWithRouter() {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
    );
  }
  
  static Future<void> pumpApp(WidgetTester tester, {Widget? home}) async {
    await tester.pumpWidget(createTestApp(home: home));
    await tester.pumpAndSettle();
  }
  
  static Future<void> navigateToScreen(WidgetTester tester, String routeName) async {
    // Navigate using GoRouter
    // TODO: Implement navigation helper
  }
  
  static void expectGoldenMatches(WidgetTester tester, String fileName) {
    expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(fileName),
    );
  }
  
  static void expectTextExists(String text) {
    expect(find.text(text), findsOneWidget);
  }
  
  static void expectWidgetExists(Type widgetType) {
    expect(find.byType(widgetType), findsOneWidget);
  }
  
  static void expectMultipleWidgetsExist(Type widgetType, int count) {
    expect(find.byType(widgetType), findsNWidgets(count));
  }
}

class MockData {
  static const Map<String, dynamic> testProduct = {
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
  
  static const List<Map<String, dynamic>> testProducts = [
    testProduct,
    {
      'id': '2',
      'name': 'Another Product',
      'price': 79.99,
      'oldPrice': null,
      'rating': 4.2,
      'reviews': 87,
      'image': 'https://example.com/image2.jpg',
      'isNew': false,
      'discount': 0,
    },
  ];
}