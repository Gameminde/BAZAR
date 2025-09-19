/*
 * Unit tests for BagistoApiService authentication functionality
 * Tests token lifecycle and authentication flows
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:bazar_marketplace_app/services/bazar_api_service.dart';
import 'package:bazar_marketplace_app/utils/shared_preference_helper.dart';
import 'package:bazar_marketplace_app/utils/bagisto_config.dart';

@GenerateMocks([Dio, SharedPreferenceHelper])
void main() {
  group('BazarApiService Authentication Tests', () {
    late BazarApiService apiService;
    late MockDio mockDio;
    late MockSharedPreferenceHelper mockPrefs;

    setUp(() {
      // Initialize GetStorage for testing
      GetStorage.init('test_storage');

      mockDio = MockDio();
      mockPrefs = MockSharedPreferenceHelper();

      // Mock the singleton instance
      apiService = BazarApiService();
    });

    tearDown(() {
      // Clean up after tests
    });

    group('Token Management', () {
      test('should load tokens from storage on initialization', () async {
        // Arrange
        const testToken = 'test_auth_token';
        const testRefreshToken = 'test_refresh_token';

        when(mockPrefs.getCustomerToken()).thenReturn(testToken);
        when(mockPrefs.getRefreshToken()).thenReturn(testRefreshToken);

        // Act
        await apiService.initialize();

        // Assert
        expect(apiService.authToken, equals(testToken));
        expect(apiService.isAuthenticated, isTrue);
      });

      test('should return false for isAuthenticated when no token', () async {
        // Arrange
        when(mockPrefs.getCustomerToken()).thenReturn('0');
        when(mockPrefs.getRefreshToken()).thenReturn('0');

        // Act
        await apiService.initialize();

        // Assert
        expect(apiService.isAuthenticated, isFalse);
        expect(apiService.authToken, isNull);
      });

      test('should save tokens after successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const authToken = 'new_auth_token';
        const refreshToken = 'new_refresh_token';

        final loginResponse = Response(
          requestOptions: RequestOptions(path: '/customer/auth/login'),
          statusCode: 200,
          data: {
            'data': {
              'access_token': authToken,
              'refresh_token': refreshToken,
              'customer': {'id': 1, 'email': email},
            },
          },
        );

        when(
          mockDio.post('/customer/auth/login', data: anyNamed('data')),
        ).thenAnswer((_) async => loginResponse);

        // Act
        final result = await apiService.login(email, password);

        // Assert
        expect(result['success'], isTrue);
        expect(result['data']['email'], equals(email));
        expect(apiService.authToken, equals(authToken));
        expect(apiService.isAuthenticated, isTrue);
      });

      test('should clear tokens on logout', () async {
        // Arrange
        const testToken = 'test_token';
        when(mockPrefs.getCustomerToken()).thenReturn(testToken);
        when(mockDio.post('/customer/auth/logout')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/customer/auth/logout'),
            statusCode: 200,
          ),
        );

        await apiService.initialize();

        // Act
        final result = await apiService.logout();

        // Assert
        expect(result['success'], isTrue);
        expect(apiService.authToken, isNull);
        expect(apiService.isAuthenticated, isFalse);
      });
    });

    group('Authentication Flow', () {
      test('should handle login failure gracefully', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpassword';

        when(
          mockDio.post('/customer/auth/login', data: anyNamed('data')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/customer/auth/login'),
            response: Response(
              requestOptions: RequestOptions(path: '/customer/auth/login'),
              statusCode: 401,
              data: {'message': 'Invalid credentials'},
            ),
          ),
        );

        // Act
        final result = await apiService.login(email, password);

        // Assert
        expect(result['success'], isFalse);
        expect(result['message'], isNotEmpty);
        expect(apiService.isAuthenticated, isFalse);
      });

      test('should handle registration success', () async {
        // Arrange
        const userData = {
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john@example.com',
          'password': 'password123',
          'passwordConfirmation': 'password123',
          'phone': '+1234567890',
        };

        const authToken = 'new_auth_token';
        const refreshToken = 'new_refresh_token';

        final registerResponse = Response(
          requestOptions: RequestOptions(path: '/customer/auth/register'),
          statusCode: 201,
          data: {
            'data': {
              'access_token': authToken,
              'refresh_token': refreshToken,
              'customer': {'id': 1, 'email': userData['email']},
            },
          },
        );

        when(
          mockDio.post('/customer/auth/register', data: anyNamed('data')),
        ).thenAnswer((_) async => registerResponse);

        // Act
        final result = await apiService.register(userData);

        // Assert
        expect(result['success'], isTrue);
        expect(result['data']['email'], equals(userData['email']));
        expect(apiService.authToken, equals(authToken));
      });

      test('should refresh token automatically on 401 error', () async {
        // Arrange
        const oldToken = 'old_token';
        const newToken = 'new_token';
        const refreshToken = 'refresh_token';

        when(mockPrefs.getCustomerToken()).thenReturn(oldToken);
        when(mockPrefs.getRefreshToken()).thenReturn(refreshToken);

        // Mock the 401 error first
        when(mockDio.get('/customer/profile')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/customer/profile'),
            response: Response(
              requestOptions: RequestOptions(path: '/customer/profile'),
              statusCode: 401,
            ),
          ),
        );

        // Mock the refresh token response
        when(
          mockDio.post('/customer/auth/refresh', data: anyNamed('data')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/customer/auth/refresh'),
            statusCode: 200,
            data: {
              'data': {'access_token': newToken, 'refresh_token': refreshToken},
            },
          ),
        );

        // Mock the retry request
        when(
          mockDio.request('/customer/profile', options: anyNamed('options')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/customer/profile'),
            statusCode: 200,
            data: {
              'data': {'id': 1, 'email': 'test@example.com'},
            },
          ),
        );

        await apiService.initialize();

        // Act
        final result = await apiService.getProfile();

        // Assert
        expect(result['success'], isTrue);
        expect(apiService.authToken, equals(newToken));
      });
    });

    group('Error Handling', () {
      test('should handle network errors', () async {
        // Arrange
        when(mockDio.get('/products')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/products'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act
        final result = await apiService.getProducts();

        // Assert
        expect(result['success'], isFalse);
        expect(result['message'], isNotEmpty);
      });

      test('should handle server errors', () async {
        // Arrange
        when(mockDio.get('/products')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/products'),
            response: Response(
              requestOptions: RequestOptions(path: '/products'),
              statusCode: 500,
              data: {'message': 'Internal server error'},
            ),
          ),
        );

        // Act
        final result = await apiService.getProducts();

        // Assert
        expect(result['success'], isFalse);
        expect(result['message'], isNotEmpty);
      });
    });
  });
}
