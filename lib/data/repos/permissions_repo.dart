import 'package:dio/dio.dart';

/// The signed-in member's effective portal permissions.
class PermissionsRepo {
  PermissionsRepo(this._dio);
  final Dio _dio;

  /// `GET /me/permissions` — the `permissions` map (`"<module>:<action>"` →
  /// allowed) resolved server-side from the member's role defaults and
  /// per-member overrides. The other fields of the response (CRM
  /// capabilities, team scope) are not used on mobile.
  Future<Map<String, bool>> getMine() async {
    final res = await _dio.get<Map<String, dynamic>>('/me/permissions');
    final raw = res.data?['permissions'];
    if (raw is! Map) return const {};
    return {
      for (final e in raw.entries)
        if (e.key is String && e.value is bool)
          e.key as String: e.value as bool,
    };
  }
}
