import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../thread_controller.dart';

/// Reply composer for the chat thread (Phase 7). Free-form sending is only
/// allowed inside WhatsApp's 24-hour service window ([windowOpen]); otherwise
/// it shows guidance to use an approved template.
class ChatComposer extends ConsumerStatefulWidget {
  const ChatComposer({
    super.key,
    required this.clientId,
    required this.to,
    required this.windowOpen,
    required this.onSent,
  });

  final String clientId;
  final String to;
  final bool windowOpen;
  final VoidCallback onSent;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ThreadController get _thread =>
      ref.read(threadControllerProvider(widget.clientId).notifier);

  void _sendText() {
    final body = _controller.text.trim();
    if (body.isEmpty) return;
    _controller.clear();
    _thread.sendText(widget.to, body);
    widget.onSent();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;
    _thread.sendMedia(
      to: widget.to,
      mediaType: 'image',
      filePath: picked.path,
      filename: picked.name,
    );
    widget.onSent();
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    final file = result?.files.single;
    if (file?.path == null) return;
    _thread.sendMedia(
      to: widget.to,
      mediaType: 'document',
      filePath: file!.path!,
      filename: file.name,
    );
    widget.onSent();
  }

  void _openAttachSheet() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.attachPhoto),
              onTap: () {
                Navigator.pop(sheetCtx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.attachCamera),
              onTap: () {
                Navigator.pop(sheetCtx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: Text(l10n.attachDocument),
              onTap: () {
                Navigator.pop(sheetCtx);
                _pickDocument();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (!widget.windowOpen) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: theme.colorScheme.surfaceContainerHighest,
        child: Row(
          children: [
            Icon(Icons.lock_clock, size: 18, color: theme.colorScheme.outline),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.windowClosed,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _openAttachSheet,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: l10n.composerHint,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: _hasText ? _sendText : null,
            ),
          ],
        ),
      ),
    );
  }
}
