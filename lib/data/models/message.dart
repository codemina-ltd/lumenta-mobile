// ignore_for_file: invalid_annotation_target
import 'dart:convert';

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
abstract class Message with _$Message {
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

    /// Shared-contact cards on an inbound `contacts` message — the API's
    /// sanitized copy of Meta's `messages[0].contacts` array. Null for other
    /// types and for legacy rows (see [sharedContacts] for the fallback).
    List<dynamic>? contactsData,
    String? transcription,
    String? transcriptionStatus,

    /// Emoji the customer reacted with (webhook writes it onto the reacted-to
    /// message row); null / empty when there is no active reaction.
    String? reaction,
    Map<String, dynamic>? providerRawPayload,

    /// First-class template linkage on outbound template sends (see
    /// api/docs/MESSAGE_TEMPLATE_CONTRACT.md): the internal template UUID.
    /// Null after the template is deleted (SET NULL FK), on inbound rows,
    /// and on legacy pre-backfill rows — see [templateId] for the fallback.
    @JsonKey(name: 'templateId') String? templateIdRaw,

    /// The ACTUAL values sent with the template — never the template's
    /// example values: `{variables, buttonVariables, language, name,
    /// category}`. Null on non-template rows.
    Map<String, dynamic>? templateData,

    /// Sender (WABA phone number) that carried this message. Null on legacy
    /// rows written before sender attribution existed.
    String? senderId,

    /// Team member who sent this outbound message ("Sent by …" attribution,
    /// mirrors the portal). Response-only field; null on inbound rows and
    /// rows whose user no longer exists.
    String? sentByUserName,

    /// "Delete for everyone" tombstone. When set, the server has cleared
    /// body/media and the bubble renders a "message deleted" placeholder.
    String? deletedForEveryoneAt,
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

  /// Filename of a document message, when known. The API encodes it in the
  /// body as `[Document: name.pdf]` (inbound rows and outbound rows without
  /// a caption); rows whose body is a caption don't carry one.
  String? get documentFilename {
    if (messageType != MessageType.document) return null;
    return RegExp(r'\[Document: (.+)\]').firstMatch(body)?.group(1)?.trim();
  }

  /// The user-authored caption on a media message, or null when the body is
  /// just the server's type placeholder (`[Image]`, `[Video]`, `[Audio]`,
  /// `[Sticker]`, `[Document…]`). Placeholders are UI markers, not text —
  /// they must not be rendered, copied, shared, or forwarded as content.
  String? get mediaCaption {
    if (!hasMedia) return null;
    final b = body.trim();
    if (b.isEmpty) return null;
    const placeholders = {'[Image]', '[Video]', '[Audio]', '[Sticker]'};
    if (placeholders.contains(b)) return null;
    if (RegExp(r'^\[Document(: .+)?\]$').hasMatch(b)) return null;
    return b;
  }
  bool get hasReaction => reaction != null && reaction!.isNotEmpty;
  bool get isDeleted => deletedForEveryoneAt != null;

  /// An inbound interactive message is a WhatsApp Flow response — the customer
  /// submitted a form. Mirrors the portal's `ChatBubble` inbound-interactive
  /// branch: the [body] holds the submitted form data as a JSON object.
  bool get isFlowResponse =>
      direction == MessageDirection.inbound &&
      messageType == MessageType.interactive;

  /// Flow name taken from the provider payload
  /// (`messages[0].interactive.nfm_reply.name`), capitalised. Null when the
  /// payload doesn't carry one, so callers can fall back to a generic label.
  String? get flowName {
    try {
      final messages = providerRawPayload?['messages'];
      if (messages is List && messages.isNotEmpty) {
        final name = messages[0]?['interactive']?['nfm_reply']?['name'];
        if (name is String && name.isNotEmpty) {
          return name[0].toUpperCase() + name.substring(1);
        }
      }
    } catch (_) {
      // Fall through to null on any unexpected payload shape.
    }
    return null;
  }

  /// Shared-contact cards for a `contacts` message, as maps shaped like
  /// Meta's webhook `contacts` entries (name/phones/emails/org/…). Prefers
  /// the structured [contactsData] column; legacy rows fall back to the raw
  /// provider payload (`messages[0].contacts`) — same trick as [flowName].
  /// Empty for every other message type.
  List<Map<String, dynamic>> get sharedContacts {
    List<Map<String, dynamic>> asMaps(dynamic list) => list is List
        ? list.whereType<Map>().map(Map<String, dynamic>.from).toList()
        : const [];

    final structured = asMaps(contactsData);
    if (structured.isNotEmpty) return structured;

    try {
      final messages = providerRawPayload?['messages'];
      if (messages is List && messages.isNotEmpty) {
        return asMaps(messages[0]?['contacts']);
      }
    } catch (_) {
      // Fall through to empty on any unexpected payload shape.
    }
    return const [];
  }

  /// Internal template UUID behind an outbound template message. Prefers the
  /// first-class [templateIdRaw] field the API now stamps; rows written
  /// before the backfill fall back to the legacy
  /// `providerRawPayload.templateInfo` stuffing. Null for external templates
  /// (sent by name only) and unrecoverable legacy rows — those keep the
  /// plain-body rendering.
  String? get templateId {
    if (templateIdRaw != null && templateIdRaw!.isNotEmpty) {
      return templateIdRaw;
    }
    final info = providerRawPayload?['templateInfo'];
    if (info is Map) {
      final id = info['templateId'];
      if (id is String && id.isNotEmpty) return id;
    }
    return null;
  }

  /// The parsed key/value pairs the customer submitted in the flow form.
  /// Falls back to a single `rawBody` entry when [body] isn't valid JSON,
  /// matching the portal's modal behaviour.
  Map<String, dynamic> get flowResponseFields {
    try {
      final decoded = jsonDecode(body.isEmpty ? '{}' : body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      // Fall through to raw body on parse failure.
    }
    return {'rawBody': body};
  }

  DateTime get createdAtDate =>
      DateTime.tryParse(createdAt)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
