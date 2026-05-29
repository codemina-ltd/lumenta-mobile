import 'package:dio/dio.dart';

import '../../core/config/env.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/paginated.dart';

class MessagesRepo {
  MessagesRepo(this._dio);
  final Dio _dio;

  /// `GET /messages/conversations` — one row per client with last message.
  ///
  /// NOTE: this backend endpoint is a deferred prerequisite (see plan §1.4).
  /// Until it ships the call will 404; the chats screen surfaces that clearly.
  Future<Paginated<Conversation>> conversations({
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/messages/conversations',
      queryParameters: {'page': page, 'limit': limit},
    );
    return Paginated.fromJson(res.data!, Conversation.fromJson);
  }

  /// `GET /clients/:id/messages` — the message thread for one client.
  Future<Paginated<Message>> thread(
    String clientId, {
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/clients/$clientId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );
    return Paginated.fromJson(res.data!, Message.fromJson);
  }

  /// Authenticated proxy URL for a message's media (`GET /messages/:id/media`).
  /// Pair with [mediaHeaders] for `cached_network_image`/`Image.network`.
  String mediaUrl(String messageId) =>
      '${Env.apiBaseUrl}/messages/$messageId/media';
}
