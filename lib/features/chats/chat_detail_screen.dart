import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';
import '../shared/widgets.dart';
import 'chat_providers.dart';
import 'thread_controller.dart';
import 'widgets/audio_bubble.dart';
import 'widgets/chat_composer.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key, required this.clientId});

  final String clientId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _scroll = ScrollController();
  bool _didInitialScroll = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels <= 80) {
        ref
            .read(threadControllerProvider(widget.clientId).notifier)
            .loadOlder();
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
      ref.read(lastReadStoreProvider).markRead(widget.clientId, newest);
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
    final state = ref.watch(threadControllerProvider(widget.clientId));
    final clientAsync = ref.watch(clientProvider(widget.clientId));
    final title = clientAsync.maybeWhen(
      data: (c) => c.displayName,
      orElse: () => '',
    );

    ref.listen(threadControllerProvider(widget.clientId), (_, next) {
      if (!next.loading && next.error == null) {
        _onLoaded(next.messages.isEmpty ? null : next.messages.last.createdAtDate);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/chats'),
        ),
        title: Text(title.isEmpty ? '…' : title),
      ),
      body: Column(
        children: [
          Expanded(child: _body(context, state)),
          if (clientAsync.hasValue && !state.loading)
            ChatComposer(
              clientId: widget.clientId,
              to: clientAsync.value!.phoneNumber,
              windowOpen: _windowOpen(state),
              onSent: _scrollToBottom,
            ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ThreadState state) {
    final controller =
        ref.read(threadControllerProvider(widget.clientId).notifier);
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.messages.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (state.messages.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return EmptyState(message: l10n.chatsEmpty, icon: Icons.forum_outlined);
    }

    final rows = _buildRows(context, state.messages);
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: rows.length + (state.loadingOlder ? 1 : 0),
      itemBuilder: (context, i) {
        if (state.loadingOlder && i == 0) {
          return const Padding(
            padding: EdgeInsets.all(8),
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
            : _MessageBubble(message: row.message!);
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
  _Row.header(this.headerLabel)
    : isHeader = true,
      message = null;
  _Row.message(this.message)
    : isHeader = false,
      headerLabel = null;

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
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.message});
  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = Theme.of(context).extension<ChatColors>()!;
    final outbound = message.isOutbound;
    final bubbleColor = outbound ? chat.outboundBubble : chat.inboundBubble;
    final textColor = outbound ? chat.outboundText : chat.inboundText;

    return Align(
      alignment: outbound ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(outbound ? 14 : 4),
            bottomRight: Radius.circular(outbound ? 4 : 14),
          ),
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
          icon: Icons.videocam,
          label: AppLocalizations.of(context).previewVideo,
          textColor: textColor,
        );
      case MessageType.document:
        return _IconTile(
          icon: Icons.insert_drive_file,
          label: message.body.isNotEmpty
              ? message.body
              : AppLocalizations.of(context).previewDocument,
          textColor: textColor,
        );
      case MessageType.location:
        return _LocationContent(message: message, textColor: textColor);
      default:
        return Text(
          message.body.isEmpty ? '…' : message.body,
          style: TextStyle(color: textColor, fontSize: 15),
        );
    }
  }

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
          Icon(_statusIcon(), size: 13, color: _statusColor(textColor)),
        ],
      ],
    );
  }

  IconData _statusIcon() {
    switch (message.status) {
      case MessageStatus.read:
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
      default:
        return Icons.done;
    }
  }

  Color _statusColor(Color textColor) {
    if (message.status == MessageStatus.read) return Colors.lightBlueAccent;
    if (message.status == MessageStatus.failed) return Colors.redAccent;
    return textColor.withValues(alpha: 0.6);
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
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              httpHeaders: headers,
              fit: BoxFit.cover,
              width: 220,
              placeholder: (_, _) => const SizedBox(
                width: 220,
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, _, _) => const SizedBox(
                width: 220,
                height: 120,
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
        if (caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(caption, style: TextStyle(color: textColor)),
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
                child: CachedNetworkImage(
                  imageUrl: url,
                  httpHeaders: headers,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
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
        Icon(icon, color: textColor, size: 28),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, style: TextStyle(color: textColor)),
        ),
      ],
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
    final coords = (message.locationLatitude != null &&
            message.locationLongitude != null)
        ? '${message.locationLatitude}, ${message.locationLongitude}'
        : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: textColor, size: 28),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name ?? AppLocalizations.of(context).previewLocation,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
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
