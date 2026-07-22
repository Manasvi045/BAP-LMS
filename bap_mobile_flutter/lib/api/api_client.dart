// lib/api/api_client.dart
// ============================================================================
// Authenticated HTTP client. Every admin/learner API call goes through
// here so we get:
//
//   1. Bearer-token injection from flutter_secure_storage.
//   2. Automatic session-expiry handling:
//        - 401 from the server  → wipe the stored session
//        - broadcast SessionExpiredEvent via SessionEvents
//        - AuthGate listens and routes the user back to LoginScreen
//        - screens show a toast "Your session has expired. Please sign in again."
//   3. A consistent ApiException shape for everything else.
//
// Endpoints that don't need auth (login, register, change-password) are
// NOT routed through here — they go via AuthService which talks to the
// server directly with no bearer header.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/auth_config.dart';
import '../auth/auth_service.dart';
import 'api_exception.dart';

/// Broadcasts session lifecycle changes so the AuthGate (and anyone else
/// that cares) can react without being coupled to AuthService.
class SessionEvents {
  SessionEvents._();

  /// Fired when a 401 came back from the server. AuthService has already
  /// wiped the stored JWT and user fields by the time this fires.
  static final _expired = StreamController<void>.broadcast();
  static Stream<void> get expired => _expired.stream;

  /// Internal — ApiClient calls this on 401.
  static void emitExpired() => _expired.add(null);
}

class ApiClient {
  ApiClient({
    required AuthService authService,
    http.Client? client,
  })  : _auth = authService,
        _client = client ?? http.Client();

  final AuthService _auth;
  final http.Client _client;

  // ---------------------------------------------------------------------------
  // Typed response helpers
  // ---------------------------------------------------------------------------

  Future<dynamic> getJson(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> postJson(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> putJson(String path, {Object? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> patchJson(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<dynamic> deleteJson(String path) => _send('DELETE', path);

  // ---------------------------------------------------------------------------
  // Core
  // ---------------------------------------------------------------------------

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final base = Uri.parse(AuthConfig.baseUrl);
    final uri = base.replace(
      path: path,
      queryParameters: query?.map((k, v) => MapEntry(k, v)),
    );

    final token = await _auth.readToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };

    http.Response res;
    try {
      final encoded = body == null ? null : jsonEncode(body);
      switch (method) {
        case 'GET':
          res = await _client.get(uri, headers: headers);
          break;
        case 'POST':
          res = await _client.post(uri, headers: headers, body: encoded);
          break;
        case 'PUT':
          res = await _client.put(uri, headers: headers, body: encoded);
          break;
        case 'PATCH':
          res = await _client.patch(uri, headers: headers, body: encoded);
          break;
        case 'DELETE':
          res = await _client.delete(uri, headers: headers);
          break;
        default:
          throw ArgumentError('Unsupported method: $method');
      }
    } on TimeoutException {
      throw const ApiException('Server timed out.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }

    // 401 is special — wipe the session and broadcast expiry so the
    // AuthGate routes the user back to LoginScreen.
    if (res.statusCode == 401) {
      await _auth.logout();
      SessionEvents.emitExpired();
      throw ApiException(
        'Your session has expired. Please sign in again.',
        statusCode: 401,
        body: _safeJson(res.body),
      );
    }

    // 204 No Content — return null.
    if (res.statusCode == 204 || res.body.isEmpty) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw ApiException(
          'Request failed (HTTP ${res.statusCode}).',
          statusCode: res.statusCode,
        );
      }
      return null;
    }

    final decoded = _safeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      String msg = 'Request failed (HTTP ${res.statusCode}).';
      final m = decoded?['message'];
      if (m is String) msg = m;
      throw ApiException(msg, statusCode: res.statusCode, body: decoded);
    }

    // Backend wraps payloads as `{ success, data | user | message, ... }`
    // and also returns `{ success:false, message }` on errors. For
    // successful responses we unwrap one layer so screens can read
    // `data` / `user` directly without going through `success`.
    final json = decoded;
    if (json != null) {
      if (json['success'] == false) {
        throw ApiException(
          (json['message'] ?? 'Request failed.').toString(),
          statusCode: res.statusCode,
          body: json,
        );
      }
      if (json.containsKey('data')) return json['data'];
      if (json.containsKey('user') && !json.containsKey('message')) {
        return json['user'];
      }
    }
    return decoded;
  }

  Map<String, dynamic>? _safeJson(String body) {
    try {
      final v = jsonDecode(body);
      if (v is Map<String, dynamic>) return v;
      return null;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}