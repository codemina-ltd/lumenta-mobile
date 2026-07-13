// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';
import 'sender.dart';

part 'conversation_sender.freezed.dart';
part 'conversation_sender.g.dart';

/// One sender (WABA phone number) that has message history with a client,
/// from `GET /v1/clients/:id/conversation-senders` — one row per sender,
/// ordered by most recent activity. Backs the per-sender thread tabs.
@freezed
abstract class ConversationSender with _$ConversationSender {
  const factory ConversationSender({
    required String senderId,
    String? displayName,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending)
    @Default(SenderStatus.pending)
    SenderStatus senderStatus,
    @Default(false) bool isDefault,
    @Default(0) int messageCount,
    String? lastMessageAt,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
  }) = _ConversationSender;

  const ConversationSender._();

  factory ConversationSender.fromJson(Map<String, dynamic> json) =>
      _$ConversationSenderFromJson(json);

  bool get isActive => senderStatus == SenderStatus.active;

  /// Tab label: display name, falling back to the phone number.
  String get label => (displayName?.trim().isNotEmpty ?? false)
      ? displayName!
      : (displayPhoneNumber ?? senderId);
}
