import 'package:dio/dio.dart' show DioMediaType;
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
import 'voice_recorder.dart';

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
    this.recorderController,
  });

  final ThreadKey threadKey;
  final String to;
  final bool windowOpen;
  final VoidCallback onSent;
  final String? senderLabel;
  final String? senderNumber;
  final bool senderActive;

  /// Voice-note state machine. Injected by tests / previews; the composer
  /// creates (and owns) one when null.
  final VoiceRecorderController? recorderController;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;

  late final VoiceRecorderController _recorder =
      widget.recorderController ?? VoiceRecorderController();
  late final bool _ownsRecorder = widget.recorderController == null;

  /// True while the finger that started a held recording is still down.
  bool _micPointerDown = false;

  /// Direction of the draft, detected from its content so Arabic input lays
  /// out RTL even in an English UI. Null while empty → follow the app locale
  /// (keeps the hint aligned with the UI language).
  TextDirection? _inputDirection;

  @override
  void initState() {
    super.initState();
    _recorder.addListener(_onRecorderChanged);
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
    _recorder.removeListener(_onRecorderChanged);
    if (_ownsRecorder) _recorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onRecorderChanged() {
    if (mounted) setState(() {});
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // --- Voice notes -------------------------------------------------------

  Future<void> _onMicDown() async {
    if (_recorder.isActive) return;
    _micPointerDown = true;
    final ok = await _recorder.start();
    if (!mounted) return;
    if (!ok) {
      _micPointerDown = false;
      final l10n = AppLocalizations.of(context);
      _snack(
        _recorder.permissionDenied
            ? l10n.composerMicDenied
            : l10n.composerRecordFailed,
      );
    }
  }

  void _onMicMove(Offset delta) {
    if (!_micPointerDown) return;
    _recorder.updateDrag(delta, textDirection: Directionality.of(context));
  }

  Future<void> _onMicUp() async {
    if (!_micPointerDown) return;
    _micPointerDown = false;
    final result = await _recorder.release();
    if (!mounted) return;
    if (result.tooShort) {
      _snack(AppLocalizations.of(context).composerHoldToRecord);
      return;
    }
    if (result.path != null) _sendVoiceNote(result.path!);
  }

  Future<void> _sendLockedRecording() async {
    final path = await _recorder.finish();
    if (!mounted || path == null) return;
    _sendVoiceNote(path);
  }

  void _sendVoiceNote(String path) {
    _thread.sendMedia(
      to: widget.to,
      mediaType: 'audio',
      filePath: path,
      filename: path.split('/').last,
      voiceNote: true,
      contentType: DioMediaType('audio', 'mp4'),
    );
    widget.onSent();
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
    final file = await FilePicker.pickFile();
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

    final phase = _recorder.phase;
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
              if (caption != null && phase == RecordPhase.idle)
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
              if (phase == RecordPhase.locked)
                LockedRecordingPanel(
                  controller: _recorder,
                  onDelete: _recorder.cancel,
                  onSend: _sendLockedRecording,
                )
              else
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (phase == RecordPhase.holding)
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: HoldRecordingBar(controller: _recorder),
                            ),
                          )
                        else ...[
                          IconButton(
                            icon: const Icon(Icons.add_rounded, size: 28),
                            color: scheme.onSurface,
                            tooltip: l10n.attachDocument,
                            onPressed: _openAttachSheet,
                          ),
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 44),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(Radii.xl),
                                border: Border.all(
                                  color: scheme.outlineVariant,
                                ),
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
                          if (!_hasText)
                            IconButton(
                              icon: const Icon(
                                Icons.photo_camera_outlined,
                                size: 26,
                              ),
                              color: scheme.onSurface,
                              tooltip: l10n.attachCamera,
                              onPressed: () => _pickImage(ImageSource.camera),
                            )
                          else
                            const SizedBox(width: Insets.sm),
                        ],
                        if (_hasText && phase == RecordPhase.idle)
                          _SendButton(enabled: true, onTap: _sendText)
                        else
                          _MicButton(
                            key: const ValueKey('composer-mic'),
                            recording: phase == RecordPhase.holding,
                            tooltip: l10n.composerRecordVoice,
                            onDown: _onMicDown,
                            onMove: _onMicMove,
                            onUp: _onMicUp,
                          ),
                      ],
                    ),
                    if (phase == RecordPhase.holding)
                      PositionedDirectional(
                        end: 2,
                        bottom: 56,
                        child: RecordLockHint(progress: _recorder.lockProgress),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trailing composer action (mic / send): a 36pt disc inside a 44pt hit box.
const double _composerActionDisc = 36;
const double _composerActionHit = 44;

/// Hold-to-record mic (WhatsApp): pointer down starts recording, the finger's
/// travel feeds slide-to-cancel / slide-up-to-lock, release sends. A raw
/// [Listener] so the gesture starts instantly and keeps tracking after the
/// finger leaves the button.
class _MicButton extends StatelessWidget {
  const _MicButton({
    super.key,
    required this.recording,
    required this.tooltip,
    required this.onDown,
    required this.onMove,
    required this.onUp,
  });

  final bool recording;
  final String tooltip;
  final VoidCallback onDown;
  final ValueChanged<Offset> onMove;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) => onDown(),
        onPointerMove: (e) => onMove(e.delta),
        onPointerUp: (_) => onUp(),
        onPointerCancel: (_) => onUp(),
        // 44pt hit box around a smaller disc so the target stays comfortable
        // while the button sits visually lighter next to the field pill.
        child: SizedBox(
          width: _composerActionHit,
          height: _composerActionHit,
          child: Center(
            child: AnimatedScale(
              scale: recording ? 1.35 : 1,
              duration: Motion.normal,
              curve: Motion.emphasized,
              child: Container(
                width: _composerActionDisc,
                height: _composerActionDisc,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.signal,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
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
    // Same disc size as the mic so the swap between them doesn't jump.
    return SizedBox(
      width: _composerActionHit,
      height: _composerActionHit,
      child: Center(
        child: AnimatedContainer(
          duration: Motion.fast,
          curve: Motion.standard,
          width: _composerActionDisc,
          height: _composerActionDisc,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? AppColors.signal
                : context.scheme.onSurface.withValues(alpha: 0.12),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: const Icon(Icons.arrow_upward_rounded),
            color: enabled
                ? Colors.white
                : context.scheme.onSurface.withValues(alpha: 0.4),
            onPressed: enabled ? onTap : null,
          ),
        ),
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
