import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'widgets/add_note_dialog.dart';
import 'widgets/assign_thread_sheet.dart';
import 'widgets/audio_bubble.dart';
import 'widgets/chat_composer.dart';
import 'widgets/media_open_bubble.dart';
import 'widgets/message_actions_sheet.dart';
import 'widgets/sender_thread_bar.dart';
import 'widgets/template_bubble.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.clientId,
    this.highlightMessageId,
  });

  final String clientId;

  /// Deep-link target (`/chats/:clientId?messageId=…` from reminder/note
  /// notifications): after the thread loads, scroll to this message and
  /// briefly highlight it instead of jumping to the bottom.
  final String? highlightMessageId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _scroll = ScrollController();
  bool _didInitialScroll = false;

  // ── Deep-link scroll + highlight ────────────────────────────────────
  /// The message the screen was deep-linked to; keys its row while set so
  /// [Scrollable.ensureVisible] can find it. Cleared once the highlight fades
  /// (or the message can't be reached).
  String? _highlightAnchorId;

  /// Whether the highlight tint is currently shown (fades in/out via the
  /// row's AnimatedContainer).
  bool _highlightOn = false;

  /// The deep-link flow runs once, on the first loaded thread scope.
  bool _highlightHandled = false;

  final GlobalKey _highlightKey = GlobalKey();
  Timer? _highlightFadeTimer;
  Timer? _highlightClearTimer;

  /// The user's explicit tab choice; null until they pick one, in which case
  /// the most recent conversation sender (or the tenant default) wins.
  String? _selectedSenderId;

  /// Resolved thread scope the scroll listener reads; null until the sender
  /// lookups settle so the first thread fetch is already correctly scoped.
  ThreadKey? _threadKey;

  @override
  void initState() {
    super.initState();
    _highlightAnchorId = widget.highlightMessageId;
    _scroll.addListener(() {
      final key = _threadKey;
      if (key != null && _scroll.position.pixels <= 80) {
        ref.read(threadControllerProvider(key).notifier).loadOlder();
      }
    });
  }

  @override
  void dispose() {
    _highlightFadeTimer?.cancel();
    _highlightClearTimer?.cancel();
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
      // A deep-linked message replaces the usual jump-to-bottom with a
      // scroll-to-message + highlight (once, on the first loaded scope).
      if (_highlightAnchorId != null && !_highlightHandled) {
        _highlightHandled = true;
        _startHighlightFlow();
      } else {
        _scrollToBottom();
      }
    }
  }

  /// Locates the deep-linked message — paging older history in as needed —
  /// then scrolls to it and pulses the highlight tint.
  Future<void> _startHighlightFlow() async {
    final key = _threadKey;
    final id = _highlightAnchorId;
    if (key == null || id == null) return;

    void abandon({bool tooFar = false}) {
      if (!mounted) return;
      setState(() => _highlightAnchorId = null);
      if (tooFar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).messageTooFarBack),
          ),
        );
      }
      _scrollToBottom();
    }

    // Ask the API which page holds the message so a very deep target is
    // declined up front instead of paging 15 times for nothing.
    try {
      final page = await ref
          .read(messagesRepoProvider)
          .messagePage(key.clientId, id);
      if (page > 15) {
        abandon(tooFar: true);
        return;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Unknown message (deleted, or another client's) — nothing to jump to.
        abandon();
        return;
      }
      // Transient failure — fall through and let the paging loop try.
    } catch (_) {}
    if (!mounted) return;

    final controller = ref.read(threadControllerProvider(key).notifier);
    var state = ref.read(threadControllerProvider(key));
    var iterations = 0;
    while (!state.messages.any((m) => m.id == id) &&
        state.hasOlder &&
        iterations < 15) {
      await controller.loadOlder();
      if (!mounted) return;
      state = ref.read(threadControllerProvider(key));
      iterations++;
    }

    if (!state.messages.any((m) => m.id == id)) {
      abandon(tooFar: state.hasOlder);
      return;
    }

    setState(() => _highlightOn = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToMessage(id));
    _highlightFadeTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _highlightOn = false);
      _highlightClearTimer = Timer(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _highlightAnchorId = null);
      });
    });
  }

  /// Brings the keyed row on screen. The ListView builds lazily, so when the
  /// row isn't built yet, jump to an estimated offset and retry next frame
  /// (up to ~20 frames) until [Scrollable.ensureVisible] can take over.
  void _scrollToMessage(String id, [int attempt = 0]) {
    if (!mounted) return;
    final ctx = _highlightKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.4,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      return;
    }
    final key = _threadKey;
    if (attempt >= 20 || key == null || !_scroll.hasClients) return;
    final messages = ref.read(threadControllerProvider(key)).messages;
    final index = messages.indexWhere((m) => m.id == id);
    if (index < 0) return;
    final max = _scroll.position.maxScrollExtent;
    final estimate = messages.length <= 1
        ? 0.0
        : (index / (messages.length - 1)) * max;
    _scroll.jumpTo(estimate.clamp(0.0, max));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToMessage(id, attempt + 1),
    );
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
        // Tapping the header opens the full contact profile.
        title: InkWell(
          onTap: () => context.push('/clients/${widget.clientId}'),
          child: Row(
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
        actions: [if (threadKey != null) ..._threadActions(context, threadKey)],
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

  /// App-bar actions that operate on the Team Inbox thread behind this chat
  /// (internal note + assign to team member). They only appear once that
  /// thread resolves (a chat with no messages has no thread to act on).
  List<Widget> _threadActions(BuildContext context, ThreadKey threadKey) {
    final thread = ref.watch(chatInboxThreadProvider(threadKey)).asData?.value;
    if (thread == null) return const [];
    return [
      IconButton(
        tooltip: AppLocalizations.of(context).inboxAddNote,
        icon: const Icon(Icons.sticky_note_2_outlined),
        onPressed: () => showAddNoteDialog(context, ref, thread),
      ),
      IconButton(
        tooltip: AppLocalizations.of(context).chatAssign,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        onPressed: () => showAssignThreadSheet(context, ref, thread),
      ),
    ];
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
        if (row.isHeader) return _DayHeader(label: row.headerLabel!);
        final message = row.message!;
        final bubble = _MessageBubble(
          message: message,
          threadKey: threadKey,
          showSentBy: row.showSentBy,
        );
        if (message.id != _highlightAnchorId) return bubble;
        // Deep-link target: keyed so ensureVisible can find it, wrapped in a
        // tint that fades in for ~2.5s and back out.
        return KeyedSubtree(
          key: _highlightKey,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: _highlightOn
                  ? context.scheme.primary.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: bubble,
          ),
        );
      },
    );
  }

  List<_Row> _buildRows(BuildContext context, List<Message> messages) {
    final rows = <_Row>[];
    DateTime? lastDay;
    for (var i = 0; i < messages.length; i++) {
      final m = messages[i];
      final d = m.createdAtDate;
      final day = DateTime(d.year, d.month, d.day);
      if (lastDay == null || day != lastDay) {
        rows.add(_Row.header(Fmt.dayHeader(context, day)));
        lastDay = day;
      }
      // "Sent by …" attribution shows once per consecutive outbound run from
      // the same team member — under the run's last bubble (mirrors the
      // portal's MessageThread).
      final next = i + 1 < messages.length ? messages[i + 1] : null;
      final showSentBy =
          m.isOutbound &&
          (m.sentByUserName?.isNotEmpty ?? false) &&
          (next == null ||
              !next.isOutbound ||
              next.sentByUserName != m.sentByUserName);
      rows.add(_Row.message(m, showSentBy: showSentBy));
    }
    return rows;
  }
}

