import 'package:flutter/material.dart';

/// Icon identifying a message's originating channel — shared between the
/// bubble meta row (chat detail) and the chats-list row so both surfaces
/// paint the same glyph for the same channel.
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
