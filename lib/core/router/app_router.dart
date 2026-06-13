import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/tenant_picker_screen.dart';
import '../../features/chats/chat_detail_screen.dart';
import '../../features/chats/chats_screen.dart';
import '../../features/clients/clients_screen.dart';
import '../../features/inbox/inbox_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/shell/home_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  // Rebuild routing decisions when auth status changes.
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final loc = state.matchedLocation;

      switch (status) {
        case AuthStatus.bootstrapping:
          return loc == '/splash' ? null : '/splash';
        case AuthStatus.unauthenticated:
          return loc == '/login' ? null : '/login';
        case AuthStatus.needsTenant:
          return loc == '/select-tenant' ? null : '/select-tenant';
        case AuthStatus.authenticated:
          if (loc == '/splash' ||
              loc == '/login' ||
              loc == '/select-tenant') {
            return '/chats';
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/select-tenant',
        builder: (_, _) => const TenantPickerScreen(),
      ),
      GoRoute(
        path: '/chats/:clientId',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            ChatDetailScreen(clientId: state.pathParameters['clientId']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(path: '/clients', builder: (_, _) => const ClientsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/chats', builder: (_, _) => const ChatsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/inbox', builder: (_, _) => const InboxScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (_, _) => const NotificationsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Bridges Riverpod auth-state changes to go_router's [refreshListenable].
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    _sub = ref.listen<AuthState>(
      authControllerProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