class _Row {
  _Row.header(this.headerLabel)
    : isHeader = true,
      message = null,
      showSentBy = false;
  _Row.message(this.message, {required this.showSentBy})
    : isHeader = false,
      headerLabel = null;

  final bool isHeader;
  final String? headerLabel;
  final Message? message;
  final bool showSentBy;
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
  const _MessageBubble({
    required this.message,
    required this.threadKey,
    this.showSentBy = false,
  });
  final Message message;
  final ThreadKey threadKey;

  /// Render the "Sent by `<team member>`" attribution under this bubble —
  /// true only on the last bubble of a member's consecutive outbound run.
  final bool showSentBy;

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

    final aligned = Align(
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

    if (!showSentBy) return aligned;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        aligned,
        Align(
          // Physical right, same side as the outbound bubble.
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: Insets.md,
              left: Insets.md,
              bottom: 6,
            ),
            child: _SentByLabel(name: message.sentByUserName!),
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, Color textColor) {
    if (message.isDeleted) {
      // Tombstone placeholder — mirrors the portal's deleted bubble.
      final muted = textColor.withValues(alpha: 0.7);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block_rounded, size: 15, color: muted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              AppLocalizations.of(context).messageDeleted,
              style: TextStyle(
                color: muted,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    final repo = ref.read(messagesRepoProvider);
    final headers = ref.watch(mediaHeadersProvider);
    final url = repo.mediaUrl(message.id);

    switch (message.messageType) {
      case MessageType.image:
      case MessageType.sticker:
        return _ImageContent(
          url: url,
          headers: headers,
          // Authored caption only — never the '[Image]' placeholder body.
          caption: message.mediaCaption ?? '',
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
        return VideoBubble(message: message, textColor: textColor);
      case MessageType.document:
        return DocumentBubble(message: message, textColor: textColor);
      case MessageType.location:
        return _LocationContent(message: message, textColor: textColor);
      case MessageType.contacts:
        return _ContactsContent(message: message, textColor: textColor);
      case MessageType.interactive:
        if (message.isFlowResponse) {
          return _FlowResponseContent(message: message, textColor: textColor);
        }
        return _bodyText(textColor);
      case MessageType.template:
        // Rich template rendering (header media, footer, buttons, carousel);
        // falls back internally to the plain body for legacy/external rows.
        return TemplateMessageContent(message: message, textColor: textColor);
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

/// "Sent by `<team member>`" attribution under the last bubble of a member's
/// consecutive outbound run — mirrors the portal's ChatBubble (Facebook
/// Business Inbox style). Tapping the help icon explains it's team-only.
class _SentByLabel extends StatelessWidget {
  const _SentByLabel({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final muted = context.scheme.onSurfaceVariant;
    final base = TextStyle(color: muted, fontSize: 11);

    // The localized template embeds the name ("Sent by {name}" /
    // "أُرسلت بواسطة {name}"); bold just the name span within it.
    final full = l10n.chatSentBy(name);
    final idx = full.indexOf(name);
    final span = idx < 0
        ? TextSpan(text: full, style: base)
        : TextSpan(
            style: base,
            children: [
              TextSpan(text: full.substring(0, idx)),
              TextSpan(
                text: name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: full.substring(idx + name.length)),
            ],
          );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text.rich(span, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: l10n.chatSentByHint,
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(Icons.help_outline_rounded, size: 13, color: muted),
        ),
      ],
    );
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

/// Shared-contact card(s) on an inbound `contacts` message — mirrors the
/// portal's ContactsMessage: a WhatsApp-style card (avatar, name, first
/// phone) with a "View contact" affordance opening the full details, where
/// tapping a phone number copies it.
class _ContactsContent extends StatelessWidget {
  const _ContactsContent({required this.message, required this.textColor});
  final Message message;
  final Color textColor;

  static List<Map<String, dynamic>> _phones(Map<String, dynamic> c) {
    final phones = c['phones'];
    if (phones is! List) return const [];
    return phones
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .where((p) => p['phone'] is String && (p['phone'] as String).isNotEmpty)
        .toList();
  }

  static List<String> _emails(Map<String, dynamic> c) {
    final emails = c['emails'];
    if (emails is! List) return const [];
    return emails
        .whereType<Map>()
        .map((e) => e['email'])
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String _displayName(Map<String, dynamic> c, String fallback) {
    final name = c['name'];
    if (name is Map) {
      final formatted = name['formatted_name'];
      if (formatted is String && formatted.trim().isNotEmpty) {
        return formatted.trim();
      }
      final assembled = [name['first_name'], name['last_name']]
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .join(' ');
      if (assembled.isNotEmpty) return assembled;
    }
    final phones = _phones(c);
    if (phones.isNotEmpty) return phones.first['phone'] as String;
    return fallback;
  }

  static String? _orgLine(Map<String, dynamic> c) {
    final org = c['org'];
    if (org is! Map) return null;
    final line = [org['title'], org['company']]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' — ');
    return line.isEmpty ? null : line;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contacts = message.sharedContacts;

    // No structured cards anywhere (odd legacy row) — plain placeholder body.
    if (contacts.isEmpty) {
      return Text(
        message.body.isEmpty ? '👤 ${l10n.previewContact}' : message.body,
        textDirection: Fmt.textDirectionFor(message.body),
        style: TextStyle(color: textColor, fontSize: 15, height: 1.35),
      );
    }

    final firstName = _displayName(contacts.first, l10n.previewContact);
    final title = contacts.length == 1
        ? firstName
        : l10n.contactAndOthers(firstName, contacts.length - 1);
    final phones = _phones(contacts.first);
    final subtitle = phones.isEmpty ? null : phones.first['phone'] as String;

    return GestureDetector(
      onTap: () => _showDetails(context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: textColor, size: 24),
              ),
              const SizedBox(width: Insets.md),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textDirection: Fmt.textDirectionFor(title),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.sm),
          Container(height: 1, color: textColor.withValues(alpha: 0.12)),
          const SizedBox(height: Insets.sm),
          Center(
            child: Text(
              contacts.length == 1
                  ? l10n.contactViewDetails
                  : l10n.contactsViewAll,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contacts = message.sharedContacts;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.contactDetailsTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: contacts.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (_, i) => _ContactDetailsTile(contact: contacts[i]),
          ),
        ),
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

/// One contact inside the shared-contacts dialog: name, org line, phones
/// (tap to copy) and emails.
class _ContactDetailsTile extends StatelessWidget {
  const _ContactDetailsTile({required this.contact});
  final Map<String, dynamic> contact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = _ContactsContent._displayName(contact, l10n.previewContact);
    final org = _ContactsContent._orgLine(contact);
    final phones = _ContactsContent._phones(contact);
    final emails = _ContactsContent._emails(contact);
    final muted = context.scheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          textDirection: Fmt.textDirectionFor(name),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        if (org != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(org, style: TextStyle(color: muted, fontSize: 12)),
          ),
        for (final p in phones)
          Padding(
            padding: const EdgeInsets.only(top: Insets.sm),
            child: InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: p['phone'] as String),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.contactNumberCopied)),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_rounded, size: 16, color: muted),
                  const SizedBox(width: Insets.sm),
                  Text(
                    p['phone'] as String,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (p['type'] is String &&
                      (p['type'] as String).isNotEmpty) ...[
                    const SizedBox(width: Insets.sm),
                    Text(
                      p['type'] as String,
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                  const SizedBox(width: Insets.sm),
                  Icon(Icons.copy_rounded, size: 14, color: muted),
                ],
              ),
            ),
          ),
        for (final email in emails)
          Padding(
            padding: const EdgeInsets.only(top: Insets.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_rounded, size: 16, color: muted),
                const SizedBox(width: Insets.sm),
                Flexible(
                  child: Text(
                    email,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
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
