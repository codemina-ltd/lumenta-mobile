import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'chat_list_logic.dart';
import 'chats_controller.dart';
import 'message_preview.dart';
import 'widgets/channel_indicator.dart';

/// The active top filter on the chats tab. Lives outside the screen so the
/// shell (and tests) can read it; the screen owns the chips that set it.
class ChatFilterNotifier extends Notifier<ChatFilter> {
  @override
  ChatFilter build() => ChatFilter.all;

  void set(ChatFilter filter) => state = filter;
}

final chatFilterProvider = NotifierProvider<ChatFilterNotifier, ChatFilter>(
  ChatFilterNotifier.new,
);

/// WhatsApp-style chats tab: All / Unread filter (server-side), pinned chats
/// on top, unread counts, delivery ticks; swipe or long-press a row to pin /
/// mark read. Pins and read cursors are per member and follow them across
/// devices.
class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
        ref
            .read(
              chatsControllerProvider(ref.read(chatFilterProvider)).notifier,
            )
            .loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  ChatsController get _active =>
      ref.read(chatsControllerProvider(ref.read(chatFilterProvider)).notifier);

  Future<void> _togglePin(Conversation conv) async {
    HapticFeedback.mediumImpact();
    final ok = await _active.togglePin(conv.clientId);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).inboxActionFailed),
          ),
        );
    }
  }

  Future<void> _markRead(Conversation conv) =>
      _active.markRead([conv.clientId]);

  Future<void> _showActions(Conversation conv, bool unread) async {
    final l10n = AppLocalizations.of(context);
    final pinned = conv.isPinned;
    HapticFeedback.selectionClick();
    final action = await showModalBottomSheet<_RowAction>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: InitialsAvatar(initials: conv.initials, radius: 20),
              title: Text(
                conv.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: conv.phoneNumber == null
                  ? null
                  : Text('+${conv.phoneNumber}'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                pinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
              ),
              title: Text(pinned ? l10n.chatsUnpin : l10n.chatsPin),
              onTap: () => Navigator.pop(sheetContext, _RowAction.pin),
            ),
            if (unread)
              ListTile(
                leading: const Icon(Icons.mark_chat_read_outlined),
                title: Text(l10n.chatsMarkRead),
                onTap: () => Navigator.pop(sheetContext, _RowAction.markRead),
              ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.chatsOpenProfile),
              onTap: () => Navigator.pop(sheetContext, _RowAction.profile),
            ),
            const SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _RowAction.pin:
        await _togglePin(conv);
      case _RowAction.markRead:
        await _markRead(conv);
      case _RowAction.profile:
        context.push('/clients/${conv.clientId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(chatFilterProvider);
    final state = ref.watch(chatsControllerProvider(filter));
    final controller = ref.read(chatsControllerProvider(filter).notifier);
    // The All list stays warm for its server-wide unread total (the chip).
    final allState = ref.watch(chatsControllerProvider(ChatFilter.all));
    final lastRead = ref.watch(lastReadStoreProvider);

    final unreadTotal =
        allState.unreadConversations ??
        state.unreadConversations ??
        countUnread(allState.items, lastRead);
    final rows = arrangeConversations(
      state.items,
      lastRead: lastRead,
      filter: filter,
    );

    return Column(
      children: [
        _FilterChips(
          filter: filter,
          unreadCount: unreadTotal,
          onChanged: (f) {
            HapticFeedback.selectionClick();
            ref.read(chatFilterProvider.notifier).set(f);
          },
        ),
        Expanded(
          child: _body(
            context,
            l10n,
            state,
            controller,
            rows,
            filter,
            lastRead,
          ),
        ),
      ],
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    ChatsState state,
    ChatsController controller,
    List<Conversation> rows,
    ChatFilter filter,
    LastReadState lastRead,
  ) {
    if (state.loading) {
      return const SkeletonList(count: 8);
    }
    if (state.endpointMissing) {
      return ErrorRetry(
        onRetry: controller.refresh,
        message:
            'Chats are not available yet — the conversations endpoint is not deployed.',
      );
    }
    if (state.error != null && state.items.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (rows.isEmpty) {
      final allCaughtUp = filter == ChatFilter.unread;
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: allCaughtUp
                  ? EmptyState(
                      title: l10n.chatsNoUnreadTitle,
                      message: l10n.chatsNoUnreadBody,
                      icon: Icons.mark_chat_read_outlined,
                    )
                  : EmptyState(
                      title: l10n.chatsEmpty,
                      message: l10n.searchClients,
                      icon: Icons.forum_outlined,
                    ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.only(bottom: Insets.lg),
        itemCount: rows.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: Insets.lg + ChatRow.avatarRadius * 2 + Insets.md,
          endIndent: Insets.lg,
          color: context.scheme.outlineVariant,
        ),
        itemBuilder: (context, i) {
          if (i >= rows.length) {
            return const Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            );
          }
          final conv = rows[i];
          final unread = conversationIsUnread(conv, lastRead);
          return _SwipeActions(
            key: ValueKey(conv.clientId),
            pinned: conv.isPinned,
            onPin: () => _togglePin(conv),
            onMore: () => _showActions(conv, unread),
            child: ChatRow(
              conversation: conv,
              unreadCount: unreadBadgeCount(conv, lastRead),
              onTap: () => context.push('/chats/${conv.clientId}'),
              onLongPress: () => _showActions(conv, unread),
            ),
          );
        },
      ),
    );
  }
}

