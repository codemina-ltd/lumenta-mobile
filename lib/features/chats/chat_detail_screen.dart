import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/conversation_sender.dart';
import '../../data/models/message.dart';
import '../../data/models/sender.dart';
import '../../data/storage/last_read_store.dart';
import '../shared/widgets.dart';
import 'chat_providers.dart';
import 'thread_controller.dart';
import 'widgets/audio_bubble.dart';
import 'widgets/chat_composer.dart';
import 'widgets/message_actions_sheet.dart';
import 'widgets/sender_thread_bar.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key, required this.clientId});

  final String clientId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _scroll = ScrollController();
  bool _didInitialScroll = false;

  /// The user's explicit tab choice; null until they pick one, in which case
  /// the most recent conversation sender (or the tenant default) wins.
  String? _selectedSenderId;

  /// Resolved thread scope the scroll listener reads; null until the sender
  /// lookups settle so the first thread fetch is already correctly scoped.
  ThreadKey? _threadKey;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final key = _threadKey;
      if (key != null && _scroll.position.pixels <= 80) {
        ref.read(threadControllerProvider(key).notifier).loadOlder();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onLoaded(DateTime? newest) {
    // Clear unread for this chat.
    if (newest != null) {
      ref
          .read(lastReadStoreProvider.notifier)
          .markRead(widget.clientId, newest);
    }
    if (!_didInitialScroll) {
      _didInitialScroll = true;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  /// WhatsApp free-form replies are only allowed within 24h of the last inbound.
  bool _windowOpen(ThreadState state) {
    for (final m in state.messages.reversed) {
      if (m.direction == MessageDirection.inbound) {
        return DateTime.now().difference(m.createdAtDate).inHours < 24;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final clientAsync = ref.watch(clientProvider(widget.clientId));

    // ── Per-sender threads ──────────────────────────────────────────────
    // Which senders have history with this client (tab list) + all tenant
    // senders (composer binding, "Start via…"). If either lookup fails, fall
    // back to the merged thread with no tab bar — pre-sender-threads
    // behaviour. The hidden-bar case also keeps the thread merged so legacy
    // rows without sender attribution stay visible.
    final convAsync = ref.watch(conversationSendersProvider(widget.clientId));
    final sendersAsync = ref.watch(tenantSendersProvider);
    final sendersReady =
        (convAsync.hasValue || convAsync.hasError) &&
        (sendersAsync.hasValue || sendersAsync.hasError);
    final convSenders = convAsync.value ?? const <ConversationSender>[];
    final senders = sendersAsync.value ?? const <Sender>[];
    final showTabs =
        sendersReady && (convSenders.length > 1 || senders.length > 1);

    String? activeSenderId;
    if (showTabs) {
      final selected = _selectedSenderId;
      activeSenderId =
          (selected != null &&
              (senders.any((s) => s.id == selected) ||
                  convSenders.any((c) => c.senderId == selected)))
          ? selected
          : convSenders.firstOrNull?.senderId ??
                senders.where((s) => s.isDefault).firstOrNull?.id ??
                senders.firstOrNull?.id;
    }
    final activeSender = senders
        .where((s) => s.id == activeSenderId)
        .firstOrNull;
    final activeConv = convSenders
        .where((c) => c.senderId == activeSenderId)
        .firstOrNull;

    final threadKey = sendersReady
        ? (clientId: widget.clientId, senderId: activeSenderId)
        : null;
    if (threadKey != _threadKey) {
      // Scope changed (tab click or initial resolution): re-run the
      // scroll-to-bottom on the freshly loaded thread.
      _threadKey = threadKey;
      _didInitialScroll = false;
    }

    final state = threadKey == null
        ? const ThreadState()
        : ref.watch(threadControllerProvider(threadKey));
    final title = clientAsync.maybeWhen(
      data: (c) => c.displayName,
      orElse: () => '',
    );
    final initials = clientAsync.maybeWhen(
      data: (c) => c.initials,
      orElse: () => '',
    );
    final phone = clientAsync.maybeWhen(
      data: (c) => '+${c.phoneNumber}',
      orElse: () => null,
    );

    if (threadKey != null) {
      ref.listen(threadControllerProvider(threadKey), (_, next) {
        if (!next.loading && next.error == null) {
          _onLoaded(
            next.messages.isEmpty ? null : next.messages.last.createdAtDate,
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/chats'),
        ),
        title: Row(
          children: [
            if (initials.isNotEmpty)
              InitialsAvatar(initials: initials, radius: 18),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.isEmpty ? '…' : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium?.copyWith(fontSize: 17),
                  ),
                  if (phone != null)
                    Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelSmall?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (showTabs)
            SenderThreadBar(
              conversationSenders: convSenders,
              senders: senders,
              activeSenderId: activeSenderId,
              onSelect: (id) => setState(() => _selectedSenderId = id),
            ),
          Expanded(
            child: threadKey == null
                ? const Center(child: CircularProgressIndicator())
                : _body(context, state, threadKey),
          ),
          if (clientAsync.hasValue && threadKey != null && !state.loading)
            ChatComposer(
              threadKey: threadKey,
              to: clientAsync.value!.phoneNumber,
              windowOpen: _windowOpen(state),
              onSent: _scrollToBottom,
              senderLabel: showTabs
                  ? (activeSender?.label ?? activeConv?.label)
                  : null,
              senderNumber: showTabs
                  ? (activeSender?.number ?? activeConv?.displayPhoneNumber)
                  : null,
              senderActive:
                  !showTabs ||
                  (activeSender?.isActive ?? activeConv?.isActive ?? true),
            ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ThreadState state, ThreadKey threadKey) {
    final controller = ref.read(threadControllerProvider(threadKey).notifier);
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.messages.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (state.messages.isEmpty) {
      final l10n = AppLocalizations.of(context);
      // A sender-scoped empty thread is a "start the conversation via this
      // number" state, not a generic no-chats state.
      return EmptyState(
        message: threadKey.senderId != null
            ? l10n.senderNoHistory
            : l10n.chatsEmpty,
        icon: Icons.forum_outlined,
      );
    }

    final rows = _buildRows(context, state.messages);
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(
        vertical: Insets.md,
        horizontal: Insets.xs,
      ),
      itemCount: rows.length + (state.loadingOlder ? 1 : 0),
      itemBuilder: (context, i) {
        if (state.loadingOlder && i == 0) {
          return const Padding(
            padding: EdgeInsets.all(Insets.sm),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final row = rows[i - (state.loadingOlder ? 1 : 0)];
        return row.isHeader
            ? _DayHeader(label: row.headerLabel!)
            : _MessageBubble(message: row.message!, threadKey: threadKey);
      },
    );
  }

  List<_Row> _buildRows(BuildContext context, List<Message> messages) {
    final rows = <_Row>[];
    DateTime? lastDay;
    for (final m in messages) {
      final d = m.createdAtDate;
      final day = DateTime(d.year, d.month, d.day);
      if (lastDay == null || day != lastDay) {
        rows.add(_Row.header(Fmt.dayHeader(context, day)));
        lastDay = day;
      }
      rows.add(_Row.message(m));
    }
    return rows;
  }
}

class _Row {
  _Row.header(this.headerLabel) : isHeader = true, message = null;
  _Row.message(this.message) : isHeader = false, headerLabel = null;

  final bool isHeader;
  final String? headerLabel;
  final Message? message;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Insets.md),
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 5),
        decoration: BoxDecoration(
          color: context.scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Text(
          label,
          style: context.text.labelSmall?.copyWith(
            color: context.scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.message, required this.threadKey});
  final Message message;
  final ThreadKey threadKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = context.chat;
    final outbound = message.isOutbound;
    final bubbleColor = outbound ? chat.outboundBubble : chat.inboundBubble;
    final textColor = outbound ? chat.outboundText : chat.inboundText;
    final isLight = context.scheme.brightness == Brightness.light;

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      margin: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 3),
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, 6),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(Radii.md),
          topRight: const Radius.circular(Radii.md),
          bottomLeft: Radius.circular(outbound ? Radii.md : 4),
          bottomRight: Radius.circular(outbound ? 4 : Radii.md),
        ),
        border: (!outbound && isLight)
            ? Border.all(color: AppColors.hairline)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.deepForest.withValues(
              alpha: isLight ? 0.05 : 0.18,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _content(context, ref, textColor),
          const SizedBox(height: 2),
          _meta(context, textColor, outbound),
        ],
      ),
    );

    return Align(
      alignment: outbound ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => showMessageActions(
          context,
          ref,
          message: message,
          threadKey: threadKey,
        ),
        child: message.hasReaction
            // Reaction pill overlaps the bubble's bottom corner (mirrors the
            // portal's ChatBubble): the bubble reserves extra space below and
            // the pill hangs into it.
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: bubble,
                  ),
                  // Physical right, like the portal pins the pill at right: 8
                  // regardless of writing direction.
                  Positioned(
                    bottom: 0,
                    right: Insets.md + Insets.sm,
                    child: _ReactionPill(reaction: message.reaction!),
                  ),
                ],
              )
            : bubble,
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, Color textColor) {
    final repo = ref.read(messagesRepoProvider);
    final headers = ref.watch(mediaHeadersProvider);
    final url = repo.mediaUrl(message.id);

    switch (message.messageType) {
      case MessageType.image:
      case MessageType.sticker:
        return _ImageContent(
          url: url,
          headers: headers,
          caption: message.body,
          textColor: textColor,
        );
      case MessageType.audio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AudioBubble(
              color: textColor,
              mimeType: message.mediaMimeType,
              loadBytes: () => ref.read(mediaBytesLoaderProvider)(url),
            ),
            if (message.transcriptionReady &&
                (message.transcription?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  message.transcription!,
                  textDirection: Fmt.textDirectionFor(message.transcription!),
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.85),
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        );
      case MessageType.video:
        return _IconTile(
          icon: Icons.videocam_rounded,
          label: AppLocalizations.of(context).previewVideo,
          textColor: textColor,
        );
      case MessageType.document:
        return _IconTile(
          icon: Icons.insert_drive_file_rounded,
          label: message.body.isNotEmpty
              ? message.body
              : AppLocalizations.of(context).previewDocument,
          textColor: textColor,
        );
      case MessageType.location:
        return _LocationContent(message: message, textColor: textColor);
      case MessageType.interactive:
        if (message.isFlowResponse) {
          return _FlowResponseContent(message: message, textColor: textColor);
        }
        return _bodyText(textColor);
      default:
        return _bodyText(textColor);
    }
  }

  Widget _bodyText(Color textColor) => Text(
    message.body.isEmpty ? '…' : message.body,
    textDirection: Fmt.textDirectionFor(message.body),
    style: TextStyle(color: textColor, fontSize: 15, height: 1.35),
  );

  Widget _meta(BuildContext context, Color textColor, bool outbound) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Fmt.timeOfDay(context, message.createdAtDate),
          style: TextStyle(
            color: textColor.withValues(alpha: 0.6),
            fontSize: 10,
          ),
        ),
        if (outbound) ...[
          const SizedBox(width: 4),
          Icon(_statusIcon(), size: 14, color: _statusColor(textColor)),
        ],
      ],
    );
  }

  IconData _statusIcon() {
    switch (message.status) {
      case MessageStatus.read:
      case MessageStatus.delivered:
        return Icons.done_all_rounded;
      case MessageStatus.failed:
        return Icons.error_outline_rounded;
      default:
        return Icons.done_rounded;
    }
  }

  Color _statusColor(Color textColor) {
    if (message.status == MessageStatus.read) return AppColors.lilac;
    if (message.status == MessageStatus.failed) return AppColors.ember;
    return textColor.withValues(alpha: 0.6);
  }
}

