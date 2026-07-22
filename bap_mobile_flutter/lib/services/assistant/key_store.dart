// lib/services/assistant/key_store.dart — BYOK storage for the OpenRouter API key.
// 1:1 port of src/lib/assistant/keyStore.ts. Uses shared_preferences in place
// of @capacitor/preferences.

import 'package:shared_preferences/shared_preferences.dart';

const String _keyName = 'bap.openrouter_key';

abstract class KeyStore {
  Future<String?> get();
  Future<void> set(String key);
  Future<void> clear();
  Future<bool> has();
}

class SharedPrefsKeyStore implements KeyStore {
  const SharedPrefsKeyStore();

  @override
  Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyName);
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Future<void> set(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, trimmed);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
  }

  @override
  Future<bool> has() async => (await get()) != null;
}

/// Default singleton — matches React's `keyStore` export.
final KeyStore keyStore = const SharedPrefsKeyStore();