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
    String? clientId,
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
        'clientId': ?clientId,
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

  /// `PATCH /inbox/threads/:id/priority`.
  Future<InboxThread> changePriority(String id, String priority) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/inbox/threads/$id/priority',
      data: {'priority': priority},
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

  /// `POST /inbox/threads/:id/notes` — internal-only note. `mentions` carries
  /// the tagged teammates as `[{ user_id }]` (mirrors the portal composer); the
  /// server re-validates every id against tenant membership and notifies them.
  Future<InboxNote> addNote(
    String id,
    String body, {
    List<Map<String, dynamic>> mentions = const [],
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/threads/$id/notes',
      data: {'body': body, if (mentions.isNotEmpty) 'mentions': mentions},
    );
    return InboxNote.fromJson(res.data!);
  }

  /// `POST /inbox/message-notes` — internal note anchored to a specific chat
  /// message; the server resolves the inbox thread from the message. Any
  /// member may assign the note to any member via [assignedToUserId].
  Future<InboxNote> addMessageNote(
    String messageId,
    String body, {
    String? assignedToUserId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/inbox/message-notes',
      data: {
        'messageId': messageId,
        'body': body,
        'assignedToUserId': ?assignedToUserId,
      },
    );
    return InboxNote.fromJson(res.data!);
  }

  /// `DELETE /inbox/threads/:id/notes/:noteId` — remove a note (the API only
  /// lets an author delete their own).
  Future<void> deleteNote(String id, String noteId) async {
    await _dio.delete<void>('/inbox/threads/$id/notes/$noteId');
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