/// Customer's emoji reaction, floated over the bubble's bottom corner —
/// mirrors the portal's ChatBubble reaction chip.
class _ReactionPill extends StatelessWidget {
  const _ReactionPill({required this.reaction});
  final String reaction;

  @override
  Widget build(BuildContext context) {
    final isLight = context.scheme.brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : context.scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: isLight ? Border.all(color: AppColors.hairline) : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.deepForest.withValues(alpha: isLight ? 0.12 : 0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        reaction,
        style: AppTheme.emojiStyle(fontSize: 15).copyWith(height: 1.2),
      ),
    );
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent({
    required this.url,
    required this.headers,
    required this.caption,
    required this.textColor,
  });

  final String url;
  final Map<String, String> headers;
  final String caption;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _openZoom(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.sm),
            child: CachedNetworkImage(
              imageUrl: url,
              httpHeaders: headers,
              fit: BoxFit.cover,
              width: 230,
              placeholder: (_, _) => Container(
                width: 230,
                height: 160,
                color: Colors.black.withValues(alpha: 0.05),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, _, _) => const SizedBox(
                width: 230,
                height: 120,
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
        if (caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              caption,
              textDirection: Fmt.textDirectionFor(caption),
              style: TextStyle(color: textColor, height: 1.35),
            ),
          ),
      ],
    );
  }

  void _openZoom(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(imageUrl: url, httpHeaders: headers),
              ),
            ),
            Positioned(
              top: 40,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.label,
    required this.textColor,
  });
  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.sm),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Icon(icon, color: textColor, size: 24),
        ),
        const SizedBox(width: Insets.md),
        Flexible(
          child: Text(
            label,
            textDirection: Fmt.textDirectionFor(label),
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}

/// Inbound WhatsApp Flow response — a tappable "Response received" card that
/// opens the submitted form fields in a dialog. Mirrors the portal's
/// `ChatBubble` inbound-interactive branch + "Customer Response Details" modal.
class _FlowResponseContent extends StatelessWidget {
  const _FlowResponseContent({required this.message, required this.textColor});
  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = message.flowName ?? l10n.flowResponseTitle;
    return GestureDetector(
      onTap: () => _showDetails(context),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.signalTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.signalDeep,
              size: 22,
            ),
          ),
          const SizedBox(width: Insets.md),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.flowResponseReceived,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.flowResponseDetailsTitle),
        content: _FlowResponseTable(fields: message.flowResponseFields),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

