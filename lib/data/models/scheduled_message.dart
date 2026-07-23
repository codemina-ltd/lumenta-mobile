// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheduled_message.freezed.dart';
part 'scheduled_message.g.dart';

enum ScheduledMessageStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('sent')
  sent,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('failed')
  failed,
}

enum ScheduledMessageEventType {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('edited')
  edited,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('sent')
  sent,
  @JsonValue('failed')
  failed,
}

/// A one-off template send scheduled for a single client from the chat
/// thread, from `GET/POST /v1/contacts/:clientId/scheduled-messages`.
///
/// Deliberately NOT a variant of [Message] (`data/models/message.dart`) —
/// this is a separate parallel type the chat thread and Client Profile merge
/// in client-side, never a `Message.status` value.
@freezed
abstract class ScheduledMessage with _$ScheduledMessage {
  const factory ScheduledMessage({
    required String id,
    required String tenantId,
    required String clientId,
    String? senderId,
    String? createdByUserId,
    String? templateId,
    required String templateName,
    @Default('en') String templateLanguage,

    /// Body variables keyed by placeholder (positional "1"/"2" or named);
    /// values may be numbers on the wire, so this stays `dynamic` — use
    /// [variablesAsStrings] to feed them back into a fill form.
    Map<String, dynamic>? templateVariables,
    Map<String, String>? buttonVariables,

    /// Preview text with variables already substituted — render this in the
    /// bubble/card, mirroring the sent-message body.
    String? renderedBody,
    required DateTime scheduledFor,

    /// IANA timezone the picker was shown in, when known.
    String? timezone,
    @JsonKey(unknownEnumValue: ScheduledMessageStatus.pending)
    @Default(ScheduledMessageStatus.pending)
    ScheduledMessageStatus status,
    String? jobId,
    String? sentMessageId,
    String? sentAt,
    String? cancelledByUserId,
    String? cancelledAt,
    String? cancellationReason,

    /// Populated when [status] is `failed`.
    String? errorMessage,
    required String createdAt,
    required String updatedAt,
  }) = _ScheduledMessage;

  const ScheduledMessage._();

  factory ScheduledMessage.fromJson(Map<String, dynamic> json) =>
      _$ScheduledMessageFromJson(json);

  bool get isPending => status == ScheduledMessageStatus.pending;
  bool get isFailed => status == ScheduledMessageStatus.failed;
  bool get isSent => status == ScheduledMessageStatus.sent;
  bool get isCancelled => status == ScheduledMessageStatus.cancelled;

  /// [templateVariables] coerced to strings, for pre-filling a fill-form's
  /// text controllers on Edit (the API may return numeric values).
  Map<String, String> get variablesAsStrings => {
    for (final e in (templateVariables ?? const {}).entries)
      e.key: '${e.value}',
  };
}

/// One lifecycle/activity entry on a [ScheduledMessage] — the `events[]`
/// array on the single-item `GET`, newest first.
@freezed
abstract class ScheduledMessageEvent with _$ScheduledMessageEvent {
  const factory ScheduledMessageEvent({
    required String id,
    required String scheduledMessageId,
    required String tenantId,
    @JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled)
    required ScheduledMessageEventType eventType,
    String? actorUserId,
    @Default('user') String actorKind,
    Map<String, dynamic>? metadata,
    required String createdAt,
  }) = _ScheduledMessageEvent;

  const ScheduledMessageEvent._();

  factory ScheduledMessageEvent.fromJson(Map<String, dynamic> json) =>
      _$ScheduledMessageEventFromJson(json);

  DateTime get createdAtDate =>
      DateTime.tryParse(createdAt)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
