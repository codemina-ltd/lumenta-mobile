import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../data/storage/last_read_store.dart';
import '../auth/auth_controller.dart';
import '../chats/chats_controller.dart';
import '../chats/widgets/new_chat_sheet.dart';
import '../notifications/notifications_controller.dart';
import '../reminders/reminders_controller.dart';
import '../shared/tenant_features.dart';
import '../you/you_screen.dart';
import 'app_nav_bar.dart';
import 'tab_header.dart';

/// Tab indexes of the shell branches (must match the router's branch order).
abstract final class HomeTab {
  static const chats = 0;
  static const reminders = 1;
  static const you = 2;
  static const notifications = 3;
}

/// App chrome for the four primary tabs, WhatsApp-style: each tab gets a
/// large-title masthead with round actions ([TabHeader]) instead of a
/// Material app bar, and a floating pill dock ([AppNavBar]) at the bottom.
/// Body is the branch's [navigationShell].
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    // Kick off (and keep warm) the tenant feature flags as soon as the shell
    // mounts — chat screens read them synchronously via .value.
    ref.watch(tenantFeaturesProvider);
    final unread = ref.watch(
      notificationsControllerProvider.select((s) => s.unreadCount),
    );
    // Overdue + due-today — what the operator should look at right now.
    final remindersDue = ref.watch(
      remindersControllerProvider.select((s) => s.dueCount),
    );
    final index = navigationShell.currentIndex;

    return Scaffold(
      body: Column(
        children: [
          _header(context, ref, l10n, index, unread, auth.tenants.length > 1),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: AppNavBar(
        selectedIndex: index,
        onSelect: (i) =>
            navigationShell.goBranch(i, initialLocation: i == index),
        destinations: [
          AppNavDestination(
            icon: Icons.chat_bubble_outline_rounded,
            selectedIcon: Icons.chat_bubble_rounded,
            label: l10n.navChats,
          ),
          AppNavDestination(
            icon: Icons.alarm_outlined,
            selectedIcon: Icons.alarm_rounded,
            label: l10n.navReminders,
            badgeCount: remindersDue,
          ),
          AppNavDestination(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: l10n.navYou,
            avatar: UserAvatar(user: auth.user, radius: 11),
          ),
          AppNavDestination(
            icon: Icons.notifications_none_rounded,
            selectedIcon: Icons.notifications_rounded,
            label: l10n.navNotifications,
            badgeCount: unread,
          ),
        ],
      ),
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int index,
    int unreadNotifications,
    bool canSwitch,
  ) {
    switch (index) {
      case HomeTab.chats:
        return TabHeader(
          title: l10n.navChats,
          leading: [
            HeaderMenuButton<_ChatsMenu>(
              tooltip: l10n.chatsMoreActions,
              items: [
                headerMenuItem(
                  _ChatsMenu.markAllRead,
                  Icons.done_all_rounded,
                  l10n.markAllRead,
                ),
                headerMenuItem(
                  _ChatsMenu.clients,
                  Icons.people_alt_outlined,
                  l10n.navClients,
                ),
                if (canSwitch)
                  headerMenuItem(
                    _ChatsMenu.switchWorkspace,
                    Icons.swap_horiz_rounded,
                    l10n.switchTenant,
                  ),
              ],
              onSelected: (value) => _onChatsMenu(context, ref, value),
            ),
          ],
          trailing: [
            HeaderCircleButton(
              icon: Icons.search_rounded,
              tooltip: l10n.searchGlobalTitle,
              onPressed: () => context.push('/search'),
            ),
            HeaderCircleButton(
              icon: Icons.add_rounded,
              tooltip: l10n.chatsNewChat,
              primary: true,
              onPressed: () => showNewChatSheet(context),
            ),
          ],
        );
      case HomeTab.reminders:
        return TabHeader(title: l10n.navReminders);
      case HomeTab.you:
        return TabHeader(title: l10n.navYou);
      case HomeTab.notifications:
      default:
        return TabHeader(
          title: l10n.navNotifications,
          trailing: [
            // One-tap "mark all as read" while there are unread items. The
            // controller updates state optimistically.
            if (unreadNotifications > 0)
              HeaderCircleButton(
                icon: Icons.done_all_rounded,
                tooltip: l10n.markAllRead,
                onPressed: () => ref
                    .read(notificationsControllerProvider.notifier)
                    .markAllRead(),
              ),
          ],
        );
    }
  }

  void _onChatsMenu(BuildContext context, WidgetRef ref, _ChatsMenu value) {
    switch (value) {
      case _ChatsMenu.markAllRead:
        // Advance the on-device cursor for every loaded chat.
        final items = ref.read(chatsControllerProvider).items;
        ref.read(lastReadStoreProvider.notifier).markAllRead({
          for (final c in items)
            if (c.lastMessageAtDate != null) c.clientId: c.lastMessageAtDate!,
        });
      case _ChatsMenu.clients:
        context.push('/clients');
      case _ChatsMenu.switchWorkspace:
        ref.read(authControllerProvider.notifier).switchTenant();
    }
  }
}

enum _ChatsMenu { markAllRead, clients, switchWorkspace }
