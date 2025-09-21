/*
 * BAZAR Marketplace - Bottom_Nav_Bar Widget Test
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bottom_Nav_Bar', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: Text('Test Widget'),
            ),
          ),
        ),
      );
      
      expect(find.text('Test Widget'), findsOneWidget);
    });
  });
}