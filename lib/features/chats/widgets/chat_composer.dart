import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../templates/template_picker_sheet.dart';
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

  /// Open the template pick → fill → send flow; scroll to the new bubble once
  /// a template has been sent. Available in both window states.
  Future<void> _openTemplateFlow() async {
    final sent = await showTemplatePicker(
      context: context,
      clientId: widget.clientId,
      to: widget.to,
    );
    if (sent == true) widget.onSent();
  }

  void _openAttachSheet() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.sm,
            0,
            Insets.sm,
            Insets.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AttachOption(
                icon: Icons.photo_library_rounded,
                color: AppColors.signal,
                label: l10n.attachPhoto,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              _AttachOption(
                icon: Icons.photo_camera_rounded,
                color: AppColors.lilac,
                label: l10n.attachCamera,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickImage(ImageSource.camera);
                },
              ),
              _AttachOption(
                icon: Icons.insert_drive_file_rounded,
                color: AppColors.amber,
                label: l10n.attachDocument,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickDocument();
                },
              ),
              _AttachOption(
                icon: Icons.description_rounded,
                color: AppColors.lilac,
                label: l10n.attachTemplate,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _openTemplateFlow();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (!widget.windowOpen) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.amber.withValues(alpha: 0.12),
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lock_clock_rounded,
                        size: 20, color: AppColors.amber),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Text(
                        l10n.windowClosed,
                        style: context.text.bodySmall?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _openTemplateFlow,
                    icon: const Icon(Icons.description_rounded, size: 20),
                    label: Text(l10n.sendTemplate),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: AppColors.signal,
                      foregroundColor: AppColors.deepForest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.sm,
            Insets.sm,
            Insets.sm,
            Insets.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: scheme.onSurfaceVariant,
                onPressed: _openAttachSheet,
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(Radii.xl),
                  ),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: l10n.composerHint,
                      isDense: true,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Insets.lg,
                        vertical: Insets.md,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Insets.sm),
              _SendButton(enabled: _hasText, onTap: _sendText),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated send button — fades from disabled grey to the signal accent as
/// soon as the field has content.
class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Motion.fast,
      curve: Motion.standard,
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled
            ? AppColors.signal
            : context.scheme.onSurface.withValues(alpha: 0.12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_upward_rounded),
        color: enabled
            ? AppColors.deepForest
            : context.scheme.onSurface.withValues(alpha: 0.4),
        onPressed: enabled ? onTap : null,
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(label, style: context.text.titleMedium),
    );
  }
}
