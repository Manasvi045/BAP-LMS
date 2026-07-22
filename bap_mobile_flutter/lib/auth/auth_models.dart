// lib/auth/auth_models.dart
// ============================================================================
// Value types used across the auth layer. Kept in their own file so
// widgets don't have to import the service just to talk about users.
// ============================================================================

/// Canonical user identity returned by the backend after login.
///
/// Backend response shape (relevant subset):
/// ```json
/// {
///   "user": {
///     "id": 1,
///     "full_name": "John Doe",
///     "email": "john@example.com",
///     "role": "user"
///   },
///   "mustChangePassword": false
/// }
/// ```
class AuthUser {
  final int id;
  final String name;
  final String email;
  final String role; // "admin" | "editor" | "user"

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isLearner => role == 'user';
  bool get isAdminOrEditor => role == 'admin' || role == 'editor';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return AuthUser(
      id: id is int ? id : int.tryParse('${id ?? ''}') ?? 0,
      name: (json['full_name'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'user').toString(),
    );
  }
}

/// What `loadSession()` returns when there's a valid persisted login.
class AuthSession {
  final String token;
  final AuthUser user;
  final bool mustChangePassword;

  const AuthSession({
    required this.token,
    required this.user,
    required this.mustChangePassword,
  });
}

/// Thrown by AuthService when the backend rejects a request or the
/// network is unreachable. Carries the server's message verbatim so the
/// UI can render it without a translation layer.
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException(this.message, {this.statusCode});

  @override
  String toString() => 'AuthException(${statusCode ?? '-'}): $message';
}