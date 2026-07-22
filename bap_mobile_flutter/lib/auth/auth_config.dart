// lib/auth/auth_config.dart
// ============================================================================
// Auth-layer constants. The base URL is overridable at build time AND it
// adapts to the platform:
//
//   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000
//
// Resolution order for [baseUrl]:
//   1. The `--dart-define=API_BASE_URL=…` value, if non-empty
//   2. Platform default:
//        - Web              → http://localhost:5000
//        - Android emulator → http://10.0.2.2:5000   (host-loopback alias)
//        - Everything else  → http://localhost:5000   (iOS sim / desktop)
//
// Same logic for [adminWebUrl] (port 3000) — used by admin's Content screen.
// ============================================================================

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class AuthConfig {
  /// Default backend host:port for the current platform.
  static String get _defaultApiBase {
    // 1. Web is unambiguous — never use the Android emulator alias.
    if (kIsWeb) return 'http://localhost:5000';

    // 2. Native targets — pick based on the underlying OS. On Android
    //    emulators the host loopback alias is 10.0.2.2; on iOS sim /
    //    macOS / Windows the host loopback is plain localhost. Wrap the
    //    dart:io access in try/catch because some obscure embedded
    //    targets strip the dart:io implementation entirely.
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:5000';
    } catch (_) {
      // dart:io not available — fall through to localhost.
    }
    return 'http://localhost:5000';
  }

  /// Default host:port of the React web admin panel.
  static String get _defaultAdminWeb {
    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    } catch (_) {
      // dart:io not available — fall through to localhost.
    }
    return 'http://localhost:3000';
  }

  /// Backend base URL. Resolved at call-time so it picks up the right
  /// platform default when no `--dart-define` was supplied.
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    return fromEnv.isEmpty ? _defaultApiBase : fromEnv;
  }

  /// React admin web URL. Resolved at call-time.
  static String get adminWebUrl {
    const fromEnv = String.fromEnvironment('ADMIN_WEB_URL');
    return fromEnv.isEmpty ? _defaultAdminWeb : fromEnv;
  }

  // ---------------------------------------------------------------------------
  // Storage keys (compile-time, no platform branching needed).
  // ---------------------------------------------------------------------------

  /// Namespacing for everything stored in `flutter_secure_storage`. Keeping
  /// them in one place makes it easy to wipe on logout or migrate later.
  static const String storageTokenKey = 'bap.auth.token';
  static const String storageUserIdKey = 'bap.auth.userId';
  static const String storageNameKey = 'bap.auth.name';
  static const String storageEmailKey = 'bap.auth.email';
  static const String storageRoleKey = 'bap.auth.role';
  static const String storageMustChangeKey = 'bap.auth.mustChangePassword';

  /// Standard 30s leeway when comparing JWT `exp` to wall-clock time so
  /// we don't bounce users mid-session because of clock skew.
  static const int jwtSkewSeconds = 30;
}