/// Renders the submitted flow fields as a bordered Field/Value table.
class _FlowResponseTable extends StatelessWidget {
  const _FlowResponseTable({required this.fields});
  final Map<String, dynamic> fields;

  static String _label(String key) =>
      key.isEmpty ? key : key[0].toUpperCase() + key.substring(1);

  static String _value(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map || value is List) return jsonEncode(value);
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final border = TableBorder.all(color: AppColors.hairline);
    final entries = fields.entries.toList();
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Table(
          border: border,
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.6),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: context.scheme.surfaceContainerHigh,
              ),
              children: [
                _HeaderCell(l10n.flowFieldColumn),
                _HeaderCell(l10n.flowValueColumn),
              ],
            ),
            for (final e in entries)
              TableRow(
                children: [
                  _Cell(_label(e.key), bold: true),
                  _Cell(_value(e.value)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Text(
        text,
        style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {this.bold = false});
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Text(
        text,
        style: context.text.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _LocationContent extends StatelessWidget {
  const _LocationContent({required this.message, required this.textColor});
  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final name = message.locationName ?? message.locationAddress;
    final coords =
        (message.locationLatitude != null && message.locationLongitude != null)
        ? '${message.locationLatitude}, ${message.locationLongitude}'
        : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.sm),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Icon(Icons.location_on_rounded, color: textColor, size: 24),
        ),
        const SizedBox(width: Insets.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name ?? AppLocalizations.of(context).previewLocation,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              if (coords != null)
                Text(
                  coords,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