enum _RowAction { pin, markRead, profile }

/// Horizontal swipe affordances, WhatsApp-style: start→end reveals Pin /
/// Unpin, end→start reveals More. The row never actually dismisses —
/// `confirmDismiss` runs the action and returns false so the row springs
/// back in place.
class _SwipeActions extends StatelessWidget {
  const _SwipeActions({
    super.key,
    required this.pinned,
    required this.onPin,
    required this.onMore,
    required this.child,
  });

  final bool pinned;
  final VoidCallback onPin;
  final VoidCallback onMore;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dismissible(
      key: key!,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.3,
        DismissDirection.endToStart: 0.3,
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onPin();
        } else {
          onMore();
        }
        return false;
      },
      background: _SwipeBackground(
        alignment: AlignmentDirectional.centerStart,
        color: AppColors.signalDeep,
        icon: pinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
        label: pinned ? l10n.chatsUnpin : l10n.chatsPin,
      ),
      secondaryBackground: _SwipeBackground(
        alignment: AlignmentDirectional.centerEnd,
        color: context.scheme.onSurfaceVariant,
        icon: Icons.more_horiz_rounded,
        label: l10n.chatsMoreActions,
      ),
      child: child,
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final AlignmentGeometry alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: Insets.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: Insets.xs),
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// "All / Unread N" pills under the Chats title.
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filter,
    required this.unreadCount,
    required this.onChanged,
  });

  final ChatFilter filter;
  final int unreadCount;
  final ValueChanged<ChatFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.sm),
      child: Row(
        children: [
          FilterPill(
            label: l10n.chatsFilterAll,
            selected: filter == ChatFilter.all,
            onTap: () => onChanged(ChatFilter.all),
          ),
          const SizedBox(width: Insets.sm),
          FilterPill(
            label: unreadCount > 0
                ? l10n.chatsFilterUnreadCount(unreadCount)
                : l10n.chatsFilterUnread,
            selected: filter == ChatFilter.unread,
            onTap: () => onChanged(ChatFilter.unread),
          ),
        ],
      ),
    );
  }
}

