import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../templates/template_picker_sheet.dart';
import '../thread_controller.dart';

/// Reply composer for the chat thread (Phase 7). Free-form sending is only
/// allowed inside WhatsApp's 24-hour service window ([windowOpen]); otherwise
/// it shows guidance to use an approved template.
///
/// Per-sender threads: the composer is bound to [threadKey] — every send
/// (text, media, template) carries that thread's sender explicitly. When the
/// sender tab bar is visible, [senderLabel] surfaces the routing as a
/// "Sending as …" caption, and an inactive sender disables sending entirely.
class ChatComposer extends ConsumerStatefulWidget {
  const ChatComposer({
    super.key,
    required this.threadKey,
    required this.to,
    required this.windowOpen,
    required this.onSent,
    this.senderLabel,
    this.senderNumber,
    this.senderActive = true,
  });

  final ThreadKey threadKey;
  final String to;
  final bool windowOpen;
  final VoidCallback onSent;
  final String? senderLabel;
  final String? senderNumber;
  final bool senderActive;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;

  /// Direction of the draft, detected from its content so Arabic input lays
  /// out RTL even in an English UI. Null while empty → follow the app locale
  /// (keeps the hint aligned with the UI language).
  TextDirection? _inputDirection;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      final has = text.trim().isNotEmpty;
      final dir = has ? Fmt.textDirectionFor(text) : null;
      if (has != _hasText || dir != _inputDirection) {
        setState(() {
          _hasText = has;
          _inputDirection = dir;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ThreadController get _thread =>
      ref.read(threadControllerProvider(widget.threadKey).notifier);

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
    final result = await FilePicker.pickFiles();
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
      threadKey: widget.threadKey,
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

  /// "Sending as {sender} · {number}" — keeps the routing visible whenever
  /// the composer is bound to a specific sender.
  Widget? _sendingAsCaption(BuildContext context, AppLocalizations l10n) {
    final label = widget.senderLabel;
    if (label == null) return null;
    final number = widget.senderNumber;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xs),
      child: Text(
        number != null && number.isNotEmpty
            ? l10n.sendingAs(label, number)
            : l10n.sendingAsNameOnly(label),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.labelSmall?.copyWith(
          color: context.scheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final caption = _sendingAsCaption(context, l10n);

    // Inactive sender: the thread stays readable, sending is fully disabled.
    if (!widget.senderActive) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.md,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.do_not_disturb_on_outlined,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Text(
                    l10n.senderInactiveComposer,
                    style: context.text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                if (caption != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: caption,
                  ),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_clock_rounded,
                      size: 20,
                      color: AppColors.amber,
                    ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (caption != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: Insets.md,
                    top: 2,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: caption,
                  ),
                ),
              Row(
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
                        textDirection: _inputDirection,
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
