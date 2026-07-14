import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_controller.dart';
import '../notifications/notifications_controller.dart';
import '../push/push_service.dart';
import '../reminders/reminders_controller.dart';

/// App chrome for the three primary tabs: app bar (workspace switch + logout)
/// and a bottom navigation bar. Body is the branch's [navigationShell].
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final unread = ref.watch(
      notificationsControllerProvider.select((s) => s.unreadCount),
    );
    // Overdue + due-today — what the operator should look at right now.
    final remindersDue = ref.watch(
      remindersControllerProvider.select((s) => s.dueCount),
    );

    final titles = [
      l10n.navClients,
      l10n.navChats,
      l10n.navInbox,
      l10n.navReminders,
      l10n.navNotifications,
    ];
    final index = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: Insets.lg,
        title: Text(titles[index]),
        actions: [
          // On the notifications tab, offer a one-tap "mark all as read" while
          // there are unread items. The controller updates state optimistically.
          if (index == 4 && unread > 0)
            IconButton(
              icon: const Icon(Icons.done_all_rounded),
              tooltip: l10n.markAllRead,
              onPressed: () => ref
                  .read(notificationsControllerProvider.notifier)
                  .markAllRead(),
            ),
          if (auth.activeTenant != null)
            _WorkspaceMenu(
              name: auth.activeTenant!.name,
              canSwitch: auth.tenants.length > 1,
              onProfile: () => context.push('/profile'),
              onSwitch: () => context.go('/select-tenant'),
              onLogout: () async {
                // Unregister the device while the token is still valid, then
                // clear the session.
                await ref.read(pushServiceProvider).deregister();
                await ref.read(authControllerProvider.notifier).logout();
              },
            ),
          const SizedBox(width: Insets.sm),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.scheme.outlineVariant),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == index,
          ),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.people_alt_outlined),
              selectedIcon: const Icon(Icons.people_alt_rounded),
              label: l10n.navClients,
            ),
            NavigationDestination(
              icon: const Icon(Icons.forum_outlined),
              selectedIcon: const Icon(Icons.forum_rounded),
              label: l10n.navChats,
            ),
            NavigationDestination(
              icon: const Icon(Icons.inbox_outlined),
              selectedIcon: const Icon(Icons.inbox_rounded),
              label: l10n.navInbox,
            ),
            NavigationDestination(
              icon: Badge.count(
                count: remindersDue,
                isLabelVisible: remindersDue > 0,
                backgroundColor: AppColors.ember,
                child: const Icon(Icons.alarm_outlined),
              ),
              selectedIcon: Badge.count(
                count: remindersDue,
                isLabelVisible: remindersDue > 0,
                backgroundColor: AppColors.ember,
                child: const Icon(Icons.alarm_rounded),
              ),
              label: l10n.navReminders,
            ),
            NavigationDestination(
              icon: Badge.count(
                count: unread,
                isLabelVisible: unread > 0,
                backgroundColor: AppColors.ember,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              selectedIcon: Badge.count(
                count: unread,
                isLabelVisible: unread > 0,
                backgroundColor: AppColors.ember,
                child: const Icon(Icons.notifications_rounded),
              ),
              label: l10n.navNotifications,
            ),
          ],
        ),
      ),
    );
  }
}

/// The active-workspace chip in the app bar; tapping opens switch / logout.
class _WorkspaceMenu extends StatelessWidget {
  const _WorkspaceMenu({
    required this.name,
    required this.canSwitch,
    required this.onProfile,
    required this.onSwitch,
    required this.onLogout,
  });

  final String name;
  final bool canSwitch;
  final VoidCallback onProfile;
  final VoidCallback onSwitch;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      tooltip: name,
      position: PopupMenuPosition.under,
      offset: const Offset(0, Insets.sm),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Radii.md)),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          onProfile();
        } else if (value == 'switch') {
          onSwitch();
        } else if (value == 'logout') {
          onLogout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 20),
              const SizedBox(width: Insets.md),
              Text(l10n.profileTitle),
            ],
          ),
        ),
        if (canSwitch)
          PopupMenuItem(
            value: 'switch',
            child: Row(
              children: [
                const Icon(Icons.swap_horiz_rounded, size: 20),
                const SizedBox(width: Insets.md),
                Text(l10n.switchTenant),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 20, color: AppColors.ember),
              const SizedBox(width: Insets.md),
              Text(l10n.logout),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.sm, Insets.sm),
        decoration: BoxDecoration(
          color: context.scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspaces_rounded,
                size: 16, color: AppColors.signalDeep),
            const SizedBox(width: Insets.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelLarge?.copyWith(fontSize: 13),
              ),
            ),
            Icon(Icons.expand_more_rounded,
                size: 18, color: context.scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
