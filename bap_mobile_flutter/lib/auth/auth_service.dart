// lib/auth/auth_service.dart
// ============================================================================
// Auth-layer service. Talks to the backend's auth endpoints and persists
// the session into `flutter_secure_storage`. Stateless (no Riverpod
// provider) so the gate widget can drive it directly with `setState`.
//
// Backend contract:
//   POST /api/auth/login           → { success, token, mustChangePassword, user }
//   POST /api/auth/change-password → { success, message }
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'auth_config.dart';
import 'auth_models.dart';

class AuthService {
  AuthService({FlutterSecureStorage? storage, http.Client? client})
      : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client();

  final FlutterSecureStorage _storage;
  final http.Client _client;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Authenticate against the backend. On success, persists the session
  /// and returns it. Throws [AuthException] with the server's message on
  /// failure (network errors included).
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({'email': email, 'password': password});
    final res = await _post('/api/auth/login', body);

    final token = res['token'] as String?;
    if (token == null || token.isEmpty) {
      throw const AuthException('Server returned no token.');
    }

    final userJson = res['user'];
    if (userJson is! Map<String, dynamic>) {
      throw const AuthException('Server returned no user payload.');
    }
    final user = AuthUser.fromJson(userJson);
    final mustChange = res['mustChangePassword'] == true;

    await _persistSession(
      token: token,
      user: user,
      mustChangePassword: mustChange,
    );

    return AuthSession(
      token: token,
      user: user,
      mustChangePassword: mustChange,
    );
  }

  /// Self-service password change. Server verifies the current password
  /// and writes the new hash, clearing `must_change_password`.
  ///
  /// This endpoint is protected — it derives the user id from the JWT,
  /// so we must attach the bearer token. If we don't have one stored
  /// the caller can't be authenticated and we fail fast with a clear
  /// message instead of letting the server return a generic 401.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await _storage.read(key: AuthConfig.storageTokenKey);
    if (token == null || token.isEmpty) {
      throw const AuthException('You are not signed in.');
    }
    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });
    await _post('/api/auth/change-password', body, token: token);
    // The flag is cleared server-side; flip our local copy so the gate
    // routes the user straight into the app on the next frame.
    await _storage.write(
      key: AuthConfig.storageMustChangeKey,
      value: 'false',
    );
  }

  /// Read whatever's stored on disk. Returns `null` if nothing is
  /// persisted, the JWT is missing required fields, or the token is
  /// already past its `exp` window.
  Future<AuthSession?> loadSession() async {
    final token = await _storage.read(key: AuthConfig.storageTokenKey);
    if (token == null || token.isEmpty) return null;

    final idStr = await _storage.read(key: AuthConfig.storageUserIdKey);
    final name = await _storage.read(key: AuthConfig.storageNameKey);
    final email = await _storage.read(key: AuthConfig.storageEmailKey);
    final role = await _storage.read(key: AuthConfig.storageRoleKey);
    final mustChangeStr =
        await _storage.read(key: AuthConfig.storageMustChangeKey);

    if (idStr == null || name == null || role == null) {
      // Incomplete persisted state → force a clean re-login.
      await logout();
      return null;
    }

    if (isJwtExpired(token)) {
      await logout();
      return null;
    }

    return AuthSession(
      token: token,
      user: AuthUser(
        id: int.tryParse(idStr) ?? 0,
        name: name,
        email: email ?? '',
        role: role,
      ),
      mustChangePassword: mustChangeStr == 'true',
    );
  }

  /// Wipe everything auth-related from secure storage.
  Future<void> logout() async {
    await _storage.delete(key: AuthConfig.storageTokenKey);
    await _storage.delete(key: AuthConfig.storageUserIdKey);
    await _storage.delete(key: AuthConfig.storageNameKey);
    await _storage.delete(key: AuthConfig.storageEmailKey);
    await _storage.delete(key: AuthConfig.storageRoleKey);
    await _storage.delete(key: AuthConfig.storageMustChangeKey);
  }

  /// Read the persisted JWT directly (used by other services that need
  /// to attach `Authorization: Bearer …` to their own calls).
  Future<String?> readToken() =>
      _storage.read(key: AuthConfig.storageTokenKey);

  /// Returns true if the JWT's `exp` claim is in the past (with skew).
  /// No signature verification — the backend validates every call.
  bool isJwtExpired(String token, {int skewSeconds = AuthConfig.jwtSkewSeconds}) {
    final decoded = _decodeJwtPayload(token);
    final exp = decoded?['exp'];
    if (exp is! int) return true;
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return exp <= nowSec - skewSeconds;
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<void> _persistSession({
    required String token,
    required AuthUser user,
    required bool mustChangePassword,
  }) async {
    await _storage.write(key: AuthConfig.storageTokenKey, value: token);
    await _storage.write(
      key: AuthConfig.storageUserIdKey,
      value: user.id.toString(),
    );
    await _storage.write(
      key: AuthConfig.storageNameKey,
      value: user.name,
    );
    await _storage.write(
      key: AuthConfig.storageEmailKey,
      value: user.email,
    );
    await _storage.write(key: AuthConfig.storageRoleKey, value: user.role);
    await _storage.write(
      key: AuthConfig.storageMustChangeKey,
      value: mustChangePassword.toString(),
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    String body, {
    String? token,
  }) async {
    final uri = Uri.parse('${AuthConfig.baseUrl}$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
    http.Response res;
    try {
      res = await _client.post(uri, headers: headers, body: body);
    } on TimeoutException {
      throw const AuthException('Server timed out.');
    } catch (e) {
      throw AuthException('Network error: $e');
    }

    Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw AuthException(
        'Unexpected server response (HTTP ${res.statusCode}).',
        statusCode: res.statusCode,
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300 || parsed['success'] == false) {
      final msg = (parsed['message'] ?? 'Request failed.').toString();
      throw AuthException(msg, statusCode: res.statusCode);
    }
    return parsed;
  }

  /// Decode a JWT payload (the middle dot-separated segment). No
  /// signature verification — server validates that on every call.
  Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = jsonDecode(utf8.decode(base64Decode(payload)));
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}