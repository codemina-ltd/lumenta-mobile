import 'package:dio/dio.dart';

/// Tenant feature switches API client (audit item D6).
class FeaturesRepo {
  FeaturesRepo(this._dio);
  final Dio _dio;

  /// `GET /features` — the effective on/off switch for every feature key
  /// (`{ [featureKey]: boolean }`). Since Phase 6.1 the four channel keys
  /// (`channel_instagram` / `channel_messenger` / `channel_sms` /
  /// `channel_email`) are plan-derived server-side; the client just reads
  /// the booleans.
  Future<Map<String, bool>> getFlags() async {
    final res = await _dio.get<Map<String, dynamic>>('/features');
    return {
      for (final e in (res.data ?? const {}).entries)
        if (e.value is bool) e.key: e.value as bool,
    };
  }
}
