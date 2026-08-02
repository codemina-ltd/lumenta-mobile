import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/channel_thread.dart';
import '../thread_controller.dart';
import 'channel_indicator.dart';

/// Reply composer for a non-WhatsApp channel thread (Instagram DM /
/// Messenger) — the send path for channel-only (phone-less) contacts.
///
/// Text only: channel media sends stay portal-only for now. Mirrors the
/// portal's ChannelComposer window logic (enforced server-side too):
/// - 24h service window open → normal send;
/// - closed but the customer messaged within 7 days → a "send as human
///   agent" checkbox unlocks sending with the HUMAN_AGENT tag;
/// - otherwise → a "window closed" notice instead of the input.
class ChannelComposer extends ConsumerStatefulWidget {
  const ChannelComposer({
    super.key,
    required this.threadKey,
    required this.thread,
    required this.onSent,
  });

  final ThreadKey threadKey;
  final ChannelThread thread;
  final VoidCallback onSent;

  @override
  ConsumerState<ChannelComposer> createState() => _ChannelComposerState();
}

class _ChannelComposerState extends ConsumerState<ChannelComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;
  bool _humanAgent = false;
  bool _sending = false;

  /// Direction of the draft, detected from its content so Arabic input lays
  /// out RTL even in an English UI (same behavior as ChatComposer).
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

  /// The server rejects out-of-window sends with 422 MESSAGING_WINDOW_EXPIRED
  /// — surface that as the window-closed copy rather than a generic failure.
  static bool _isWindowExpired(Object e) {
    if (e is! DioException) return false;
    final res = e.response;
    final data = res?.data;
    return res?.statusCode == 422 &&
        data is Map &&
        data['errorCode'] == 'MESSAGING_WINDOW_EXPIRED';
  }

  Future<void> _send() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    _controller.clear();
    final error = await ref
        .read(threadControllerProvider(widget.threadKey).notifier)
        .sendChannelText(
          threadId: widget.thread.id,
          body: body,
          humanAgent: _humanAgent,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    if (error == null) {
      widget.onSent();
      return;
    }
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWindowExpired(error)
              ? l10n.channelWindowClosed
              : l10n.channelSendFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final thread = widget.thread;
    final windowOpen = thread.windowOpen;
    final humanAgentAvailable = thread.humanAgentAvailable;

    // Neither window applies — the thread is read-only until the customer
    // messages again.
    if (!windowOpen && !humanAgentAvailable) {
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
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  size: 20,
                  color: AppColors.amber,
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Text(
                    l10n.channelWindowClosed,
                    style: context.text.bodySmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final accountLabel = (thread.accountDisplayName?.trim().isNotEmpty ?? false)
        ? thread.accountDisplayName!
        : channelLabel(l10n, thread.channelType);
    final canSend = windowOpen || _humanAgent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: Insets.md,
                  top: 2,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.sendingAsNameOnly(accountLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // Window closed, but the 7-day human-agent window is still
              // open — sending requires the explicit opt-in.
              if (!windowOpen)
                InkWell(
                  onTap: () => setState(() => _humanAgent = !_humanAgent),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: Insets.xs),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _humanAgent,
                          visualDensity: VisualDensity.compact,
                          onChanged: (v) =>
                              setState(() => _humanAgent = v ?? false),
                        ),
                        Expanded(
                          child: Text(
                            l10n.channelHumanAgentLabel,
                            style: context.text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: Insets.sm),
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
                        enabled: canSend,
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
                  _SendButton(
                    enabled: _hasText && canSend && !_sending,
                    onTap: _send,
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

/// Animated send button — same visual behavior as ChatComposer's.
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
