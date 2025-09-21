/*
 * BAZAR Marketplace - Input Validator Test
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:bazar_marketplace_app/core/utils/input_validator.dart';

void main() {
  group('InputValidator', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(InputValidator.validateEmail('test@example.com'), isNull);
        expect(InputValidator.validateEmail('user.name@domain.co.uk'), isNull);
      });
      
      test('should return error for invalid email', () {
        expect(InputValidator.validateEmail('invalid'), isNotNull);
        expect(InputValidator.validateEmail('test@'), isNotNull);
        expect(InputValidator.validateEmail('@domain.com'), isNotNull);
      });
      
      test('should return error for null or empty email', () {
        expect(InputValidator.validateEmail(null), isNotNull);
        expect(InputValidator.validateEmail(''), isNotNull);
      });
    });
    
    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(InputValidator.validatePassword('password123'), isNull);
        expect(InputValidator.validatePassword('123456'), isNull);
      });
      
      test('should return error for short password', () {
        expect(InputValidator.validatePassword('12345'), isNotNull);
        expect(InputValidator.validatePassword(''), isNotNull);
      });
    });
    
    group('validateRequired', () {
      test('should return null for non-empty value', () {
        expect(InputValidator.validateRequired('test', 'Field'), isNull);
        expect(InputValidator.validateRequired('123', 'Number'), isNull);
      });
      
      test('should return error for empty value', () {
        expect(InputValidator.validateRequired('', 'Field'), isNotNull);
        expect(InputValidator.validateRequired(null, 'Field'), isNotNull);
      });
    });
  });
}