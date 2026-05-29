// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageDirection {
  @JsonValue('inbound')
  inbound,
  @JsonValue('outbound')
  outbound,
}

enum MessageStatus {
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
  @JsonValue('received')
  received,
}

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('document')
  document,
  @JsonValue('sticker')
  sticker,
  @JsonValue('location')
  location,
  @JsonValue('contacts')
  contacts,
  @JsonValue('button')
  button,
  @JsonValue('interactive')
  interactive,
  @JsonValue('template')
  template,
  @JsonValue('reaction')
  reaction,
  @JsonValue('unknown')
  unknown,
}

/// A single message from `GET /v1/clients/:id/messages`.
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    required MessageDirection direction,
    @Default('') String body,
    @JsonKey(unknownEnumValue: MessageStatus.sent)
    @Default(MessageStatus.sent)
    MessageStatus status,
    @JsonKey(unknownEnumValue: MessageType.unknown)
    @Default(MessageType.text)
    MessageType messageType,
    String? mediaUrl,
    String? mediaMimeType,
    String? locationLatitude,
    String? locationLongitude,
    String? locationName,
    String? locationAddress,
    String? transcription,
    String? transcriptionStatus,
    required String createdAt,
  }) = _Message;

  const Message._();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  bool get isOutbound => direction == MessageDirection.outbound;
  bool get hasMedia =>
      messageType == MessageType.image ||
      messageType == MessageType.video ||
      messageType == MessageType.audio ||
      messageType == MessageType.document ||
      messageType == MessageType.sticker;
  bool get transcriptionReady => transcriptionStatus == 'ready';

  DateTime get createdAtDate =>
      DateTime.tryParse(createdAt)?.toLocal() ?? DateTime.fromMillisecondsSinceEpoch(0);
}
