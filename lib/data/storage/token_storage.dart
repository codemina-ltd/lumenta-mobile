import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists JWTs and the active tenant in the platform Keychain/Keystore.
/// JWTs are NEVER stored in SharedPreferences (D4).
class TokenStorage {
  // flutter_secure_storage 10.x defaults to strong AES-GCM + RSA-OAEP key
  // wrapping on Android (Keystore-backed) and the Keychain on iOS — no extra
  // options needed.
  TokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kTenant = 'active_tenant_id';

  Future<String?> readAccess() => _storage.read(key: _kAccess);
  Future<String?> readRefresh() => _storage.read(key: _kRefresh);
  Future<String?> readTenant() => _storage.read(key: _kTenant);

  Future<void> writeTokens(String access, String refresh) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  Future<void> writeTenant(String tenantId) =>
      _storage.write(key: _kTenant, value: tenantId);

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kTenant);
  }
}
