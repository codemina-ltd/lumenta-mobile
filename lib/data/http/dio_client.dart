import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/config/env.dart';
import '../session/auth_session.dart';

/// Signals that the session is unrecoverable (refresh failed) so the app can
/// route back to login.
typedef OnSessionExpired = void Function();

/// Builds the app's [Dio] with auth, tenant, and single-flight refresh
/// interceptors. The tenant header name and refresh flow mirror the web portal
/// (`X-Tenant-Id`, `POST /auth/refresh`).
Dio buildDio(AuthSession session, {OnSessionExpired? onSessionExpired}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(
    _AuthRefreshInterceptor(
      session: session,
      dio: dio,
      onSessionExpired: onSessionExpired,
    ),
  );
  return dio;
}

class _AuthRefreshInterceptor extends Interceptor {
  _AuthRefreshInterceptor({
    required this.session,
    required this.dio,
    this.onSessionExpired,
  });

  final AuthSession session;
  final Dio dio;
  final OnSessionExpired? onSessionExpired;

  /// Single-flight: concurrent 401s share one refresh attempt.
  Future<String?>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = session.accessToken;
    if (token != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final tenant = session.activeTenantId;
    if (tenant != null) {
      options.headers['X-Tenant-Id'] = tenant;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    // KAN-198 — a 403 TENANT_FORBIDDEN on a request that carried the active
    // tenant header means this user can no longer act in that workspace
    // (membership disabled / removed). Drop the selection so the app falls
    // back to the workspace picker instead of showing errors on every tab.
    if (response?.statusCode == 403 && _isTenantForbidden(response)) {
      final sentTenant = err.requestOptions.headers['X-Tenant-Id'];
      if (sentTenant != null && sentTenant == session.activeTenantId) {
        unawaited(session.revokeActiveTenant());
      }
      return handler.next(err);
    }

    final isAuthFailure = response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains('/auth/refresh');
    final alreadyRetried = err.requestOptions.extra['__retried'] == true;

    if (!isAuthFailure ||
        isRefreshCall ||
        alreadyRetried ||
        session.refreshToken == null) {
      return handler.next(err);
    }

    try {
      final newAccess = await _refreshOnce();
      if (newAccess == null) {
        return handler.next(err);
      }
      // Replay the original request with the fresh token.
      final opts = err.requestOptions;
      opts.extra['__retried'] = true;
      opts.headers['Authorization'] = 'Bearer $newAccess';
      final clone = await dio.fetch<dynamic>(opts);
      return handler.resolve(clone);
    } catch (_) {
      return handler.next(err);
    }
  }

  static bool _isTenantForbidden(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map) {
      return data['errorCode'] == 'TENANT_FORBIDDEN';
    }
    return false;
  }

  Future<String?> _refreshOnce() {
    return _refreshing ??= _doRefresh().whenComplete(() {
      _refreshing = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refresh = session.refreshToken;
    if (refresh == null) return null;
    try {
      // Bare Dio (no interceptors) to avoid recursion.
      final raw = Dio(
        BaseOptions(
          baseUrl: Env.apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      final res = await raw.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refresh},
      );
      final data = res.data ?? const {};
      final access = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;
      if (access == null || newRefresh == null) {
        await _expire();
        return null;
      }
      await session.setTokens(access, newRefresh);
      return access;
    } on DioException catch (e) {
      // Only a definitive rejection from the server means the session is
      // dead. Transient failures — offline at cold start, timeouts, 5xx —
      // must keep the tokens so the next attempt can retry; clearing here
      // used to sign users out whenever the first refresh raced a flaky
      // network.
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _expire();
      }
      return null;
    }
  }

  Future<void> _expire() async {
    await session.clear();
    onSessionExpired?.call();
  }
}
