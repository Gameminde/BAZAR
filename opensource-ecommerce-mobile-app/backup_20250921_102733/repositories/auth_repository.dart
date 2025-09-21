/*
 * Repository abstrait pour l'authentification
 * Interface commune pour GraphQL et REST
 */

/// Repository abstrait pour l'authentification
abstract class AuthRepository {
  /// Connexion utilisateur
  Future<AuthResult> login(String email, String password);

  /// Inscription utilisateur
  Future<AuthResult> register(Map<String, dynamic> userData);

  /// Déconnexion utilisateur
  Future<AuthResult> logout();

  /// Obtenir le profil utilisateur
  Future<AuthResult> getProfile();

  /// Rafraîchir le token d'authentification
  Future<AuthResult> refreshToken(String refreshToken);

  /// Vérifier si l'utilisateur est connecté
  bool get isAuthenticated;

  /// Obtenir le token d'authentification actuel
  String? get authToken;
}

/// Résultat d'une opération d'authentification
class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final String? errorCode;

  const AuthResult({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
  });

  factory AuthResult.success({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return AuthResult(success: true, message: message, data: data);
  }

  factory AuthResult.error({required String message, String? errorCode}) {
    return AuthResult(success: false, message: message, errorCode: errorCode);
  }
}
