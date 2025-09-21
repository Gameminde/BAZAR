/*
 * Implémentation REST du repository d'authentification
 * Utilise BagistoApiService
 */

import '../auth_repository.dart';
import '../../services/bazar_api_service.dart';
import '../../config/app_config.dart';

/// Implémentation REST du repository d'authentification
class RestAuthRepository implements AuthRepository {
  final BazarApiService _apiService;

  RestAuthRepository(this._apiService);

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final result = await _apiService.login(email, password);

      if (result['success'] == true) {
        return AuthResult.success(
          message:
              result['message'] ?? AppConfig.getSuccessMessage('login_success'),
          data: result['data'],
        );
      } else {
        return AuthResult.error(
          message: result['message'] ?? AppConfig.getErrorMessage('auth_error'),
          errorCode: 'LOGIN_FAILED',
        );
      }
    } catch (e) {
      return AuthResult.error(
        message: AppConfig.getErrorMessage('network_error'),
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  @override
  Future<AuthResult> register(Map<String, dynamic> userData) async {
    try {
      final result = await _apiService.register(userData);

      if (result['success'] == true) {
        return AuthResult.success(
          message:
              result['message'] ??
              AppConfig.getSuccessMessage('register_success'),
          data: result['data'],
        );
      } else {
        return AuthResult.error(
          message:
              result['message'] ??
              AppConfig.getErrorMessage('validation_error'),
          errorCode: 'REGISTRATION_FAILED',
        );
      }
    } catch (e) {
      return AuthResult.error(
        message: AppConfig.getErrorMessage('network_error'),
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  @override
  Future<AuthResult> logout() async {
    try {
      final result = await _apiService.logout();

      if (result['success'] == true) {
        return AuthResult.success(
          message: result['message'] ?? 'Déconnexion réussie',
        );
      } else {
        return AuthResult.error(
          message:
              result['message'] ?? AppConfig.getErrorMessage('server_error'),
          errorCode: 'LOGOUT_FAILED',
        );
      }
    } catch (e) {
      return AuthResult.error(
        message: AppConfig.getErrorMessage('network_error'),
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  @override
  Future<AuthResult> getProfile() async {
    try {
      final result = await _apiService.getProfile();

      if (result['success'] == true) {
        return AuthResult.success(
          message: 'Profil récupéré avec succès',
          data: result['data'],
        );
      } else {
        return AuthResult.error(
          message: result['message'] ?? AppConfig.getErrorMessage('auth_error'),
          errorCode: 'PROFILE_FETCH_FAILED',
        );
      }
    } catch (e) {
      return AuthResult.error(
        message: AppConfig.getErrorMessage('network_error'),
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    try {
      // Cette méthode sera implémentée dans BagistoApiService
      // Pour l'instant, on retourne une erreur
      return AuthResult.error(
        message: 'Refresh token non implémenté',
        errorCode: 'NOT_IMPLEMENTED',
      );
    } catch (e) {
      return AuthResult.error(
        message: AppConfig.getErrorMessage('network_error'),
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  @override
  bool get isAuthenticated => _apiService.isAuthenticated;

  @override
  String? get authToken => _apiService.authToken;
}
