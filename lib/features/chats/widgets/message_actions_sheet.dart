import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/mime.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers.dart';
import '../../../data/models/client.dart';
import '../../../data/models/message.dart';
import '../../shared/widgets.dart';
import '../chat_providers.dart';
import '../chats_controller.dart';
import '../thread_controller.dart';

enum _MessageAction { copy, forward, share, deleteForMe, deleteForEveryone }

/// Emoji picked from the quick-reaction row; [emoji] null means "remove the
/// current reaction".
class _ReactionChoice {
  const _ReactionChoice(this.emoji);
  final String? emoji;
}

/// WhatsApp's default quick-reaction palette (mirrors the portal).
const _quickReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

/// Long-press actions for a chat bubble: react (inbound only), copy, forward,
/// share, delete (for me / for everyone).
///
/// Which actions appear depends on the message: copy/share need extractable
/// text or media; forward needs text or re-uploadable media; reacting needs
/// an inbound (client) message; deleting needs a persisted (non-optimistic)
/// row, and "delete for everyone" additionally an outbound, not-yet-deleted
/// one. A message offering none of these silently doesn't open the sheet.
Future<void> showMessageActions(
  BuildContext context,
  WidgetRef ref, {
  required Message message,
  required ThreadKey threadKey,
}) async {
  final text = _extractText(message);
  final canCopy = text != null;
  final canForward = message.hasMedia || text != null;
  final canShare = message.hasMedia || text != null;
  final canReact = !message.isOutbound && !message.isDeleted;
  // Optimistic bubbles carry a synthetic `temp_` id the API doesn't know.
  final isPersisted = !message.id.startsWith('temp_');
  final canDeleteForMe = isPersisted;
  final canDeleteForEveryone =
      isPersisted && message.isOutbound && !message.isDeleted;
  if (!canCopy &&
      !canForward &&
      !canShare &&
      !canReact &&
      !canDeleteForMe &&
      !canDeleteForEveryone) {
    return;
  }

  HapticFeedback.mediumImpact();
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final action = await showModalBottomSheet<Object>(
    context: context,
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.sm, 0, Insets.sm, Insets.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canReact)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final emoji in _quickReactions)
                      _ReactionButton(
                        emoji: emoji,
                        selected: message.reaction == emoji,
                        // Re-picking the current emoji removes it, like
                        // WhatsApp.
                        onTap: () => Navigator.pop(
                          sheetCtx,
                          _ReactionChoice(
                            message.reaction == emoji ? null : emoji,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (canCopy)
              _ActionTile(
                icon: Icons.copy_rounded,
                color: AppColors.signal,
                label: l10n.messageActionCopy,
                onTap: () => Navigator.pop(sheetCtx, _MessageAction.copy),
              ),
            if (canForward)
              _ActionTile(
                icon: Icons.forward_rounded,
                color: AppColors.lilac,
                label: l10n.messageActionForward,
                onTap: () => Navigator.pop(sheetCtx, _MessageAction.forward),
              ),
            if (canShare)
              _ActionTile(
                icon: Icons.ios_share_rounded,
                color: AppColors.amber,
                label: l10n.messageActionShare,
                onTap: () => Navigator.pop(sheetCtx, _MessageAction.share),
              ),
            if (canDeleteForMe)
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                color: AppColors.ember,
                label: l10n.messageActionDeleteForMe,
                onTap: () =>
                    Navigator.pop(sheetCtx, _MessageAction.deleteForMe),
              ),
            if (canDeleteForEveryone)
              _ActionTile(
                icon: Icons.delete_forever_rounded,
                color: AppColors.ember,
                label: l10n.messageActionDeleteForEveryone,
                onTap: () =>
                    Navigator.pop(sheetCtx, _MessageAction.deleteForEveryone),
              ),
          ],
        ),
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  if (action is _ReactionChoice) {
    final ok = await ref
        .read(threadControllerProvider(threadKey).notifier)
        .sendReaction(message.id, action.emoji);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.reactionFailed)));
    }
    return;
  }

  switch (action as _MessageAction) {
    case _MessageAction.copy:
      await Clipboard.setData(ClipboardData(text: text!));
      messenger.showSnackBar(SnackBar(content: Text(l10n.messageCopied)));
    case _MessageAction.share:
      await _share(ref, messenger, l10n, message, text);
    case _MessageAction.forward:
      final client = await showModalBottomSheet<Client>(
        context: context,
        isScrollControlled: true,
        builder: (_) =>
            _ForwardClientSheet(excludeClientId: threadKey.clientId),
      );
      if (client == null) return;
      await _forward(ref, messenger, l10n, message, text, threadKey, client);
    case _MessageAction.deleteForMe:
    case _MessageAction.deleteForEveryone:
      final forEveryone = action == _MessageAction.deleteForEveryone;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text(l10n.deleteMessageTitle),
          content: Text(
            forEveryone
                ? l10n.deleteForEveryoneConfirm
                : l10n.deleteForMeConfirm,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.ember),
              child: Text(l10n.deleteConfirmAction),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      final controller = ref.read(
        threadControllerProvider(threadKey).notifier,
      );
      final ok = forEveryone
          ? await controller.deleteForEveryone(message.id)
          : await controller.deleteForMe(message.id);
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.deleteMessageFailed)),
        );
      }
  }
}

