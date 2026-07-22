// lib/api/api_exception.dart
// ============================================================================
// Thrown by ApiClient for any non-2xx response or transport error. The
// status code is preserved so callers can branch on 401 (session-expired)
// vs 403 (forbidden) vs 4xx (validation) etc.
// ============================================================================

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? body;

  const ApiException(this.message, {this.statusCode, this.body});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNetwork => statusCode == null;

  @override
  String toString() =>
      'ApiException(${statusCode ?? '-'}): $message';
}