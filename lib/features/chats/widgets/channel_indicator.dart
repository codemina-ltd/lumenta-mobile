import 'package:flutter/material.dart';

import '../../../core/i18n/arb/app_localizations.dart';

/// Icon identifying a message's originating channel — shared between the
/// bubble meta row (chat detail), the chats-list row and the channel thread
/// tabs so every surface paints the same glyph for the same channel.
IconData channelIcon(String channel) {
  switch (channel) {
    case 'instagram':
      return Icons.camera_alt_outlined;
    case 'messenger':
      return Icons.messenger_outline;
    case 'sms':
      return Icons.sms_outlined;
    case 'email':
      return Icons.mail_outline;
    default: // 'whatsapp' and anything unknown
      return Icons.chat_bubble;
  }
}

/// Brand-ish color matching [channelIcon].
Color channelColor(String channel) {
  switch (channel) {
    case 'instagram':
      return const Color(0xFFE1306C);
    case 'messenger':
      return const Color(0xFF0084FF);
    case 'sms':
      return const Color(0xFFD4A017);
    case 'email':
      return const Color(0xFF722ED1);
    default: // 'whatsapp' and anything unknown
      return const Color(0xFF25D366);
  }
}

/// Localized channel display name — the tab/caption fallback when a channel
/// account has no display name of its own.
String channelLabel(AppLocalizations l10n, String channel) {
  switch (channel) {
    case 'instagram':
      return l10n.channelInstagram;
    case 'messenger':
      return l10n.channelMessenger;
    case 'sms':
      return l10n.channelSms;
    case 'email':
      return l10n.channelEmail;
    default:
      return l10n.channelWhatsapp;
  }
}
