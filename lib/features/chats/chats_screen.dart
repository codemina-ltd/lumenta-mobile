import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'chats_controller.dart';
import 'message_preview.dart';

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
      if (_scroll.position.pixels >=
          _scroll.position.maxScrollExtent - 320) {
        ref.read(chatsControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(chatsControllerProvider);
    final controller = ref.read(chatsControllerProvider.notifier);
    final lastRead = ref.watch(lastReadStoreProvider);

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
    if (state.items.isEmpty) {
      return EmptyState(
        title: l10n.chatsEmpty,
        message: l10n.searchClients,
        icon: Icons.forum_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.only(bottom: Insets.lg),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 80,
          endIndent: Insets.lg,
          color: context.scheme.outlineVariant,
        ),
        itemBuilder: (context, i) {
          if (i >= state.items.length) {
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
          final conv = state.items[i];
          final preview = messagePreview(
            context,
            conv.lastMessageType,
            conv.lastMessageBody,
            direction: conv.lastMessageDirection,
          );
          final when = conv.lastMessageAtDate;
          final inbound =
              conv.lastMessageDirection == MessageDirection.inbound;
          final unread = inbound && lastRead.isUnread(conv.clientId, when);

          return _ChatRow(
            initials: conv.initials,
            name: conv.displayName,
            preview: preview,
            when: when,
            unread: unread,
            outbound: !inbound,
            onTap: () => context.go('/chats/${conv.clientId}'),
          );
        },
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.initials,
    required this.name,
    required this.preview,
    required this.when,
    required this.unread,
    required this.outbound,
    required this.onTap,
  });

  final String initials;
  final String name;
  final String preview;
  final DateTime? when;
  final bool unread;
  final bool outbound;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeColor = unread
        ? AppColors.signalDeep
        : context.scheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InitialsAvatar(initials: initials, radius: 26),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (outbound) ...[
                        Icon(
                          Icons.subdirectory_arrow_right_rounded,
                          size: 14,
                          color: context.scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                      ],
                      Expanded(
                        child: Text(
                          preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodyMedium?.copyWith(
                            color: unread
                                ? context.scheme.onSurface
                                : context.scheme.onSurfaceVariant,
                            fontWeight:
                                unread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (when != null)
                  Text(
                    Fmt.listTimestamp(context, when!),
                    style: context.text.labelSmall?.copyWith(
                      color: timeColor,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: Insets.sm),
                if (unread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.signal,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
