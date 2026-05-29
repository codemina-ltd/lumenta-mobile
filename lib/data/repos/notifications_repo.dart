import 'package:dio/dio.dart';

import '../models/notification.dart';
import '../models/paginated.dart';

class NotificationsRepo {
  NotificationsRepo(this._dio);
  final Dio _dio;

  /// `GET /notifications` — cursor-paginated in-app feed.
  Future<CursorPage<AppNotification>> list({
    String? cursor,
    bool unreadOnly = false,
    int limit = 25,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/notifications',
      queryParameters: {
        'cursor': ?cursor,
        if (unreadOnly) 'unread': 'true',
        'limit': limit,
      },
    );
    return CursorPage.fromJson(res.data!, AppNotification.fromJson);
  }

  /// `GET /notifications/unread-count` → `{ count }`.
  Future<int> unreadCount() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/notifications/unread-count',
    );
    return (res.data?['count'] as num?)?.toInt() ?? 0;
  }

  /// `PATCH /notifications/:id/read`.
  Future<void> markRead(String id) =>
      _dio.patch<void>('/notifications/$id/read');

  /// `POST /notifications/mark-all-read`.
  Future<void> markAllRead() =>
      _dio.post<void>('/notifications/mark-all-read');
}
