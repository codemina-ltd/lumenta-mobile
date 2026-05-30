import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../notifications/notifications_controller.dart';
import '../push/push_service.dart';

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

    final titles = [l10n.navClients, l10n.navChats, l10n.navNotifications];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[navigationShell.currentIndex]),
        actions: [
          if (auth.activeTenant != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  auth.activeTenant!.name,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'switch') {
                context.go('/select-tenant');
              } else if (value == 'logout') {
                // Unregister the device while the token is still valid, then
                // clear the session.
                await ref.read(pushServiceProvider).deregister();
                await ref.read(authControllerProvider.notifier).logout();
              }
            },
            itemBuilder: (context) => [
              if (auth.tenants.length > 1)
                PopupMenuItem(
                  value: 'switch',
                  child: Row(
                    children: [
                      const Icon(Icons.swap_horiz, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.switchTenant),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.navClients,
          ),
          NavigationDestination(
            icon: const Icon(Icons.forum_outlined),
            selectedIcon: const Icon(Icons.forum),
            label: l10n.navChats,
          ),
          NavigationDestination(
            icon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              child: const Icon(Icons.notifications_none),
            ),
            selectedIcon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              child: const Icon(Icons.notifications),
            ),
            label: l10n.navNotifications,
          ),
        ],
      ),
    );
  }
}
