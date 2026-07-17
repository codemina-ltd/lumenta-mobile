import 'package:dio/dio.dart';

import '../../core/config/env.dart';
import '../models/conversation.dart';
import '../models/conversation_sender.dart';
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
  /// [senderId] filters to messages carried by that sender (per-sender thread
  /// tabs); omit it for the full merged thread.
  Future<Paginated<Message>> thread(
    String clientId, {
    int page = 1,
    int limit = 30,
    String? senderId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/clients/$clientId/messages',
      queryParameters: {'page': page, 'limit': limit, 'senderId': ?senderId},
    );
    return Paginated.fromJson(res.data!, Message.fromJson);
  }

  /// `GET /clients/:id/messages/:messageId/page` — the 1-based page (newest
  /// first, same ordering and [limit] as [thread]) containing that message.
  /// 404s when the message is unknown to this client.
  Future<int> messagePage(
    String clientId,
    String messageId, {
    int limit = 30,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/clients/$clientId/messages/$messageId/page',
      queryParameters: {'limit': limit},
    );
    return (res.data?['page'] as num?)?.toInt() ?? 1;
  }

  /// `GET /clients/:id/conversation-senders` — which senders have message
  /// history with this client (one row each, most recent first). Backs the
  /// per-sender thread tabs.
  Future<List<ConversationSender>> conversationSenders(String clientId) async {
    final res = await _dio.get<List<dynamic>>(
      '/clients/$clientId/conversation-senders',
    );
    return (res.data ?? const [])
        .map((e) => ConversationSender.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Authenticated proxy URL for a message's media (`GET /messages/:id/media`).
  /// Pair with [mediaHeaders] for `cached_network_image`/`Image.network`.
  String mediaUrl(String messageId) =>
      '${Env.apiBaseUrl}/messages/$messageId/media';

  /// `POST /messages/send` — free-form text reply (24h service window).
  /// [senderId] routes the reply via that sender; omitted, the server falls
  /// back to the tenant default sender.
  Future<Message> sendText({
    required String to,
    required String body,
    String? senderId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/messages/send',
      data: {'to': to, 'body': body, 'senderId': ?senderId},
    );
    return Message.fromJson(res.data!);
  }

  /// `POST /messages/templates` — send an approved template by internal id.
  ///
  /// Mirrors the portal's `sendTemplateMessage`: `templateVariables` keys are
  /// positional (`"1"/"2"`) or named; `buttonVariables` is present only for
  /// COPY_CODE templates; `language` is omitted (resolved server-side from the
  /// template row). Works regardless of the 24h service window.
  Future<Message> sendTemplate({
    required String to,
    required String templateId,
    Map<String, String>? templateVariables,
    Map<String, String>? buttonVariables,
    String? senderId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/messages/templates',
      data: {
        'to': to,
        'templateId': templateId,
        'senderId': ?senderId,
        if (templateVariables != null && templateVariables.isNotEmpty)
          'templateVariables': templateVariables,
        if (buttonVariables != null && buttonVariables.isNotEmpty)
          'buttonVariables': buttonVariables,
      },
    );
    return Message.fromJson(res.data!);
  }

  /// `POST /messages/:id/reaction` — react to an inbound client message with
  /// an emoji; null/empty removes an existing reaction. Returns the updated
  /// message (with `reaction` set server-side).
  Future<Message> sendReaction({
    required String messageId,
    String? emoji,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/messages/$messageId/reaction',
      data: {'emoji': emoji ?? ''},
    );
    return Message.fromJson(res.data!);
  }

  /// `DELETE /messages/:id?scope=me|everyone` — delete a message.
  /// `me` hides it from this user only; `everyone` tombstones it for the
  /// whole workspace (outbound messages only). Returns the updated message.
  Future<Message> deleteMessage({
    required String messageId,
    required String scope,
  }) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/messages/$messageId',
      queryParameters: {'scope': scope},
    );
    return Message.fromJson(res.data!);
  }

  /// `POST /messages/send-media` — multipart media reply.
  Future<Message> sendMedia({
    required String to,
    required String mediaType, // image | audio | video | document
    required String filePath,
    String? caption,
    String? filename,
    String? senderId,
  }) async {
    final form = FormData.fromMap({
      'to': to,
      'mediaType': mediaType,
      'caption': ?caption,
      'filename': ?filename,
      'senderId': ?senderId,
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      '/messages/send-media',
      data: form,
    );
    return Message.fromJson(res.data!);
  }
}