/// Text worth copying/sharing/forwarding, or null when the message has none.
///
/// For media messages this is the user-authored caption (or the voice-note
/// transcription) — never the server's `[Image]`/`[Document: …]` placeholder
/// body, which is a UI marker rather than content.
String? _extractText(Message m) {
  if (m.isDeleted || m.isFlowResponse) return null;
  if (m.messageType == MessageType.location) {
    final coords = (m.locationLatitude != null && m.locationLongitude != null)
        ? '${m.locationLatitude}, ${m.locationLongitude}'
        : null;
    final parts = [
      m.locationName,
      m.locationAddress,
      coords,
    ].whereType<String>().where((p) => p.trim().isNotEmpty).toList();
    return parts.isEmpty ? null : parts.join('\n');
  }
  if (m.hasMedia) {
    final caption = m.mediaCaption;
    if (caption != null) return caption;
    if (m.transcriptionReady &&
        (m.transcription?.trim().isNotEmpty ?? false)) {
      return m.transcription;
    }
    return null;
  }
  if (m.body.trim().isNotEmpty) return m.body;
  return null;
}

Future<void> _share(
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
  Message message,
  String? text,
) async {
  try {
    if (message.hasMedia) {
      final bytes = await _downloadMedia(ref, message);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: message.mediaMimeType ?? 'application/octet-stream',
              name: _mediaFilename(message),
            ),
          ],
          // Caption only — never the '[Document: …]' placeholder body.
          text: text,
        ),
      );
    } else {
      await SharePlus.instance.share(ShareParams(text: text!));
    }
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
  }
}

Future<void> _forward(
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
  Message message,
  String? text,
  ThreadKey threadKey,
  Client client,
) async {
  final repo = ref.read(messagesRepoProvider);
  try {
    if (message.hasMedia) {
      final bytes = await _downloadMedia(ref, message);
      final dir = await Directory.systemTemp.createTemp('forward');
      // Keep the original document filename — the recipient sees it. The
      // caption is the authored one only; forwarding the '[Video]' /
      // '[Document: …]' placeholder body would send it as literal text.
      final filename = _mediaFilename(message);
      final file = File('${dir.path}/$filename');
      try {
        await file.writeAsBytes(bytes);
        await repo.sendMedia(
          to: client.phoneNumber,
          mediaType: _mediaTypeOf(message.messageType),
          filePath: file.path,
          caption: message.mediaCaption,
          filename: filename,
          senderId: threadKey.senderId,
        );
      } finally {
        await dir.delete(recursive: true).catchError((_) => dir);
      }
    } else {
      await repo.sendText(
        to: client.phoneNumber,
        body: text!,
        senderId: threadKey.senderId,
      );
    }
    // Bump the target conversation to the top of the chats list.
    ref.read(chatsControllerProvider.notifier).refresh();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.forwardSent(client.displayName))),
    );
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.forwardFailed)));
  }
}

Future<Uint8List> _downloadMedia(WidgetRef ref, Message message) async {
  final url = ref.read(messagesRepoProvider).mediaUrl(message.id);
  final bytes = await ref.read(mediaBytesLoaderProvider)(url);
  if (bytes == null) throw Exception('media download failed');
  return bytes;
}

/// Filename to share/forward the media under. Documents keep their original
/// name when the row carries one (`[Document: name.pdf]` body); everything
/// else gets a type-named file with an extension derived from the MIME type.
String _mediaFilename(Message m) {
  final docName = m.documentFilename;
  if (docName != null && docName.isNotEmpty) {
    // Strip path separators so the name stays a plain filename.
    return docName.replaceAll(RegExp(r'[/\\]'), '_');
  }
  return '${_mediaTypeOf(m.messageType)}.${extensionForMime(m.mediaMimeType)}';
}

/// `mediaType` accepted by `POST /messages/send-media`.
String _mediaTypeOf(MessageType type) {
  switch (type) {
    case MessageType.image:
    case MessageType.sticker:
      return 'image';
    case MessageType.audio:
      return 'audio';
    case MessageType.video:
      return 'video';
    default:
      return 'document';
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: selected
            ? const BoxDecoration(
                color: AppColors.signalTint,
                shape: BoxShape.circle,
              )
            : null,
        child: Text(emoji, style: AppTheme.emojiStyle(fontSize: 26)),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
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

/// Searchable client picker for forwarding; pops with the chosen [Client].
class _ForwardClientSheet extends ConsumerStatefulWidget {
  const _ForwardClientSheet({required this.excludeClientId});

  final String excludeClientId;

  @override
  ConsumerState<_ForwardClientSheet> createState() =>
      _ForwardClientSheetState();
}

class _ForwardClientSheetState extends ConsumerState<_ForwardClientSheet> {
  List<Client> _clients = const [];
  bool _loading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _load(query));
  }

  Future<void> _load(String query) async {
    setState(() => _loading = true);
    try {
      final page = await ref
          .read(clientsRepoProvider)
          .list(search: query, limit: 50);
      if (!mounted) return;
      setState(() {
        _clients = page.data
            .where((c) => c.id != widget.excludeClientId)
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _clients = const [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.lg,
                  Insets.lg,
                  Insets.lg,
                  Insets.sm,
                ),
                child: Text(l10n.forwardTitle, style: context.text.titleMedium),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
                child: TextField(
                  autofocus: false,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: l10n.searchClients,
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: Insets.sm),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _clients.isEmpty
                    ? EmptyState(
                        message: l10n.clientsEmpty,
                        icon: Icons.person_search_rounded,
                      )
                    : ListView.builder(
                        itemCount: _clients.length,
                        itemBuilder: (context, i) {
                          final c = _clients[i];
                          return ListTile(
                            onTap: () => Navigator.pop(context, c),
                            leading: InitialsAvatar(
                              initials: c.initials,
                              radius: 20,
                            ),
                            title: Text(c.displayName),
                            subtitle: Text('+${c.phoneNumber}'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
