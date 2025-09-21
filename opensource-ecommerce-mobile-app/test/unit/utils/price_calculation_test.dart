/*
 * BAZAR Marketplace - Price Calculation Test
 */

import 'package:flutter_test/flutter_test.dart';

class PriceCalculator {
  static double calculateDiscount(double originalPrice, double discountPercent) {
    return originalPrice - (originalPrice * discountPercent / 100);
  }
  
  static double calculateTax(double price, double taxPercent) {
    return price + (price * taxPercent / 100);
  }
  
  static double calculateTotal(double price, double tax, double shipping) {
    return price + tax + shipping;
  }
}

void main() {
  group('PriceCalculator', () {
    group('calculateDiscount', () {
      test('should calculate 20% discount correctly', () {
        expect(PriceCalculator.calculateDiscount(100, 20), equals(80));
        expect(PriceCalculator.calculateDiscount(50, 20), equals(40));
      });
      
      test('should handle zero discount', () {
        expect(PriceCalculator.calculateDiscount(100, 0), equals(100));
      });
      
      test('should handle 100% discount', () {
        expect(PriceCalculator.calculateDiscount(100, 100), equals(0));
      });
    });
    
    group('calculateTax', () {
      test('should calculate 10% tax correctly', () {
        expect(PriceCalculator.calculateTax(100, 10), equals(110));
        expect(PriceCalculator.calculateTax(50, 10), equals(55));
      });
    });
    
    group('calculateTotal', () {
      test('should calculate total correctly', () {
        expect(PriceCalculator.calculateTotal(100, 10, 5), equals(115));
        expect(PriceCalculator.calculateTotal(50, 5, 2.5), equals(57.5));
      });
    });
  });
}