/// WhatsApp-style filter pill: a soft green fill when selected, an outlined
/// capsule otherwise.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bg = selected
        ? (isDark
              ? AppColors.signal.withValues(alpha: 0.22)
              : AppColors.signalTint)
        : Colors.transparent;
    final fg = selected
        ? (isDark ? AppColors.signal : AppColors.deepForest)
        : context.scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : Motion.fast,
          curve: Motion.standard,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(
              color: selected ? Colors.transparent : context.scheme.outline,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.text.labelLarge?.copyWith(
              fontSize: 15,
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// One conversation row: large avatar, bold name, two-line preview, time on
/// the end side, a green unread-count badge and/or a pin glyph under it, and
/// WhatsApp-style delivery ticks for outbound last messages.
class ChatRow extends StatelessWidget {
  const ChatRow({
    super.key,
    required this.conversation,
    required this.unreadCount,
    required this.onTap,
    this.onLongPress,
  });

  static const double avatarRadius = 27;

  final Conversation conversation;

  /// 0 = read; otherwise printed in the green badge.
  final int unreadCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  bool get unread => unreadCount > 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final conv = conversation;
    final preview = messagePreview(
      context,
      conv.lastMessageType,
      conv.lastMessageBody,
      direction: conv.lastMessageDirection,
    );
    final when = conv.lastMessageAtDate;
    final outbound = conv.lastMessageDirection == MessageDirection.outbound;
    // Only non-WhatsApp channels get a badge — the API defaults the field to
    // 'whatsapp', so gating on non-null alone would paint a glyph on every
    // row (same rule as the bubble meta icon).
    final channel = conv.lastMessageChannelType;
    final channelType = (channel != null && channel != 'whatsapp')
        ? channel
        : null;
    final muted = context.scheme.onSurfaceVariant;
    final timeColor = unread ? AppColors.signalDeep : muted;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InitialsAvatar(initials: conv.initials, radius: avatarRadius),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          // Script-driven bidi order, but keep the name on
                          // the row's start edge (an RTL name would otherwise
                          // hug the time column).
                          textDirection: Fmt.textDirectionFor(conv.displayName),
                          textAlign:
                              Directionality.of(context) == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                          style: context.text.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (when != null) ...[
                        const SizedBox(width: Insets.sm),
                        Text(
                          Fmt.listTimestamp(context, when),
                          style: context.text.labelMedium?.copyWith(
                            color: timeColor,
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (channelType != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            channelIcon(channelType),
                            size: 15,
                            color: channelColor(channelType),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (outbound) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DeliveryTicks(
                            status: conv.lastMessageStatus,
                            color: muted,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: Fmt.textDirectionFor(preview),
                          style: context.text.bodyMedium?.copyWith(
                            fontSize: 15,
                            height: 1.3,
                            color: unread ? context.scheme.onSurface : muted,
                            fontWeight: unread
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      if (unread) UnreadBadge(count: unreadCount),
                      if (conv.isPinned) ...[
                        if (unread) const SizedBox(width: Insets.xs),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.push_pin_rounded,
                            size: 16,
                            color: muted,
                            semanticLabel: l10n.chatsPinned,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// WhatsApp-style green count pill ("3", "99+").
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.signal,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w700,
          color: AppColors.deepForest,
        ),
      ),
    );
  }
}

/// Delivery ticks for an outbound last message, mirroring the bubble meta:
/// one tick sent, two delivered, two tinted read, error glyph failed.
/// Unknown status (older servers) falls back to a single tick.
class DeliveryTicks extends StatelessWidget {
  const DeliveryTicks({super.key, required this.status, required this.color});

  final MessageStatus? status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.read:
        return Icon(Icons.done_all_rounded, size: 16, color: AppColors.lilac);
      case MessageStatus.delivered:
        return Icon(Icons.done_all_rounded, size: 16, color: color);
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline_rounded,
          size: 16,
          color: AppColors.ember,
        );
      case MessageStatus.sent:
      case MessageStatus.received:
      case null:
        return Icon(Icons.check_rounded, size: 16, color: color);
    }
  }
}
