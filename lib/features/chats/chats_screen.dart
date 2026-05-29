import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';
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
      return const Center(child: CircularProgressIndicator());
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
        message: l10n.chatsEmpty,
        icon: Icons.forum_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
        itemBuilder: (context, i) {
          if (i >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final conv = state.items[i];
          final preview = messagePreview(
            context,
            conv.lastMessageType,
            conv.lastMessageBody,
          );
          final when = conv.lastMessageAtDate;
          final inbound =
              conv.lastMessageDirection == MessageDirection.inbound;
          final unread = inbound && lastRead.isUnread(conv.clientId, when);

          return ListTile(
            leading: InitialsAvatar(initials: conv.initials),
            title: Text(
              conv.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            subtitle: Text(
              preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (when != null)
                  Text(
                    Fmt.listTimestamp(context, when),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                const SizedBox(height: 6),
                if (unread)
                  const CircleAvatar(radius: 5, backgroundColor: AppColors.signal)
                else
                  const SizedBox(height: 10),
              ],
            ),
            onTap: () => context.go('/chats/${conv.clientId}'),
          );
        },
      ),
    );
  }
}
