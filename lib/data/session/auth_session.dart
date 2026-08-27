import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

/// In-memory mirror of the persisted auth state, so HTTP interceptors can read
/// the current access token / tenant synchronously while writes stay durable.
class AuthSession extends ChangeNotifier {
  AuthSession(this._storage);

  final TokenStorage _storage;

  String? _accessToken;
  String? _refreshToken;
  String? _activeTenantId;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get activeTenantId => _activeTenantId;
  bool get isAuthenticated => _accessToken != null;

  /// Load persisted tokens on launch. Returns true if a session was restored.
  Future<bool> hydrate() async {
    _accessToken = await _storage.readAccess();
    _refreshToken = await _storage.readRefresh();
    _activeTenantId = await _storage.readTenant();
    return _accessToken != null;
  }

  Future<void> setTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;
    await _storage.writeTokens(access, refresh);
    notifyListeners();
  }

  Future<void> setActiveTenant(String tenantId) async {
    _activeTenantId = tenantId;
    await _storage.writeTenant(tenantId);
    notifyListeners();
  }

  /// KAN-198 — the API said the user is no longer a member of the active
  /// workspace (403 TENANT_FORBIDDEN, e.g. their membership was disabled).
  /// Drops the selection so the app returns to the picker; tokens stay.
  bool _tenantAccessRevoked = false;
  bool get tenantAccessRevoked => _tenantAccessRevoked;

  Future<void> revokeActiveTenant() async {
    if (_activeTenantId == null) return;
    _activeTenantId = null;
    _tenantAccessRevoked = true;
    await _storage.clearTenant();
    notifyListeners();
  }

  /// Consumed by the auth controller once it has reacted to the revocation.
  void acknowledgeTenantAccessRevoked() {
    _tenantAccessRevoked = false;
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _activeTenantId = null;
    await _storage.clear();
    notifyListeners();
  }
}
