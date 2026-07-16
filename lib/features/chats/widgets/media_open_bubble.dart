import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/mime.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/message.dart';

/// Tappable document bubble: icon + filename, tap to download & open.
class DocumentBubble extends StatelessWidget {
  const DocumentBubble({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = message.documentFilename;
    final label = name ?? message.mediaCaption ?? l10n.previewDocument;
    return _MediaOpenBubble(
      message: message,
      textColor: textColor,
      icon: _docIconFor(message.mediaMimeType),
      label: label,
      // Strip path separators so the name can't escape the cache directory.
      cacheFilename: name != null
          ? name.replaceAll(RegExp(r'[/\\]'), '_')
          : 'document.${extensionForMime(message.mediaMimeType)}',
      semanticLabel: l10n.openDocument,
      openFailedText: l10n.documentOpenFailed,
    );
  }
}

/// Tappable video bubble: tap to download & play in the OS viewer.
class VideoBubble extends StatelessWidget {
  const VideoBubble({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _MediaOpenBubble(
      message: message,
      textColor: textColor,
      icon: Icons.videocam_rounded,
      // Authored caption only — the server stores a '[Video]' placeholder
      // body when there is none.
      label: message.mediaCaption ?? l10n.previewVideo,
      cacheFilename:
          'video.${extensionForMime(message.mediaMimeType, fallback: 'mp4')}',
      semanticLabel: l10n.openVideo,
      openFailedText: l10n.videoOpenFailed,
    );
  }
}

/// Shared tap-to-open tile: downloads the proxied media through the
/// authenticated Dio into a per-message temp cache, then hands the file to
/// the OS viewer (Quick Look on iOS, ACTION_VIEW on Android).
///
/// The media proxy requires the Bearer header, which an external viewer can't
/// send, so the file must be materialised locally first — same constraint as
/// [AudioBubble].
class _MediaOpenBubble extends ConsumerStatefulWidget {
  const _MediaOpenBubble({
    required this.message,
    required this.textColor,
    required this.icon,
    required this.label,
    required this.cacheFilename,
    required this.semanticLabel,
    required this.openFailedText,
  });

  final Message message;
  final Color textColor;
  final IconData icon;
  final String label;
  final String cacheFilename;
  final String semanticLabel;
  final String openFailedText;

  @override
  ConsumerState<_MediaOpenBubble> createState() => _MediaOpenBubbleState();
}

class _MediaOpenBubbleState extends ConsumerState<_MediaOpenBubble> {
  bool _busy = false;

  Future<void> _open() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final file = await _download();
      final result = await OpenFilex.open(
        file.path,
        type: widget.message.mediaMimeType,
      );
      if (result.type == ResultType.noAppToOpen) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.documentNoApp)));
      } else if (result.type != ResultType.done) {
        messenger.showSnackBar(
          SnackBar(content: Text(widget.openFailedText)),
        );
      }
    } on DioException catch (e) {
      // The proxy answers 410 once WhatsApp's media retention lapses.
      final expired = e.response?.statusCode == 410;
      messenger.showSnackBar(
        SnackBar(
          content: Text(expired ? l10n.mediaExpired : widget.openFailedText),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(widget.openFailedText)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Downloads into `<systemTemp>/lumenta_docs/<messageId>/<name>`, reused on
  /// later taps. The file must outlive this widget while the OS viewer has it
  /// open, so it is deliberately not deleted afterwards.
  Future<File> _download() async {
    final dir = Directory(
      '${Directory.systemTemp.path}/lumenta_docs/${widget.message.id}',
    );
    final file = File('${dir.path}/${widget.cacheFilename}');
    if (await file.exists() && await file.length() > 0) return file;

    final url = ref.read(messagesRepoProvider).mediaUrl(widget.message.id);
    final res = await ref
        .read(dioProvider)
        .get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
    final bytes = res.data;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('empty media response');
    }
    await dir.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.textColor;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: InkWell(
        onTap: _open,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Insets.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(widget.icon, color: color, size: 24),
            ),
            const SizedBox(width: Insets.md),
            Flexible(
              child: Text(
                widget.label,
                textDirection: Fmt.textDirectionFor(widget.label),
                style: TextStyle(color: color),
              ),
            ),
            const SizedBox(width: Insets.md),
            _busy
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color.withValues(alpha: 0.7),
                    ),
                  )
                : Icon(
                    Icons.file_download_outlined,
                    size: 18,
                    color: color.withValues(alpha: 0.7),
                  ),
          ],
        ),
      ),
    );
  }
}

IconData _docIconFor(String? mime) {
  final m = mime ?? '';
  if (m == 'application/pdf') return Icons.picture_as_pdf_rounded;
  if (m.contains('spreadsheet') || m.contains('excel') || m == 'text/csv') {
    return Icons.table_chart_rounded;
  }
  if (m.contains('presentation') || m.contains('powerpoint')) {
    return Icons.slideshow_rounded;
  }
  if (m.contains('word') || m == 'text/plain') return Icons.description_rounded;
  if (m.contains('zip') || m.contains('compressed')) {
    return Icons.folder_zip_rounded;
  }
  return Icons.insert_drive_file_rounded;
}

