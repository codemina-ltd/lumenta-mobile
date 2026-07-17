import 'package:dio/dio.dart';

import '../models/paginated.dart';
import '../models/reminder.dart';

class RemindersRepo {
  RemindersRepo(this._dio);
  final Dio _dio;

  /// `GET /reminders` — page-paginated, sorted by due time ascending.
  Future<Paginated<Reminder>> list({
    String? assignedToUserId,
    String? clientId,
    String status = 'pending',
    int page = 1,
    int limit = 50,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/reminders',
      queryParameters: {
        'status': status,
        'assignedToUserId': ?assignedToUserId,
        'clientId': ?clientId,
        'page': page,
        'limit': limit,
      },
    );
    return Paginated.fromJson(res.data!, Reminder.fromJson);
  }

  /// `GET /reminders/summary` → `{ data: { overdue, dueToday, upcoming } }`.
  /// `tz` bounds "today" in the device's timezone.
  Future<ReminderSummary> summary({String? tz}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/reminders/summary',
      queryParameters: {'tz': ?tz},
    );
    return ReminderSummary.fromJson(
      (res.data?['data'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// `POST /reminders/:id/complete`.
  Future<void> complete(String id) =>
      _dio.post<void>('/reminders/$id/complete');

  /// `POST /reminders/:id/snooze` — `until` is an ISO-8601 UTC instant;
  /// presets are computed on-device (plan §0 — the API takes explicit times).
  Future<void> snooze(String id, DateTime until) => _dio.post<void>(
    '/reminders/$id/snooze',
    data: {'until': until.toUtc().toIso8601String()},
  );
}
