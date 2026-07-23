import 'package:dio/dio.dart';

import '../models/paginated.dart';
import '../models/scheduled_message.dart';

/// `/v1/contacts/:clientId/scheduled-messages…` — schedule a one-off
/// template send to a single client from the chat thread. Nested under the
/// Contacts controller on the API; mirrors `reminders_repo.dart`'s shape.
class ScheduledMessagesRepo {
  ScheduledMessagesRepo(this._dio);
  final Dio _dio;

  /// `GET /contacts/:clientId/scheduled-messages`. Omit [status] for every
  /// status (Client Profile card); pass e.g. `'pending,failed'` for the
  /// thread's inline feed.
  Future<Paginated<ScheduledMessage>> list(
    String clientId, {
    String? status,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortDir,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages',
      queryParameters: {
        'status': ?status,
        'page': page,
        'limit': limit,
        'sortBy': ?sortBy,
        'sortDir': ?sortDir,
      },
    );
    // This endpoint returns a FLAT envelope (`{ data, total, page, limit,
    // totalPages }`), unlike the `{ data, meta: {...} }` shape
    // `Paginated.fromJson` expects (clients/messages) — parse it directly
    // rather than silently defaulting total/page/totalPages to 1.
    final json = res.data!;
    final items = (json['data'] as List<dynamic>? ?? const [])
        .map((e) => ScheduledMessage.fromJson(e as Map<String, dynamic>))
        .toList();
    return Paginated<ScheduledMessage>(
      data: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  /// `GET /contacts/:clientId/scheduled-messages/:id` — the message plus its
  /// lifecycle events (newest first), for a "View" activity screen.
  Future<ScheduledMessageDetail> get(String clientId, String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages/$id',
    );
    return ScheduledMessageDetail.fromJson(res.data!);
  }

  /// `POST /contacts/:clientId/scheduled-messages`. [scheduledFor] must be
  /// in the future; sent as a UTC ISO-8601 instant.
  Future<ScheduledMessage> create(
    String clientId, {
    required String senderId,
    required String templateId,
    Map<String, String>? templateVariables,
    Map<String, String>? buttonVariables,
    required DateTime scheduledFor,
    String? timezone,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages',
      data: {
        'senderId': senderId,
        'templateId': templateId,
        if (templateVariables != null && templateVariables.isNotEmpty)
          'templateVariables': templateVariables,
        if (buttonVariables != null && buttonVariables.isNotEmpty)
          'buttonVariables': buttonVariables,
        'scheduledFor': scheduledFor.toUtc().toIso8601String(),
        'timezone': ?timezone,
      },
    );
    return ScheduledMessage.fromJson(res.data!);
  }

  /// `PATCH /contacts/:clientId/scheduled-messages/:id` — only while still
  /// `pending`; the server mutates the row in place and reschedules.
  Future<ScheduledMessage> update(
    String clientId,
    String id, {
    Map<String, String>? templateVariables,
    Map<String, String>? buttonVariables,
    DateTime? scheduledFor,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages/$id',
      data: {
        if (templateVariables != null && templateVariables.isNotEmpty)
          'templateVariables': templateVariables,
        if (buttonVariables != null && buttonVariables.isNotEmpty)
          'buttonVariables': buttonVariables,
        'scheduledFor': ?scheduledFor?.toUtc().toIso8601String(),
      },
    );
    return ScheduledMessage.fromJson(res.data!);
  }

  /// `POST .../:id/cancel` — only while `pending`; never deletes the row.
  Future<ScheduledMessage> cancel(
    String clientId,
    String id, {
    String? reason,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages/$id/cancel',
      data: {'reason': ?reason},
    );
    return ScheduledMessage.fromJson(res.data!);
  }

  /// `POST .../:id/retry` — only while `failed`. Omit [scheduledFor] to
  /// resend immediately; pass one to reschedule instead.
  Future<ScheduledMessage> retry(
    String clientId,
    String id, {
    DateTime? scheduledFor,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/contacts/$clientId/scheduled-messages/$id/retry',
      data: {'scheduledFor': ?scheduledFor?.toUtc().toIso8601String()},
    );
    return ScheduledMessage.fromJson(res.data!);
  }
}

/// `GET .../:id` response — the message bundled with its append-only
/// lifecycle log. Lightweight (no codegen) like `contacts_repo.dart`'s
/// `CtwaReferral`.
class ScheduledMessageDetail {
  const ScheduledMessageDetail({required this.message, required this.events});

  final ScheduledMessage message;
  final List<ScheduledMessageEvent> events;

  factory ScheduledMessageDetail.fromJson(Map<String, dynamic> json) {
    final events = (json['events'] as List<dynamic>? ?? const [])
        .map((e) => ScheduledMessageEvent.fromJson(e as Map<String, dynamic>))
        .toList();
    return ScheduledMessageDetail(
      message: ScheduledMessage.fromJson(json),
      events: events,
    );
  }
}
