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

    /// Null for channel-only contacts (Instagram/Messenger) that have no
    /// WhatsApp phone number.
    String? phoneNumber,

    /// Channel-owned WhatsApp profile name (KAN-301: never workspace-edited).
    String? profileName,

    /// KAN-301 — this workspace's own name for the client (JSON `displayName`).
    @JsonKey(name: 'displayName') String? workspaceName,

    /// KAN-301 — effective name from the API ([workspaceName] else
    /// [profileName]); null on servers predating the field.
    String? name,
    String? lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,

    /// Channel the last message travelled on ('whatsapp' | 'instagram' |
    /// 'messenger'). The API defaults it to 'whatsapp', so only non-WhatsApp
    /// values are worth surfacing; null on servers predating the field.
    String? lastMessageChannelType,
    String? lastMessageAt,

    /// Delivery status of the last message (outbound: sent / delivered /
    /// read / failed). Null on servers predating the field.
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    MessageStatus? lastMessageStatus,

    /// Inbound messages newer than this member's server-side read cursor.
    /// Null on servers predating the field (the app then falls back to the
    /// on-device cursor).
    int? unreadCount,

    /// When this member pinned the chat (server-side, follows the member
    /// across devices); null when not pinned.
    String? pinnedAt,
  }) = _Conversation;

  const Conversation._();

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  /// Effective name (KAN-301): workspace name, else WhatsApp name, else null.
  String? get effectiveName =>
      _nonBlank(name) ?? _nonBlank(workspaceName) ?? _nonBlank(profileName);

  String get displayName {
    final effective = effectiveName;
    if (effective != null) return effective;
    final phone = phoneNumber;
    return phone != null ? '+$phone' : 'Unknown contact';
  }

  DateTime? get lastMessageAtDate => lastMessageAt == null
      ? null
      : DateTime.tryParse(lastMessageAt!)?.toLocal();

  bool get isPinned => pinnedAt != null;

  DateTime? get pinnedAtDate =>
      pinnedAt == null ? null : DateTime.tryParse(pinnedAt!);

  String get initials {
    final source = effectiveName ?? (phoneNumber ?? '');
    // Skip symbol-only words (the dash in "Ahmed — VIP") so initials come
    // from real name parts.
    final parts = source
        .split(RegExp(r'\s+'))
        .where((p) => RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(p));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.elementAt(1).substring(0, 1))
        .toUpperCase();
  }

  static String? _nonBlank(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}

/// Accepts either `clientId` or `id` from the server for the client key.
Object? _clientId(Map json, String key) => json['clientId'] ?? json['id'];
