// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// One row of the chats list. Maps the planned `GET /v1/messages/conversations`
/// contract (one entry per client with its last message). The backend endpoint
/// is a deferred prerequisite; field names follow the agreed contract.
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    /// Client id (the chat is keyed by client).
    @JsonKey(readValue: _clientId) required String clientId,
    required String phoneNumber,
    String? profileName,
    String? lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
    String? lastMessageAt,
  }) = _Conversation;

  const Conversation._();

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  String get displayName =>
      (profileName != null && profileName!.trim().isNotEmpty)
      ? profileName!
      : '+$phoneNumber';

  DateTime? get lastMessageAtDate =>
      lastMessageAt == null ? null : DateTime.tryParse(lastMessageAt!)?.toLocal();

  String get initials {
    final source = (profileName?.trim().isNotEmpty ?? false)
        ? profileName!.trim()
        : phoneNumber;
    final parts = source.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.elementAt(1).substring(0, 1))
        .toUpperCase();
  }
}

/// Accepts either `clientId` or `id` from the server for the client key.
Object? _clientId(Map json, String key) => json['clientId'] ?? json['id'];
