import 'package:dio/dio.dart';

import '../models/inbox_note.dart';
import '../models/inbox_thread.dart';
import '../models/paginated.dart';

/// Team Inbox API client (LUMENTA_GROWTH plan §1.2). The mobile app drives the
/// operate side: list/read threads, assign, change status, label, note.
class InboxRepo {
  InboxRepo(this._dio);
  final Dio _dio;

  /// `GET /inbox/threads` — filterable, paginated thread list.
  Future<Paginated<InboxThread>> threads({
    String? status,
    String? assignedUserId,
    bool? unassigned,
    String? labelId,
    String? senderId,
    String? search,
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/inbox/threads',
      queryParameters: {
        'page': page,
        'limit': limit,
        'status': ?status,
        'assignedUserId': ?assignedUserId,
        if (unassigned == true) 'unassigned': true,
        'labelId': ?labelId,
        'senderId': ?senderId,
        'search': ?search,
      },
    );
    return Paginated.fromJson(res.data!, InboxThread.fromJson);
  }

  /// `GET /inbox/threads/:id` — a single thread with labels + contact.
  Future<InboxThread> thread(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/inbox/threads/$id');
    return InboxThread.fromJson(res.data!);
  }

  /// `POST /inbox/threads/:id/read` — clear the unread badge.
  Future<void> markRead(String id) async {
    await _dio.post<void>('/inbox/threads/$id/read');
  }

  /// `POST /inbox/threads/:id/assign-to-me` — claim for the current user.
  Future<InboxThread> assignToMe(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/threads/$id/assign-to-me',
    );
    return InboxThread.fromJson(res.data!);
  }

  /// `POST /inbox/threads/:id/assign` — assign to a user, or `null` to unassign.
  Future<InboxThread> assign(String id, String? assignedUserId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/threads/$id/assign',
      data: {'assignedUserId': assignedUserId},
    );
    return InboxThread.fromJson(res.data!);
  }

  /// `PATCH /inbox/threads/:id/status`.
  Future<InboxThread> changeStatus(
    String id,
    String status, {
    String? snoozedUntil,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/inbox/threads/$id/status',
      data: {'status': status, 'snoozedUntil': ?snoozedUntil},
    );
    return InboxThread.fromJson(res.data!);
  }

  /// `POST /inbox/threads/:id/labels`.
  Future<InboxThread> applyLabel(String id, String labelId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/threads/$id/labels',
      data: {'labelId': labelId},
    );
    return InboxThread.fromJson(res.data!);
  }

  /// `DELETE /inbox/threads/:id/labels/:labelId`.
  Future<InboxThread> removeLabel(String id, String labelId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/inbox/threads/$id/labels/$labelId',
    );
    return InboxThread.fromJson(res.data!);
  }

  /// `GET /inbox/threads/:id/notes`.
  Future<List<InboxNote>> notes(String id) async {
    final res = await _dio.get<List<dynamic>>('/inbox/threads/$id/notes');
    return (res.data ?? const [])
        .map((e) => InboxNote.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /inbox/threads/:id/notes` — internal-only note.
  Future<InboxNote> addNote(String id, String body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/threads/$id/notes',
      data: {'body': body},
    );
    return InboxNote.fromJson(res.data!);
  }

  /// `GET /inbox/labels` — tenant label definitions.
  Future<List<InboxLabelLite>> labels() async {
    final res = await _dio.get<List<dynamic>>('/inbox/labels');
    return (res.data ?? const [])
        .map((e) => InboxLabelLite.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}

/// Minimal label shape for the label picker (avoids importing the freezed
/// model where only id+name+color are needed).
class InboxLabelLite {
  const InboxLabelLite({
    required this.id,
    required this.name,
    required this.color,
  });
  final String id;
  final String name;
  final String color;

  factory InboxLabelLite.fromMap(Map<String, dynamic> m) => InboxLabelLite(
    id: m['id'] as String,
    name: m['name'] as String,
    color: (m['color'] as String?) ?? '#00C896',
  );
}
