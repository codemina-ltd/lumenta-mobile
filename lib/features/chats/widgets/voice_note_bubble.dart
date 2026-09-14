import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/message.dart';
import 'audio_bubble.dart';

/// Voice note: the [AudioBubble] player, plus — when Lume transcribed an
/// inbound note or synthesised an outbound voice reply — the words under a
/// hairline with a small Lume label, so the audio and its text read as one
/// message (mirrors the portal's ChatBubble audio branch).
class VoiceNoteContent extends StatelessWidget {
  const VoiceNoteContent({
    super.key,
    required this.message,
    required this.textColor,
    required this.loadBytes,
  });

  final Message message;
  final Color textColor;
  final Future<Uint8List?> Function() loadBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lume = isDark ? AppColors.lumeOnDark : AppColors.lume;

    final transcript = message.transcriptionReady &&
            (message.transcription?.trim().isNotEmpty ?? false)
        ? message.transcription!.trim()
        : message.isLumeVoiceReply
            ? message.body.trim()
            : null;
    final transcribing = transcript == null && message.transcriptionInFlight;

    final player = AudioBubble(
      color: textColor,
      outbound: message.isOutbound,
      mimeType: message.mediaMimeType,
      loadBytes: loadBytes,
    );
    if (transcript == null && !transcribing) return player;

    final label = message.isLumeVoiceReply
        ? l10n.lumeVoiceReply
        : transcribing
            ? l10n.lumeTranscribing
            : l10n.transcribedByLume;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        player,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.sm),
          child: Divider(
            height: 1,
            thickness: 1,
            color: textColor.withValues(alpha: 0.12),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (transcribing)
              SizedBox(
                width: 11,
                height: 11,
                child: CircularProgressIndicator(strokeWidth: 1.6, color: lume),
              )
            else
              Icon(Icons.auto_awesome_outlined, size: 12, color: lume),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w600,
                color: lume,
              ),
            ),
          ],
        ),
        if (transcript != null) ...[
          const SizedBox(height: 3),
          Text(
            transcript,
            textDirection: Fmt.textDirectionFor(transcript),
            style: TextStyle(color: textColor, fontSize: 14, height: 1.35),
          ),
        ],
      ],
    );
  }
}
