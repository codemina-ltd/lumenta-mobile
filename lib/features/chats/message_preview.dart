import 'package:flutter/widgets.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../data/models/message.dart';

/// Type-aware one-line preview for the chats list (e.g. "📷 Photo").
String messagePreview(
  BuildContext context,
  MessageType? type,
  String? body,
) {
  final l10n = AppLocalizations.of(context);
  final text = (body ?? '').trim();
  switch (type) {
    case MessageType.text:
    case null:
      return text;
    case MessageType.image:
      return '📷 ${l10n.previewPhoto}';
    case MessageType.audio:
      return '🎙 ${l10n.previewVoice}';
    case MessageType.video:
      return '🎬 ${l10n.previewVideo}';
    case MessageType.document:
      return '📄 ${l10n.previewDocument}';
    case MessageType.location:
      return '📍 ${l10n.previewLocation}';
    case MessageType.sticker:
      return '🧩 ${l10n.previewSticker}';
    case MessageType.contacts:
      return '👤 ${l10n.previewContact}';
    default:
      return text.isEmpty ? '…' : text;
  }
}
