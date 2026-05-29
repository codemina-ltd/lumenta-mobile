import 'package:dio/dio.dart';

class DeviceRepo {
  DeviceRepo(this._dio);
  final Dio _dio;

  /// `POST /notifications/channels/fcm/register` — upserts + auto-verifies the
  /// FCM token for (tenant, user). `label` records platform + app version.
  Future<void> register({
    required String deviceToken,
    required String platform, // 'ios' | 'android'
    String? label,
  }) {
    return _dio.post<void>(
      '/notifications/channels/fcm/register',
      data: {
        'deviceToken': deviceToken,
        'platform': platform,
        'label': ?label,
      },
    );
  }

  /// `DELETE /notifications/channels/fcm?deviceToken=` — used on logout/rotation.
  Future<void> deregister(String deviceToken) {
    return _dio.delete<void>(
      '/notifications/channels/fcm',
      queryParameters: {'deviceToken': deviceToken},
    );
  }
}
