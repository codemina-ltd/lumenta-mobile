import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/message.dart';

/// Tappable document bubble: downloads the proxied media through the
/// authenticated Dio into a per-message temp cache, then hands the file to
/// the OS viewer (Quick Look on iOS, ACTION_VIEW on Android).
///
/// The media proxy requires the Bearer header, which an external viewer can't
/// send, so the file must be materialised locally first — same constraint as
/// [AudioBubble].
class DocumentBubble extends ConsumerStatefulWidget {
  const DocumentBubble({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  ConsumerState<DocumentBubble> createState() => _DocumentBubbleState();
}

class _DocumentBubbleState extends ConsumerState<DocumentBubble> {
  bool _busy = false;

  /// Filename embedded by the API in the body as `[Document: name.pdf]`
  /// (mirrors the portal's DocumentMessage parsing). Null for captions or
  /// legacy rows without one.
  String? get _embeddedFilename {
    final match = RegExp(r'\[Document: (.+)\]').firstMatch(widget.message.body);
    return match?.group(1)?.trim();
  }

  /// Human label on the tile: embedded filename → caption → generic label.
  String _label(AppLocalizations l10n) {
    final name = _embeddedFilename;
    if (name != null && name.isNotEmpty) return name;
    if (widget.message.body.trim().isNotEmpty) return widget.message.body;
    return l10n.previewDocument;
  }

  /// Name the cached file is saved under — the OS viewer shows it, and the
  /// extension is what Android uses to pick an app.
  String get _cacheFilename {
    final name = _embeddedFilename;
    if (name != null && name.isNotEmpty) {
      // Strip path separators so the name can't escape the cache directory.
      return name.replaceAll(RegExp(r'[/\\]'), '_');
    }
    return 'document.${_extensionFor(widget.message.mediaMimeType)}';
  }

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
          SnackBar(content: Text(l10n.documentOpenFailed)),
        );
      }
    } on DioException catch (e) {
      // The proxy answers 410 once WhatsApp's media retention lapses.
      final expired = e.response?.statusCode == 410;
      messenger.showSnackBar(
        SnackBar(
          content: Text(expired ? l10n.mediaExpired : l10n.documentOpenFailed),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.documentOpenFailed)),
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
    final file = File('${dir.path}/$_cacheFilename');
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
    final l10n = AppLocalizations.of(context);
    final color = widget.textColor;
    final label = _label(l10n);
    return Semantics(
      button: true,
      label: l10n.openDocument,
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
              child: Icon(
                _iconFor(widget.message.mediaMimeType),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: Insets.md),
            Flexible(
              child: Text(
                label,
                textDirection: Fmt.textDirectionFor(label),
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

IconData _iconFor(String? mime) {
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

String _extensionFor(String? mime) {
  switch (mime) {
    case 'application/pdf':
      return 'pdf';
    case 'application/msword':
      return 'doc';
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      return 'docx';
    case 'application/vnd.ms-excel':
      return 'xls';
    case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      return 'xlsx';
    case 'application/vnd.ms-powerpoint':
      return 'ppt';
    case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      return 'pptx';
    case 'text/plain':
      return 'txt';
    case 'text/csv':
      return 'csv';
    case null:
      return 'bin';
    default:
      final subtype = mime.split('/').last.split(';').first.trim();
      return subtype.isEmpty ? 'bin' : subtype;
  }
}
