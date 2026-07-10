import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/tenant.dart';
import '../../data/models/user.dart';
import 'recaptcha_service.dart';

enum AuthStatus { bootstrapping, unauthenticated, needsTenant, authenticated }

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.bootstrapping,
    this.user,
    this.tenants = const [],
    this.activeTenantId,
    this.error,
    this.busy = false,
  });

  final AuthStatus status;
  final User? user;
  final List<TenantSummary> tenants;
  final String? activeTenantId;
  final Object? error;
  final bool busy;

  TenantSummary? get activeTenant {
    for (final t in tenants) {
      if (t.id == activeTenantId) return t;
    }
    return null;
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    List<TenantSummary>? tenants,
    String? activeTenantId,
    Object? error,
    bool clearError = false,
    bool? busy,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      tenants: tenants ?? this.tenants,
      activeTenantId: activeTenantId ?? this.activeTenantId,
      error: clearError ? null : (error ?? this.error),
      busy: busy ?? this.busy,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState()) {
    // React to a refresh failure (session cleared by the Dio interceptor).
    _session.addListener(_onSessionChanged);
  }

  final Ref _ref;

  late final _session = _ref.read(authSessionProvider);

  void _onSessionChanged() {
    if (!_session.isAuthenticated &&
        state.status == AuthStatus.authenticated) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Called from `main()` on launch.
  Future<void> bootstrap() async {
    final restored = await _session.hydrate();
    if (!restored) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      await _loadProfileAndTenants(preferredTenantId: _session.activeTenantId);
    } on DioException {
      // If the interceptor cleared the session, the refresh token was
      // definitively rejected by the server — really logged out.
      if (!_session.isAuthenticated) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return;
      }
      // Transient failure (offline at cold start, timeout, 5xx): keep the
      // session. With a tenant already selected, enter the app — feature
      // screens have their own error/retry states and the profile reloads
      // on the next successful bootstrap. Wiping tokens here used to sign
      // users out every time launch raced a flaky network.
      final tenant = _session.activeTenantId;
      if (tenant != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          activeTenantId: tenant,
        );
      } else {
        // No tenant chosen yet and no network to list tenants — nothing
        // usable to show; fall back to login but keep it rare-path only.
        await _session.clear();
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      final recaptcha = _ref.read(recaptchaServiceProvider);
      final token = await recaptcha.tokenForLogin();
      final result = await _ref.read(authRepoProvider).login(
            email: email,
            password: password,
            recaptchaToken: token,
            recaptchaPlatform:
                defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
          );
      await _session.setTokens(result.accessToken, result.refreshToken);
      await _loadProfileAndTenants(preferredTenantId: _session.activeTenantId);
    } on RecaptchaUnavailable catch (e) {
      state = state.copyWith(busy: false, error: e);
    } catch (e) {
      state = state.copyWith(busy: false, error: e);
    }
  }

  Future<void> _loadProfileAndTenants({String? preferredTenantId}) async {
    final user = await _ref.read(authRepoProvider).me();
    final tenants = await _ref.read(tenantRepoProvider).listMine();

    String? active = preferredTenantId;
    final hasPreferred = tenants.any((t) => t.id == active);
    if (!hasPreferred) active = null;
    if (active == null && tenants.length == 1) {
      active = tenants.first.id;
    }

    if (active != null) {
      await _session.setActiveTenant(active);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        tenants: tenants,
        activeTenantId: active,
      );
    } else {
      state = AuthState(
        status: AuthStatus.needsTenant,
        user: user,
        tenants: tenants,
      );
    }
  }

  Future<void> selectTenant(String tenantId) async {
    await _session.setActiveTenant(tenantId);
    state = state.copyWith(
      status: AuthStatus.authenticated,
      activeTenantId: tenantId,
    );
  }

  Future<void> logout() async {
    // Best-effort server-side cleanup; local clear always happens. Sending
    // the refresh token revokes only this device's session server-side,
    // leaving the portal / other devices signed in.
    final refreshToken = _session.refreshToken;
    try {
      await _ref.read(authRepoProvider).logout(refreshToken: refreshToken);
    } catch (_) {}
    await _session.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  @override
  void dispose() {
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

/// Active locale, hydrated from the user profile after login (mirrors the
/// portal's `useHydrateLocaleFromMe`). Null = follow system locale.
final localeProvider = StateProvider<Locale?>((ref) {
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  final code = user?.locale;
  if (code == null || code.isEmpty) return null;
  return Locale(code.split('-').first);
});
